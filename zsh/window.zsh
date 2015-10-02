# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  # Strip color codes
  a=$(print -Pn $a | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g")

  case $TERM in
  screen*)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt*)
    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}
