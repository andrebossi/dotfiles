alias clip='xclip -se c'
alias updistrodeb='apt-get update && apt-get upgrade -yq'
alias updistro='zypper ref && zypper up --no-confirm'
alias k='kubectl'
alias t='terraform'
alias v='velero'
alias dotfiles="/usr/bin/git --git-dir=/home/$USER/.dotfiles/ --work-tree=/home/$USER"
alias dotfiles-add="dotfiles add \`dotfiles status -s -uno | sed -n 's/^...//p'\`"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls --human-readable --size -1 -S --classify'

alias kderestart='killall plasmashell && kstart plasmashell &'