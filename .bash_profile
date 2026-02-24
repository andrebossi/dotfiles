# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export PATH="$HOME/.istioctl/bin:$HOME/.tfenv/bin:$PATH:$HOME/.tofuenv/bin:$PATH"
