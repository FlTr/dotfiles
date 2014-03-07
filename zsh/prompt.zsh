autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

# git-prompt.zsh
# http://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-prompt.sh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_dirty() {
  local st
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]] ; then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
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
  if [[ $(unpushed) == "" ]] ; then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

directory_name () {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

prompt_prefix () {
  echo "%{$fg_bold[green]%}~>%{$reset_color%}"
}

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
#export PROMPT=$'\n$(prompt_prefix) $(directory_name) $(git_dirty)$(need_push)\n› '
#export PROMPT=$'$(prompt_prefix) $(directory_name) $(__git_ps1 "(%s)")\n› '
if which rvm-prompt > /dev/null
then
  export RPROMPT='(%{$fg[yellow]%}$(rvm-prompt)%{$reset_color%})'
fi

precmd () {
  # update PS1
  __git_ps1 $'$(prompt_prefix) $(directory_name)' $'\n› '

  # set title if not in tmux
  [ -n "$TMUX" ] || title "zsh" "$USER@%m" "%55<...<%~"
}

preexec () {
  [ -n "$TMUX" ] || title "$1" "$USER@%m" "%35<...<%~"
}

# vim: ts=2:sw=2
