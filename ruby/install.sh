#!/usr/bin/env bash

if [[ ! -d "$HOME/.rbenv" ]]
then
  git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
fi

if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]
then
  git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi

if [[ ! -d "$HOME/.rbenv/plugins/ruby-each" ]]
then
  git clone https://github.com/chriseppstein/rbenv-each.git $HOME/.rbenv/plugins/ruby-each
fi
