# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
#  alias git=$hub_path
fi

# The rest of my fun git aliases
alias g=git
alias ga='git add'
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s -%Creset%C(yellow)%d %Creset%Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff -M'
alias gds='git diff -M --staged'
alias gdw='git diff -M --word-diff=color'
alias gdt='git difftool --dir-diff' # --dir-diff needs git >= 1.7.11
alias gc='git commit'
alias gcv='git commit -v'
alias gca='git commit -a'
alias gcav='git commit -av'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           sed 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
alias gbak='git push --mirror backup'

# git-svn aliases
alias gsl='git svn rebase'
alias gsp='git svn dcommit'
