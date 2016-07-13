---
layout: page
title: QPi
permalink: /qpi/
---

# Setting up the Qt Arch SDK for the Raspberry Pi 0/1/2/3

## Overview

Qt can run quite nicely on the Pi(s), but the packaged versions shipped with most distros use Mesa out of the box, and people tend to run X11 on the pi for graphical purposes, and that seems like a damn shame given the GPU is decent and can actually do a fair amount.

The point of this exercise is to make 2 packages conveniently available, one for the Raspberry Pi and one for the host machine, which once installed allow you to cross compile for the Raspberry Pi from your Arch host machine.

The AUR recipes used to generate the installed packages are here (in case you are into that kind of thing):

## AUR recipes
[qt-sdk-raspberry-pi-target-libs,qt-sdk-raspberry-pi](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=qt-sdk-raspberry-pi)
[pi-compositor](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=pi-compositor)

I am supplying packages, which you can simply consume, or magical dangerous bash scripts which you can embrace in disdain for your sovereignty.

Or you can simply proceed to making it happen by following these instructions. Clearly you proceed at your own risk, and neither myself nor my employer provide any binding guarantees or assurances. Kiss your poodle goodbye.

## Instructions

0. [Install the appropriate Arch on a fresh sd card](https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2)
1. Boot the Raspberry Pi
2. Download and run the following [script](http://s3.amazonaws.com/spuddrepo/arch/setup_qpi.sh) on the RPI
3. I personally normally do this by allowing root login via ssh and then grabbing the script via curl
4. curl http://s3.amazonaws.com/spuddrepo/arch/setup_qpi.sh > setup_qpi.sh
5. bash setup_qpi.sh
6. I would strongly recommend increasing the video ram to 512 in /boot/config.txt (The compositor alone requires more than the default 64 due to the sexy background wave effect)
7. Run this [script](http://s3.amazonaws.com/spuddrepo/arch/setup_qpi_host.sh) on your Arch host machine
8. In order for mdns hostname resolution to work, you have to enable [this](https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2) which I can't safely automate
9. Mount your Arch sysroot on your host (recommend NFS, mounting "/" under /mnt/pi)
10. You are now set to use Qt Creator to develop and deploy to your Raspberry Pi 2
11. Please note, you might have to explicitly "test" the device in the device page of Qt Creator in order for deployment to work. (pessimistic)
