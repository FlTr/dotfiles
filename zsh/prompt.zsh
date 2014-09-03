autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] )) ; then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_dirty () {
  [ -n "$NO_GIT_PROMPT" ] && return

  local st
  st=$($git status --porcelain 2>&1)
  case $st in
    fatal*)
      echo ""
      ;;
    "")
      echo "[%{$fg[green]%}$(git_prompt_info)%{$reset_color%}]"
      ;;
    *)
      echo "[%{$fg[red]%}$(git_prompt_info)%{$reset_color%}]"
      ;;
  esac
}

git_prompt_info () {
  local ref
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  [ -n "$NO_GIT_PROMPT" ] && return

  if [[ $(unpushed) == "" ]] ; then
    echo ""
  else
    echo "%{$fg_bold[magenta]%}^%{$reset_color%}"
  fi
}

directory_name () {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

prompt_prefix () {
  echo "%{$fg_bold[green]%}~>%{$reset_color%}"
}

export PROMPT=$'$(prompt_prefix) $(directory_name) › '
export RPROMPT='$(need_push)$(git_dirty)'
if (( $+commands[rbenv] ))
then
  export RPROMPT=$RPROMPT'(%{$fg[yellow]%}$(rbenv version-name)%{$reset_color%})'
fi

precmd () {
  # set title if not in tmux
  [ -n "$TMUX" ] || title "zsh" "$USER@%m" "%55<...<%~"
}

preexec () {
  [ -n "$TMUX" ] || title "$1" "$USER@%m" "%35<...<%~"
}

# vim: ts=2:sw=2
