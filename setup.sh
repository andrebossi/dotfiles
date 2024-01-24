#!/usr/bin/env bash

initVars() {
  : ${USE_SUDO:="true"}
  INSTALL_DIR="/usr/local/bin"
  WORKDIR="/tmp/setup"
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)
  if grep -q -i "ID_LIKE=debian" /etc/os-release ; then
    DEBIAN=true
    runAsRoot apt-get install -y ca-certificates curl gnupg apt-transport-https lsb-release unzip
    runAsRoot mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | runAsRoot gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    runAsRoot chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      runAsRoot tee /etc/apt/sources.list.d/docker.list > /dev/null
    runAsRoot apt-get update 
    runAsRoot apt-get install -y containerd.io docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin
    runAsRoot systemctl enable containerd --now
    runAsRoot systemctl enable docker --now
  elif grep -q -i "ID=openSUSE" /etc/os-release ; then
    OPENSUSE=true
  fi
  case $ARCH in
    armv5*) ARCH="armv5";;
    armv6*) ARCH="armv6";;
    armv7*) ARCH="arm";;
    aarch64) ARCH="arm64";;
    x86) ARCH="386";;
    x86_64) ARCH="amd64";;
    i686) ARCH="386";;
    i386) ARCH="386";;
  esac
}

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

runAsRoot() {
  local CMD="$*"

  if [ $EUID -ne 0 -a $USE_SUDO = "true" ]; then
    echo $CMD
    CMD="sudo $CMD"
  fi

  $CMD
}

# First parameter update apps
UPDATE=$1
if [ -z "$UPDATE" ]; then
  UPDATE=0
else
  echo "Upgrade latest version"
fi

# Setup init
initVars
if [ -d "$WORKDIR" ]; then
  rm -rf $WORKDIR
fi
mkdir $WORKDIR && cd $WORKDIR

# Install jq
if ([ ! -f "$INSTALL_DIR/jq" ] || [ $UPDATE == "1" ]); then
  wget https://github.com/stedolan/jq/releases/latest/download/jq-linux64 -O jq
  runAsRoot install -o root -g root -m 0755 jq "$INSTALL_DIR/jq"
fi

# Install yq
if ([ ! -f "$INSTALL_DIR/yq" ] || [ $UPDATE == "1" ]); then
  wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O yq
  runAsRoot install -o root -g root -m 0755 yq "$INSTALL_DIR/yq"
fi

# Install Kubectl
if ([ ! -f "$INSTALL_DIR/kubectl" ] || [ $UPDATE == "1" ]); then
  echo "Install kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  runAsRoot install -o root -g root -m 0755 kubectl "$INSTALL_DIR/kubectl"
fi

# Install Helm
if ([ ! -f "$INSTALL_DIR/helm" ] || [ $UPDATE == "1" ]); then
  echo "Install helm"
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install Kind
if ([ ! -f "$INSTALL_DIR/kind" ] || [ $UPDATE == "1" ]); then
  echo "Install Kind"
  KIND_LATEST=$(get_latest_release "kubernetes-sigs/kind")
  curl -sSL -o kind "https://github.com/kubernetes-sigs/kind/releases/download/$KIND_LATEST/kind-${OS}-${ARCH}"
  runAsRoot install -o root -g root -m 0755 kind "$INSTALL_DIR/kind"
fi

# Install Velero
if ([ ! -f "$INSTALL_DIR/velero" ] || [ $UPDATE == "1" ]); then
  echo "Install velero"
  VELERO_LATEST=$(get_latest_release "vmware-tanzu/velero")
  curl -sSL -o velero.tar.gz "https://github.com/vmware-tanzu/velero/releases/latest/download/velero-$VELERO_LATEST-${OS}-${ARCH}.tar.gz"
  tar -xvf velero.tar.gz --strip-components 1
  runAsRoot install -o root -g root -m 0755 velero "$INSTALL_DIR/velero"
fi

# Install Terraform
if ([ ! -f "$INSTALL_DIR/terraform" ] || [ $UPDATE == "1" ]); then
  echo "Install Terraform"
  TF_VERSION=$(get_latest_release "hashicorp/terraform")
  TF_VERSION=${TF_VERSION:1}
  URL_TERRAFORM_LATEST="https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_${OS}_${ARCH}.zip"
  curl -o terraform.zip $URL_TERRAFORM_LATEST
  unzip terraform.zip
  runAsRoot install -o root -g root -m 0755 terraform "$INSTALL_DIR/terraform"
fi

# Install ArgoCLI
if ([ ! -f "$INSTALL_DIR/argocd" ] || [ $UPDATE == "1" ]); then
  echo "Install ArgoCLI"
  curl -sSL -o argocd-${OS}-${ARCH} "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-${OS}-${ARCH}"
  runAsRoot install -m 555 argocd-${OS}-${ARCH} "$INSTALL_DIR/argocd"
  rm argocd-${OS}-${ARCH}
fi

# Install ArgoCLI Rollout
if ([ ! -f "$INSTALL_DIR/kubectl-argo-rollouts" ] || [ $UPDATE == "1" ]); then
  echo "Install Argo Rollouts"
  curl -LO "https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-${OS}-${ARCH}"
  runAsRoot install -m 755 kubectl-argo-rollouts-${OS}-${ARCH} "$INSTALL_DIR/kubectl-argo-rollouts"
fi

# Install kubectx
if ([ ! -f "$INSTALL_DIR/kubectx" ] || [ $UPDATE == "1" ]); then
  echo "Install kubectx"
  KUBECTX_LATEST=$(get_latest_release "ahmetb/kubectx")
  curl -sSL -o kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/$KUBECTX_LATEST/kubectx_${KUBECTX_LATEST}_${OS}_x86_64.tar.gz
  tar xf kubectx.tar.gz
  runAsRoot install -m 555 kubectx "$INSTALL_DIR/kubectx"
fi

# Install kubens
if ([ ! -f "$INSTALL_DIR/kubens" ] || [ $UPDATE == "1" ]); then
  echo "Install kubens"
  KUBENS_LATEST=$(get_latest_release "ahmetb/kubectx")
  curl -sSL -o kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/$KUBENS_LATEST/kubens_${KUBENS_LATEST}_${OS}_x86_64.tar.gz
  tar xf kubens.tar.gz
  runAsRoot install -m 555 kubens "$INSTALL_DIR/kubens"
fi

# Install Pyenv
if [ $UPDATE == "pyenv" ]; then
  if [ ! -z $DEBIAN ] ; then
    sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev curl \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    curl https://pyenv.run | bash
  fi
fi
