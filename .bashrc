export PATH=$PATH:/usr/local/go/bin

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.profiles ]; then
    . ~/.profile
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
