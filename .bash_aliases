alias ansible_start='source ~/.ansible-venv/bin/activate'
alias lt='ls --human-readable --size -1 -S --classify'
alias clip='xclip -se c'
alias updistrodeb='apt-get update && apt-get upgrade -yq && apt-get autoclean && apt-get autoremove'
alias updistro='zypper ref && zypper up && zypper clear'
alias k='kubectl'
alias t='terraform'
alias kderestart='killall plasmashell && kstart plasmashell &'
alias v=velero
alias dotfiles="/usr/bin/git --git-dir=/home/$USER/.dotfiles/ --work-tree=/home/$USER"
alias dotfiles-add="dotfiles add \`dotfiles status -s -uno | sed -n 's/^...//p'\`"
