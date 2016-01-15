if [ "$(uname -s)" = "Darwin" ]; then
  alias ls="gls --color=auto"
else
  alias ls="ls --color=auto"
fi
alias l="ls -FC"
alias ll="ls -Falh"
alias la="ls -FA"
alias grep="grep --color=auto"
