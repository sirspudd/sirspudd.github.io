---
layout: post
title:  "Using Qt on Arch Linux aarch64 on the Raspberry Pi 3"
date:   2017-01-13 12:10:59 -0700
published: true
tags: [qt, pi, embedded, gl, arch, linux, oss]
---

# TLDR

The new Arch Linux aarch64 image for the Raspberry Pi 3 requires zero adjustment in order to run single windowed Qt applications directly on the framebuffer via eglfs.

# Introduction

The Arch Linux aarch64 image used to require some [fiddling](http://chaos-reins.com/2016-09-01-qt-pi3-arch-aarch64/) to hit functionality. Now that there is an official [Arch pi image](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3) for aarch64, I decided to give it a bash.

# Conclusion

There is not a hell of a lot to relate.

pacman -S qt

qmlscene ~/moo.qml -platform eglfs

where moo.qml is a minimal example, quick qualified that everything was functioning with any effort on my part; Qt applications work out of the box on the framebuffer with full GLES2 acceleration. I grabbed the art application I tend to use my Pi's for, and after compilation had immediate success.

The default Qt plugin is still xcb, so you have to explicitly pass the eglfs platform flag as documented above. Either that or export QT_QPA_PLATFORM=eglfs in your environment to override this default.

# TODO

* Verify state of Qt wayland on this image
