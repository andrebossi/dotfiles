alias dotfiles="/usr/bin/git --git-dir=/home/$USER/.dotfiles/ --work-tree=/home/$USER"
alias dotfiles-add="dotfiles add \`dotfiles status -s -uno | sed -n 's/^...//p'\`"
alias clip='xclip -se c'
alias updistrodeb='apt-get update && apt-get upgrade -yq'
alias updistro='zypper ref && zypper up --no-confirm'
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

alias assumeloginfo='export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role \
--role-arn arn:aws:iam::221082183970:role/terraform-monitoring \
--role-session-name terraform --external-id 43a6aae4c101 \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text))'
