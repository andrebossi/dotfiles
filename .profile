# Sample .profile for SuSE Linux
# rewritten by Christian Steinruecken <cstein@suse.de>
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile || true

# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
#export LANG=de_DE.UTF-8	# uncomment this line for German output
#export LANG=fr_FR.UTF-8	# uncomment this line for French output
#export LANG=es_ES.UTF-8	# uncomment this line for Spanish output


# Some people don't like fortune. If you uncomment the following lines,
# you will have a fortune each time you log in ;-)

#if [ -x /usr/bin/fortune ] ; then
#    echo
#    /usr/bin/fortune
#    echo
#fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/tbs/.local/share/google-cloud-sdk/path.bash.inc' ]; then . '/home/tbs/.local/share/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/tbs/.local/share/google-cloud-sdk/completion.bash.inc' ]; then . '/home/tbs/.local/share/google-cloud-sdk/completion.bash.inc'; fi

# Auto complete tools
## kubectl
complete -o default -F __start_kubectl k
source <(kubectl completion bash)
## velero
source <(velero completion bash)
complete -F __start_velero v
# Helm
source <(helm completion bash)
# K3D
source <(k3d completion bash)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
