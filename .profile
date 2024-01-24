export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH:/usr/local/go/bin"
# export LANG=de_DE.UTF-8

test -z "$PROFILEREAD" && . /etc/profile || true

if [ -f "/home/$USER/.local/share/google-cloud-sdk/path.bash.inc" ]; then . "/home/$USER/.local/share/google-cloud-sdk/path.bash.inc"; fi
if [ -f "/home/$USER/.local/share/google-cloud-sdk/completion.bash.inc" ]; then . "/home/$USER/.local/share/google-cloud-sdk/completion.bash.inc"; fi

# Auto complete tools
complete -o default -F __start_kubectl k
source <(kubectl completion bash)
source <(velero completion bash)
complete -F __start_velero v
source <(helm completion bash)
source <(kind completion bash)

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"