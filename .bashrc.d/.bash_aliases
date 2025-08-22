alias dotfiles="/usr/bin/git --git-dir=/home/$USER/.dotfiles/ --work-tree=/home/$USER"
alias dotfiles-add="dotfiles add \`dotfiles status -s -uno | sed -n 's/^...//p'\`"
alias xclip='xclip -sel clip'
alias k='kubectl'
alias t='terraform'
alias v='velero'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls --human-readable --size -1 -S --classify'
alias kns='kubens'
alias kx='kubectx'

alias kderestart='killall plasmashell && kstart plasmashell &'
alias gnomedump='dconf dump /'
alias nvidia-check-opensuse='kver=$(uname -r); found=$(rpm -q --qf "%{NAME} %{VERSION}\n" -a | grep nvidia-driver-G06-kmp-default | grep "$kver"); if [[ -n "$found" ]]; then echo "✅ KMP NVIDIA ok for kernel $kver"; else echo "❌ NO KMP NVIDIA for kernel: $kver"; echo "📦 KMPs installeds:"; rpm -q --qf "%{NAME} %{VERSION}\n" -a | grep nvidia-driver-G06-kmp-default; fi'
