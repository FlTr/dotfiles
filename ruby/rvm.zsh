[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
path=($HOME/.rvm/bin "$path[@]") # add RVM to PATH for scripting at beginning
[[ -d "$HOME/.rvm/scripts/zsh/Completion" ]] && fpath=("$HOME/.rvm/scripts/zsh/Completion" $fpath)
