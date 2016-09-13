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

  if [[ -z "$(uname -a | grep x86)" ]]; then
    echo "This script is intended for the host, not the pi"
    exit -1
  fi
}

install_qpi_repo() {
cat <<EOF >> /etc/pacman.conf

[qpi]
SigLevel = Optional
Server = http://s3.amazonaws.com/spuddrepo/repo/\$arch
EOF
}

sanity_check
# Add our arch repo
install_qpi_repo
pacman -Sy

echo "Add qpi repo"
echo "Available packages"
pacman -Sl qpi
echo "Install qt-sdk-raspberry-pi[1/2/3] as desired"
