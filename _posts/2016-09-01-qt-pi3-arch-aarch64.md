---
layout: post
title:  "Evaluating hardware accelerated Qt on Arch Linux with Aarch64 on the Raspberry Pi 3"
date:   2016-09-01 12:10:59 -0700
published: true
tags: [qt, pi, embedded, gl, arch, linux, oss]
---

# Introduction

Having found [the Fedora aarch64 image to work well](http://chaos-reins.com/2016-08-20-qt-pi3-fedora-aarch64), I wanted to establish the same baseline with Arch Linux, partly in the name of newer versions on just about everything, partly for tribal reasons and also to see and document what is currently required to make this work. The information contained in the Fedora entry is still gonna be of interest, since it deals with adjusting both config.txt and extlinux.conf as requires to boot the device.

# Methodology

As laid out in my last blog entry, I had to recompile the kernel with CONFIG_ARM64_VA_BITS_48 unset in favour of CONFIG_ARM64_VA_BITS_39 usage. There is still some complexity with the boot setup of the pi3 which I have not managed to nail down, so I simply opted to use the boot partition from the existing Fedora image with the (Arch Linux aarch64 userspace)[https://archlinuxarm.org/platforms/armv8/generic] as provided by the Arch Linux Arm people.

This actually worked flawless, and having deployed my kernel modules to the unpacked Arch Linux rootfs I managed to immediately boot the Arch install. The only standing issue was a multitude of issues arising from the Fedora kernel not having CONFIG_SECCOMP (=y) set. Once I rebuilt the kernel with that enabled (and deployed it), everything appeared to be in good standing.

That is up until I tried to actually use the system Qt and the Qt I had compiled for the pi, at which point it became clear that the vc4 driver was absent and it was falling back to llvmpipe/software rasterization. (Launching Qt apps from ssh alerted me to this, weston-launch simply obediently launched and ran abysmally)

Turns out this is entirely by [intent](https://github.com/archlinuxarm/PKGBUILDs/blob/master/extra/mesa/PKGBUILD) where:

        [[ $CARCH == "armv7h" || $CARCH == "armv6h" ]] && VC4=',vc4'

clearly excludes our aarch64 buddy. This is a pity as the vc4 driver builds flawlessly, and runs gloriously and I was reduced to spending the next 4 hours recompiling mesa (autotools baby) on the target. At the end of it, I was back to the shipping state of Fedora 24, and Qt could suddenly run with full OpenGL ES 2 acceleration on my aarch64 Arch install.

# Conclusion

There is a fair amount of work from Kraxel and Eric Anholt to get this aarch64 Fedora image working, and people from the Arch community can readily benefit from this. It requires an unnecessary amount of legwork at present, and I am frankly a little surprised to see VC4 arbitrarily excluded from the aarch64 bit builds when it is fully functional.
