if [ "$(uname -s)" = "Darwin" ]; then
  alias ls="gls --color=auto"
else
  alias ls="ls --color=auto"
fi
alias l="ls -FC"
alias ll="ls -Falh"
alias la="ls -FA"
alias lt="ls -Ft"
alias ly="ls | awk '{y = \$NF; gsub(/\\(|\\)/, \"\", y); print y, \$0}' | sort -k1,1nr -k2,2 | cut -d \" \" -f2-"
alias grep="grep --color=auto"
