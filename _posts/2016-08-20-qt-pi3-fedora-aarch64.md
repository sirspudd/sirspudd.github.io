---
layout: post
title:  "Evaluating hardware accelerated Qt on Fedora Linux 24 Raspberry Pi 3 (Aarch64)"
date:   2016-08-20 12:10:59 -0700
published: true
tags: [qt, pi, embedded, gl, fedora, linux, oss]
---

# Backdrop

I recently learnt of a nice functional [aarch64 image](https://www.kraxel.org/blog/2016/04/fedora-on-raspberry-pi-updates/) provided for the Raspberry Pi 3. I am not overly familiar with Fedora, but I have been waiting for someone to do all the legwork and provide a nicely bootable, functional aarch64 image. (I am immensely grateful to this Kraxel dude.)

# Process

Grab the image above. Boot it. IO feels a little sluggish, but outside of that everything seems awesome.  

Update the software:

    dnf upgrade --refresh

or:

    dnf check-update
    dnf upgrade

(I am not a Fedora dude so forgive my cluelessness)

As of right now 08/20/2016, you just rendered your system unbootable as it is booting a mainline kernel without the associated configuration. Minor adjustment required:

## /boot/config.txt (Fixes device tree and hence boot)

        # workaround firmware issue for rpi3
        # u-boot doesn't work without this
        enable_uart=1
        
        avoid_warnings=2     # VPU shouldn't smash our display setup.
        dtoverlay=vc4-kms-v3d

## /boot/extlinux/extlinux.conf (Fixes the running of GLES2 apps)

        Append "cma=256M@256M" to the append line.

(I have no clue where to source a 64 bit /opt/vc, so the vc4 stack in the mainline kernel is the path of least resistance. (This is implicit in the overlay adjustment above))

Cool. System boots. There is an error in PolicyKit, but this does not appear to be a deal breaker and I will rely on someone else addressing that. Interacting with systemd services like nfs is no fun, so I am forced to ferry mmy sd-card between computer and pi. Outside of that, we are awesome.

Install weston and the mesa-dri-drivers, and weston-launch immediately starts to work, proving that the system is sane and ready for further use. My goal was to build Qt since I like to control what is running, and how it is built, but establishing the state of the system provided Qt is increasingly of interest to me as desktop distros are starting to cover non-X11 centric usage in an increasingly capable fashion.

Turns out Qt 5.7 on the Pi is actually very sane. Copying across the cube example from qtbase, and compiling/running it on the target proves that Qt is running with full hardware acceleration. Again awesome.  Attempting to run qmlscene with a minimal QML application however crashes. Building my own Qt (Using my Arch (recipe)[https://aur.archlinux.org/packages/qt-sdk-raspberry-pi]) fares no better.

# Take aways

* Qt on Fedora is nicely configured and actually supports eglfs usage out of the box (Qt wayland not so much: "wl_drm@15: error 2: invalid name")
* OpenGL ES 2/EGL work on aarch64, as does weston

# TODOs

* Investigate qtdeclarative crash
* Check our own wayland

# Comments

* The Fedora atomicity of packages is a bit of a mind fuck to arch users. I am used to installing a package installing the -devel package implicitly, and I am especially confounded by the granularity of packages, such as mesa, where I should just have installed the whole bloody cacophony, 22kb at a time.
* I hope Qt 5.8 addresses what constitutes a functional/successful build. For instance, my latest build was popped out without wayland-egl support due to the absence of the associated devel package. This happened for gbm as well. This kind of debugging loop is very extended. (At least with gbm I can enforce its inclusion along with kms as of Qt 5.7)
