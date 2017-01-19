---
layout: post
title:  "Using Qt on Arch Linux aarch64 on the Raspberry Pi 3"
date:   2017-01-13 12:10:59 -0700
published: true
tags: [qt, pi, embedded, gl, arch, linux, oss]
---

# Introduction

The Arch Linux aarch64 image used to require some [fiddling](http://chaos-reins.com/2016-09-01-qt-pi3-arch-aarch64/) to hit functionality. Now that there is an official [Arch pi image](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3) for aarch64, I decided to give it a bash.

# Development

If cross compiling against this root image, be aware of fully qualified symlinks:

[root@qpi3 ~]# ls -la /lib/libGLESv2.so.2.0.0
lrwxrwxrwx 1 root root 32 Jan  7 03:25 /lib/libGLESv2.so.2.0.0 -> /usr/lib/mesa/libGLESv2.so.2.0.0

which will contaminate your compile with host libs and make your Qt tests barf in a hard to debug fashion. I personally use the [symlinks](https://github.com/brandt/symlinks) rather than hacking together my own bash scripts.

~~symlinks -c /lib~~ (turns out symlinks creates broken symlinks when passed a dir which is itself a symlink)
cd /usr/lib && symlinks -cr .

and you are done.

# Conclusion

There is not a hell of a lot to relate.

pacman -S qt

qmlscene ~/moo.qml -platform eglfs

where moo.qml is a minimal example, quick qualified that everything was functioning with any effort on my part; Qt applications work out of the box on the framebuffer with full GLES2 acceleration. I grabbed the art application I tend to use my Pi's for, and after compilation had immediate success. That is, I had complete success for a couple minutes, at which point my app seizes heavily. I am still actively debugging this.

The default Qt plugin is still xcb, so you have to explicitly pass the eglfs platform flag as documented above. Either that or export QT_QPA_PLATFORM=eglfs in your environment to override this default.

# TODO

* Verify state of Qt wayland on this image
