# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' completer _complete _correct _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# complete 'cd ..<TAB>' to 'cd ../'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

# complete with colors
if [ "$(uname)" = "Darwin" ] ; then
  eval "$(gdircolors -b)"
else
  eval "$(dircolors -b)"
fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# enable interactive selection (after 3rd tab)
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %p%s

# complete hard drives in msys2
[ -n "$MSYSTEM" ] && (
  drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
  zstyle ':completion:*' fake-files /: "/:$drives"
)
