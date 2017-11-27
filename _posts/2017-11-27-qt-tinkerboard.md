---
layout: post
title:  "Using Qt on the Tinkerboard"
date:   2017-11-27 12:10:59 -0700
published: true
tags: [linux, oss, glesv2, egl, tinkerboard, mali]
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/K-gXRfVzHhA" frameborder="0" allowfullscreen></iframe>

# Intro

I delayed getting a Tinkerboard until the base software stack was documented to be at a sufficiently functional state. This announcement never actually came, and rather than squandering time trying to get Arch working on this Rockchip based device, I caved and started using the TinkerOS image provided by ASUS.

Cross compiling Qt for the Tinkerboard is not novel, it largely involves setting up the base OS image so that your cross compiler can access it as a functional sysroot without falling over. After getting Qt working from first principles, I discovered that Laszlo Agocs has already provided an authoritative documentation on [getting Qt functional on the Tinkberboard](http://blog.qt.io/blog/2017/05/03/qt-git-tinkerboard-wayland/). This document hopes to flesh in gaps left in this original document.

# Aim

The goal is to get Qt running well on the Tinkerboard, and to establish whether 4K rendering was readily plausible.

# Conditioning the image

I like to cross compile for targets against an NFS mounted sysroot. This is greatly complicated by Debian's multiarch bollocks that is front and center in TinkerOS. I am building using an Arch Linux host, and rather than being able to use a standard armv7 toolchain to target TinkerOS, I eventually had to cave in and download a Linaro toolchain. (After failure to link crt[1/0].o and friends for a couple hours)

* use the [symlinks](https://github.com/brandt/symlinks) tool to make all symlinks under [/usr/lib,/lib] absolute and not relative (prevent mistaken dereferencing of host libraries
* use the latest [Linaro armv7 toolchain](https://releases.linaro.org/components/toolchain/binaries/latest/arm-linux-gnueabihf/) 
* Install the build deps for Qt on TinkerOS
* Install NFS server components if you want to develop against your rootfs mounted via NFS

# Qt tailoring

Since I was unaware of Laszlo's prior documentation, I started to customize a mkspec for the Tinkerboard from another Mali bearing muppet in the mkspec tree. After revising through this mkspec, it boiled down to [this](https://github.com/sirspudd/mkspecs/blob/master/linux-tinker-g%2B%2B/qmake.conf) which you will note contains close to zero GPU centric tailoring, which is awesome. I settled on a slightly different set of compiler flags to Laszlo, but this is hardly grounds for scandal.

Since I already maintain SDKs for Qt use in conjunction with the Raspberry Pi, I simply added the Tinkerboard as a redheaded step child to my existing [AUR recipe](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=qt-sdk-raspberry-pi). It warrants mentioning that I was using Qt 5.10 (alpha/beta/beta2) so I am following the testing flow, and that I was indulging in static compilation, since this is increasingly appealing to me for "appliance" like purposes where I am running a single graphical application on a general purpose Linux box that runs a series of discrete applications that serve discrete purposes. (This involves touching static and testing if using the AUR recipe above)

One vaguely filthy thing about static compilation with Qt, is that it make installs the static libraries to the sysroot, which is braindead for a couple reasons

* The presence of .a files on an embedded device is a war crime
* I am using LTCG/LTO, so the static libraries are immense and cross compiling off an NFS mount would be a tedious nightmare. My solution to this (and it is filthy) is to have my NFS mounted sysroot symlink to a host directory. If you are not grimacing, you are clearly not registering the filthiness of it all.

# Immediate dividends

Once the AUR recipe above had run to completion, I cross compiled [my personal artwork displaying application](https://github.com/sirspudd/artriculate) which could immediately be launched successfully at 4K with the use of the "-platform eglfs" argument. The only issue manifested when my application crashed after apparently exhausting the default amount of memory afforded to the GPU within TinkerOS. (I set my defaults to pretty much exhausted 512 MB of GPU memory on a Raspberry Pi, which is what I normally target). After reducing the number of pixmaps to be displayed, my application was running reliably and with pretty damn solid performance.

# TODO

* Discover how to increase the amount of GPU memory on the Tinkerboard (CMA args?)
* Blog about the impact of compiler flags on the size of the resulting binaries. I am using -Os + thumb instructions + ltcg to statically compile my (Qt Quick) application for use with the Tinkerboard. The complete static binary was ~8M before opting for LTCG/LTO, which further decreased this to 6M. I was an extremely happy camper to see a Qt Quick application punching at this size, and it provided feature parity with my old approach of shipping my application with an explicit dependency on a discrete shared Qt install which was over 100M in installed size.
