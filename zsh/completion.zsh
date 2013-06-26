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
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# enable interactive selection (after 3rd tab)
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %p%s
