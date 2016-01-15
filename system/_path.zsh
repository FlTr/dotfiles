if [ "$(uname -s)" = "Darwin" ] ; then
  export PATH="$ZSH/bin:/usr/local/bin:$PATH"
else
  export PATH="$ZSH/bin:$PATH"
fi
