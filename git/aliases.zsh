alias g=git
alias gf='git fetch --prune'
alias ga='git add'
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%C(red)%h%C(reset) %s %C(cyan)@%an%C(reset)%C(yellow)%d %C(reset)%C(green)(%cr)%C(reset)' --abbrev-commit --date=relative"
alias gp='git push'
alias gd='git diff -M'
alias gds='git diff -M --staged'
alias gdw='git diff -M --word-diff=color'
alias gdt='git difftool --dir-diff'
alias gc='git commit -v'
alias gca='git commit -av'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gs='git status -sb'
alias gsu='git submodule update'
alias gbak='git push --mirror backup'

# git-svn aliases
alias gsl='git svn rebase'
alias gsp='git svn dcommit'
