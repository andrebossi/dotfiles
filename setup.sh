#!/usr/bin/env bash

initVars() {
  : ${USE_SUDO:="true"}
  INSTALL_DIR="/usr/local/bin"
  WORKDIR="/tmp/setup"
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)
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

# Setup init
initVars
if [ -d "$WORKDIR" ]; then
  rm -rf $WORKDIR
fi
mkdir $WORKDIR && cd $WORKDIR

# Install Tools
runAsRoot zypper in -y jq yq curl

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
runAsRoot install -o root -g root -m 0755 kubectl "$INSTALL_DIR/kubectl"

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install Velero
VELERO_LATEST=$(get_latest_release "vmware-tanzu/velero")
VELERO_TARBALL_NAME=$(echo velero-$VELERO_LATEST-${OS}-${ARCH}.tar.gz)
curl -LO "https://github.com/vmware-tanzu/velero/releases/download/$VELERO_LATEST/$VELERO_TARBALL_NAME"
tar -xvf $VELERO_TARBALL_NAME --strip-components 1
runAsRoot install -o root -g root -m 0755 velero "$INSTALL_DIR/velero"

# Install Terraform
URL_TERRAFORM_LATEST=$(echo "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform |
    jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform |
    jq -r -M '.current_version')_${OS}_${ARCH}.zip")
curl -o terraform.zip $URL_TERRAFORM_LATEST
unzip terraform.zip
runAsRoot install -o root -g root -m 0755 terraform "$INSTALL_DIR/terraform"