
local exports = {}

local path = require('path')
local w = require('tables').wrap

exports.dirs = clink.dirmatches

exports.files = clink.filematches

exports.create_dirs_matcher = function (dir_pattern, show_dotfiles)
    return function (token)
        return w(clink.find_dirs(dir_pattern))
        :filter(function(dir)
            return clink.is_match(token, dir) and (path.is_real_dir(dir) or show_dotfiles)
        end )
    end
end

exports.create_files_matcher = function (file_pattern)
    return function (token)
        return w(clink.find_files(file_pattern))
        :filter(function(file)
            -- Filter out '.' and '..' entries as well
            return clink.is_match(token, file) and path.is_real_dir(file)
        end )
    end
end

return exports
