autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

# cheers, @bliker
# https://github.com/bliker/cmder/blob/master/config/git.lua

if (( $+commands[git] )) ; then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_color () {
  if $git diff --quiet --ignore-submodules HEAD 2>&1 ; then
    echo "%{$fg[green]%}$1%{$reset_color%}"
  else
    echo "%{$fg[red]%}$1%{$reset_color%}"
  fi
}

git_untracked () {
  if $git status --porcelain | grep -q '^??' ; then
    echo "%{$fg[magenta]%}?%{$reset_color%}"
  fi
}

git_need_push () {
  if [[ $($git cherry -v @{upstream} 2>/dev/null) != "" ]] ; then
    echo "%{$fg[magenta]%}^%{$reset_color%}"
  fi
}

git_prompt () {
  local ref
  [ -n "$NO_GIT_PROMPT" ] && return

  ref=$($git symbolic-ref HEAD 2>/dev/null) || return

  ref="${ref#refs/heads/}"
  echo "[$(git_need_push)$(git_color $ref)$(git_untracked)]"
}

directory_name () {
  echo "%{$fg[cyan]%}%3~%{$reset_color%}"
}

prompt_prefix () {
  local prefix
  prefix=""

  if [[ "$SSH_CONNECTION" != "" ]] ; then
    prefix="(@%{$fg[yellow]%}%m%{$reset_color%}) "
  fi

  prefix=$prefix"%{$fg[green]%}~>%{$reset_color%}"
  echo $prefix
}

export PROMPT=$'$(prompt_prefix) $(directory_name) › '
export RPROMPT='$(git_prompt)'
if (( $+commands[rbenv] )) ; then
  export RPROMPT=$RPROMPT'(%{$fg[yellow]%}$(rbenv version-name)%{$reset_color%})'
fi

precmd () {
  # set title if not in tmux
  [ -n "$TMUX" ] || title "zsh" "$USER@%m" "%55<...<%~"
}

preexec () {
  [ -n "$TMUX" ] || title "$1" "$USER@%m" "%35<...<%~"
}

# vim: et:sw=2:sts=2
