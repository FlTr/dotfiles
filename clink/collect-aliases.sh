#!/usr/bin/env bash

cd "$(dirname "$0")/.."
ALIASES="$(pwd)/clink/aliases"

if [ -e $ALIASES ]; then
  rm $ALIASES
fi

# hijack alias to generate a doskey macrofile from aliases.zsh files
function alias () {
  echo $* '$*' | tr \' \" >> $ALIASES
}

for source in `find . -maxdepth 2 -path ./zsh -prune -false -o -name aliases.zsh`; do
  source "$source"
done

# add windows specifc aliases as well
cat win/aliases >> $ALIASES
