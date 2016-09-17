---
layout: page
title: QPi
permalink: /qpi/
---

# Overview

QPi is an attempt to create a covenient Qt SDK for the Raspberry Pi 0/1/2/3 on Arch Linux. (Associated [video](https://www.youtube.com/watch?v=vNMQMlucKco) detailing creation of SDK.) The primary goal is to ensure full functionality of Qt on the Raspberry Pi, and to ease the overhead/complexity of cross compilation from desktop Arch installs to Arch based Raspberry Pis.

Qt can run quite nicely on the Pi(s), as long as you are not running it under Xorg/X11. The packaged versions of Qt run the gamut, but I have yet to see a Qt packaging which targets kms/console usage, or which has functional wayland support (outside of Intel hardware) as shipped.

I happen to be a big fan of cross compilation rather than compilation on target, which simply removes all joy from iterative development. We provide 2 packages, one for the Raspberry Pi and one for the host machine, which once installed allow you to cross compile for the Raspberry Pi from your Arch host machine. These packages are simply tar balls, so they should even run outside of Arch in a suitably modern Linux install. (The packaging is frosting)

# Project Status

## Working

Qt 5.8.0-alpha
eglfs
Qt Creator integration

## Currently Defunct

wayland compositing
The compositor (API break in Qt 5.7.0)

# Tips

* Don't touch aarch64 at this point in time (severe stability issues). Use the raspberry pi 2 stuff on the raspberry pi 3.
* Allocate lots of graphical memory if you intend to run GLES2 apps. The default settings are hostile to this.

# Platforms

## Raspberry Pi 0/1(armv6)2/3(armv7)

uses the vc stack and the propietary drivers/blobs (and has CEC support). 2 Packages split along architectual lines.

## Raspberry Pi 3 (aarch64)

uses the mesa stack.

# AUR recipes
[qt-sdk-raspberry-pi-target-libs,qt-sdk-raspberry-pi](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=qt-sdk-raspberry-pi)

The AUR recipes used to generate the installed packages are here (in case you are into that kind of thing):
I am supplying packages, which you can simply consume, or magical dangerous bash scripts which you can embrace in disdain for your sovereignty.

Or you can simply proceed to making it happen by following these instructions. Clearly you proceed at your own risk, and neither myself nor my employer provide any binding guarantees or assurances. Kiss your poodle goodbye.

# Instructions

0. [Install the appropriate Arch on a fresh sd card](https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2)
1. Boot the Raspberry Pi
2. Download and run the following [script](http://chaos-reins.com/scripts/setup_qpi.sh) on the RPI
3. I personally normally do this by allowing root login via ssh and then grabbing the script via curl
4. curl http://chaos-reins.com/scripts/setup_qpi.sh > setup_qpi.sh
5. bash setup_qpi.sh
6. I would strongly recommend increasing the video ram to 512 in /boot/config.txt (The compositor alone requires more than the default 64 due to the sexy background wave effect). When using the mesa stack (The Pi 3) the contents of config.txt are ignored, and you have to stipulate the graphical memory via a kernel commandline argument: cma=512
7. Run this [script](http://chaos-reins.com/scripts/setup_qpi_host.sh) on your Arch host machine
8. Mount your Arch sysroot on your host (recommend NFS, mounting "/" under /mnt/pi{version})
9. You are now set to use Qt Creator to develop and deploy to your Raspberry Pi
10. Please note, you might have to explicitly "test" the device in the device page of Qt Creator in order for deployment to work. (pessimistic)
