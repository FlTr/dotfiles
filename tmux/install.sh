#!/usr/bin/env bash

# Create screen-it terminfo to fix reverse-video instead of italics problem for
# urxvt/tmux combination.

mkdir $HOME/.terminfo
screen_terminfo="screen-256color"
infocmp "$screen_terminfo" | sed \
  -e 's/^screen[^|]*|[^,]*,/screen-it|screen with italics support,/' \
  -e 's/%?%p1%t;3%/%?%p1%t;7%/' \
  -e 's/smso=[^,]*,/smso=\\E[7m,/' \
  -e 's/rmso=[^,]*,/rmso=\\E[27m,/' \
  -e '$s/$/ sitm=\\E[3m, ritm=\\E[23m,/' > /tmp/screen.terminfo
tic /tmp/screen.terminfo
