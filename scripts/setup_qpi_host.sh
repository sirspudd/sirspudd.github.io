#!/usr/bin/env bash

set -u
set -e

script_dir="$(dirname "$(readlink -f "$0")")"
local_repo=${script_dir}/local

sanity_check() {
  if [[ "$(whoami)" != "root" ]]; then
    echo "This needs to be run as root"
    exit -1
  fi

  if [[ -n "$(uname -a | grep arm)" ]]; then
    echo "This script is intended for the host, not the pi"
    exit -1
  fi
}

install_qpi_repo() {
cat <<EOF >> /etc/pacman.conf

[qpi]
SigLevel = Optional
Server = http://s3.amazonaws.com/spuddrepo/arch/\$arch
EOF
}

sanity_check
# Add our arch repo
install_qpi_repo
pacman -Sy
pacman -S qt-sdk-raspberry-pi2 --noconfirm
