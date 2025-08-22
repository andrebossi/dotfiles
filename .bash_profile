# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
PATH="$HOME/.tfenv/bin:$HOME/.local/bin:$PATH"
source $HOME/.local/bin/kube-ps1.sh
PS1='[\u@\h \W $(kube_ps1)]\$ '