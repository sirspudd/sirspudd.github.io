#!/usr/bin/env bash

set -u
#set -e

script_dir="$(dirname "$(readlink -f "$0")")"
local_repo=${script_dir}/local

sanity_check() {
  if [[ "$(whoami)" != "root" ]]; then
    echo "This needs to be run as root"
    exit -1
  fi

  if [[ -n "$(uname -a | grep x86)" ]]; then
    echo "This script is intended for the pi, not the host"
    exit -1
  fi

  echo "Achtung! Chips! Heads! Fire! Compound fracture ahoy!"
  echo "This script: enables root login/exposes your rootfs vs NFS!"
  echo ""
  echo "This is gonna configure your device for development against the qt-sdk packages"
  echo "I urge you to read the script before proceeding and accept no responsibility for the fallout"
  echo ""
  echo "USE AT YOUR OWN RISK: Do you wish to proceed? [yespleaseonwards]"

  read i
  if [[ "$i" != "yespleaseonwards" ]]; then
    echo "Bailing for want of the magic phrase"
    exit 0
  fi
}

install_qpi_repo() {
cat <<EOF >> /etc/pacman.conf

[qpi]
SigLevel = Optional
Server = http://s3.amazonaws.com/spuddrepo/repo/\$arch
EOF
}

setup_avahi() {
  pacman -S avahi nss-mdns --noconfirm

case $(uname -m) in
armv6l)
  hostnamectl set-hostname qpi1
;;
aarch64)
  hostnamectl set-hostname qpi3
;;
*)
  hostnamectl set-hostname qpi2
;;
esac

  systemctl enable avahi-daemon
}

allow_root_login_ssh() {
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
  systemctl restart sshd
}

setup_nfs() {
# This is how I expose my sysroot to my main Arch machine
# It is provided as the gcc sysroot argument

# deliberately making it opt in

  pacman -S nfs-utils --noconfirm
  echo "/               *(rw,no_root_squash,fsid=0)" >> /etc/exports
  systemctl enable nfs-server
  exportfs -arv
}

setup_spudd_dev_env() {
  pacman -S zsh vim git rsync --noconfirm
  chsh -s /bin/zsh root
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  sed -i 's/robbyrussell/random/g' ~/.zshrc || true
}

setup_shairport() {
  pacman -S shairport-sync --noconfirm
  systemctl enable shairport-sync
}

setup_pi() {
  echo "gpu_mem=512" >> /boot/config.txt
  echo "#dtoverlay=hifiberry-dacplus" >> /boot/config.txt
}

sanity_check

# we are relying on hostname advertizing via mdns
setup_avahi
# required for compilation of Qt libs on host
setup_nfs
# we are initially deploying as root from creator
allow_root_login_ssh

# Things I enable on every pi I touch
#setup_spudd_dev_env
#setup_shairport
#setup_pi

# Add our arch repo
install_qpi_repo
pacman -Sy
pacman -S skunkjuice-git --noconfirm

systemctl enable pi-compositor@root
