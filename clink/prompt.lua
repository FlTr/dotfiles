--- Source: https://github.com/cmderdev/cmder/blob/master/vendor/clink.lua

---
-- Makes a string safe to use as the replacement in string.gsub
---
local function verbatim(s)
    s = string.gsub(s, "%%", "%%%%")
    return s
end

---
-- Setting the prompt in clink means that commands which rewrite the prompt do
-- not destroy our own prompt. It also means that started cmds (or batch files
-- which echo) don't get the ugly '{lamb}' shown.
---
local function set_prompt_filter()
    -- get_cwd() is differently encoded than the clink.prompt.value, so everything other than
    -- pure ASCII will get garbled. So try to parse the current directory from the original prompt
    -- and only if that doesn't work, use get_cwd() directly.
    -- The matching relies on the default prompt which ends in X:\PATH\PATH>
    -- (no network path possible here!)
    local old_prompt = clink.prompt.value
    local cwd = old_prompt:match('.*(.:[^>]*)>')
    if cwd == nil then cwd = clink.get_cwd() end

    -- environment systems like pythons virtualenv change the PROMPT and usually
    -- set some variable. But the variables are differently named and we would never
    -- get them all, so try to parse the env name out of the PROMPT.
    -- envs are usually put in round or square parentheses and before the old prompt
    local env = old_prompt:match('.*%(([^%)]+)%).+:')
    -- also check for square brackets
    if env == nil then env = old_prompt:match('.*%[([^%]]+)%].+:') end

    -- build our own prompt
    -- orig: $E[1;32;40m$P$S{git}{hg}$S$_$E[1;30;40m{lamb}$S$E[0m
    -- color codes: "\x1b[1;37;40m"
    local cmder_prompt = "\x1b[1;34m{cwd} {git} \n\x1b[0m{lamb} \x1b[0m"
    local lambda = "λ"
    cmder_prompt = string.gsub(cmder_prompt, "{cwd}", verbatim(cwd))

    if env ~= nil then
        lambda = "("..env..") "..lambda
    end
    clink.prompt.value = string.gsub(cmder_prompt, "{lamb}", verbatim(lambda))
end

-- adapted from from clink-completions' git.lua
local function get_git_dir(path)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end

        return prefix
    end

    -- Checks if provided directory contains git directory
    local function has_git_dir(dir)
        return clink.is_dir(dir..'/.git') and dir..'/.git'
    end

    local function has_git_file(dir)
        local gitfile = io.open(dir..'/.git')
        if not gitfile then return false end

        local git_dir = gitfile:read():match('gitdir: (.*)')
        gitfile:close()

        return git_dir and dir..'/'..git_dir
    end

    -- Set default path to current directory
    if not path or path == '.' then path = clink.get_cwd() end

    -- Calculate parent path now otherwise we won't be
    -- able to do that inside of logical operator
    local parent_path = pathname(path)

    return has_git_dir(path)
        or has_git_file(path)
        -- Otherwise go up one level and make a recursive call
        or (parent_path ~= path and get_git_dir(parent_path) or nil)
end

---
-- Find out current branch
-- @return {nil|git branch name}
---
local function get_git_branch(git_dir)
    git_dir = git_dir or get_git_dir()

    -- If git directory not found then we're probably outside of repo
    -- or something went wrong. The same is when head_file is nil
    local head_file = git_dir and io.open(git_dir..'/HEAD')
    if not head_file then return end

    local HEAD = head_file:read()
    head_file:close()

    -- if HEAD matches branch expression, then we're on named branch
    -- otherwise it is a detached commit
    local branch_name = HEAD:match('ref: refs/heads/(.+)')

    return branch_name or 'HEAD detached at '..HEAD:sub(1, 7)
end

---
-- Get the status setting
-- @return {bool}
---
local function get_git_status_setting()
    gitStatusSetting = io.popen("git --no-pager config -l 2>nul")

    for line in gitStatusSetting:lines() do
        if string.match(line, 'clink.status=false') then
            gitStatusSetting:close()
            return false
        end
    end
    gitStatusSetting:close()

    return true
end

---
-- Get the status of working dir
-- @return {bool}
---
local function get_git_status()
    local file = io.popen("git --no-optional-locks status --porcelain 2>nul")
    for line in file:lines() do
        file:close()
        return false
    end
    file:close()

    return true
end

---
-- Gets the conflict status
-- @return {bool} indicating true for conflict, false for no conflicts
---
function get_git_conflict()
    local file = io.popen("git diff --name-only --diff-filter=U 2>nul")
    for line in file:lines() do
        file:close()
        return true;
    end
    file:close()
    return false
end

local function git_prompt_filter()
    -- Colors for git status
    local colors = {
        clean = "\x1b[0m",
        dirty = "\x1b[33m",
        conflict = "\x1b[31m"
    }

    local git_dir = get_git_dir()

    if get_git_status_setting() then
        if git_dir then
            -- if we're inside of git repo then try to detect current branch
            local branch = get_git_branch(git_dir)
            local color
            if branch then
                -- Has branch => therefore it is a git folder, now figure out status
                local gitStatus = get_git_status()
                local gitConflict = get_git_conflict()

                color = colors.dirty
                if gitStatus then
                    color = colors.clean
                end

                if gitConflict then
                    color = colors.conflict
                end

                clink.prompt.value = string.gsub(clink.prompt.value, "{git}", color.."("..verbatim(branch)..")")
                return false
            end
        end
    end

    -- No git present or not in git file
    clink.prompt.value = string.gsub(clink.prompt.value, "{git}", "")
    return false
end

-- insert the set_prompt at the very beginning so that it runs first
clink.prompt.register_filter(set_prompt_filter, 1)
clink.prompt.register_filter(git_prompt_filter, 50)
