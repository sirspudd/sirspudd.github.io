---
title:  "Evaluating hardware accelerated Qt on Fedora Linux 24 Raspberry Pi 3 (Aarch64)"
date:   2016-08-20 12:10:59 -0700
published: true
tags: [qt, pi, embedded, gl, fedora, linux, oss]
---

# TL&DR

A CONFIG_ARM64_VA_BITS_48 enabled kernel => QtQuick segfault. Fix that, and the packaged Qt 5.6 works well with the VC4 stack on Aarch64 Fedora 24, except Qt's wayland support.

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

Turns out the shipped Qt 5.6 on the Pi is actually very sane. Copying across the cube example from qtbase, and compiling/running it on the target with:

./cube -platform eglfs

proves that Qt is running with full hardware acceleration. Again awesome.  Attempting to run qmlscene:

qmlscene -platform eglfs foo.qml

with a minimal QML application however crashes. Building my own Qt (Using my [Arch recipe](https://aur.archlinux.org/packages/qt-sdk-raspberry-pi)) fares no better. (Remedied as mentioned in last edit; Kernel was configured with hostile VA_48 option)

Attempts at using Qt wayland as both server/client discharge with:

        [root@rpi3 ~]# ./host-cube -platform wayland
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        Using Wayland-EGL
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        QObject::connect: invalid null parameter
        Attempting to import 646x513 b8g8r8a8_unorm with unsupported stride 2592 instead of 164
        wl_drm@19: error 2: invalid name
        The Wayland connection experienced a fatal error (Protocol error)

The server appears to be healthy, but there is something rotten in the state of the client app.

# EGLFS performance

<iframe width="560" height="315" src="https://www.youtube.com/embed/mRHDhYVYq7A" frameborder="0" allowfullscreen></iframe>

# Take aways

* Qt on Fedora is nicely configured and actually supports eglfs usage out of the box (Qt wayland not so much: "wl_drm@15: error 2: invalid name")
* OpenGL ES 2/EGL work on aarch64, as does weston. Qt wayland, as pure client or server/client both barf.

# TODOs

* Investigate qtdeclarative crash (DONE, CONFIG_ARM64_VA_BITS_48 baby)
* Investigate wayland issues

# Comments

* The Fedora atomicity of packages is a bit of a mind fuck to arch users. I am used to installing a package installing the -devel package implicitly, and I am especially confounded by the granularity of packages, such as mesa, where I should just have installed the whole bloody cacophony, 22kb at a time.
* I hope Qt 5.8 addresses what constitutes a functional/successful build. For instance, my latest build was popped out without wayland-egl support due to the absence of the associated devel package. This happened for gbm as well. This kind of debugging loop is very extended. (At least with gbm I can enforce its inclusion along with kms as of Qt 5.7)

# Updates

## 08/22/2016

Turns out I am almost certainly being eaten by this [bug](https://bugreports.qt.io/browse/QTBUG-54822) which explains why other people were also griping about Firefox bursting into flames. Turns out, someone enabled:

CONFIG_ARM64_VA_BITS_48=y
CONFIG_ARM64_VA_BITS=48

in the frigging:

Linux rpi3 4.7.0-1-main #1 SMP PREEMPT Wed Aug 10 15:47:35 UTC 2016 aarch64 aarch64 aarch64 GNU/Linux

running on this beast

## 08/22/2016

I have verified that CONFIG_ARM64_VA_BITS_48 was causing my grief with the Qt V4 engine barfing like a champion. Adjusting this also fixed standing crashes in PolicyKit. In order to get a functional kernel, I had to do the following:

* dnf download --source kernel-main (on Fedora image)
* Copy this to a build machine
* Extracted the rpm (using rpmextract.sh on Arch)
* Unpacked the source
* Copied the standing config from /proc/config.gz to .config
* make ARCH=arm CROSS_COMPILE=/opt/arm-sirspuddarch-linux-gnueabihf/bin/arm-sirspuddarch-linux-gnueabihf- bcm2835_defconfig
* make ARCH=arm64 CROSS_COMPILE=/opt/aarch64-rpi3-linux-gnueabi/bin/aarch64-rpi3-linux-gnueabi- menuconfig
* Disabled CONFIG_ARM64_VA_BITS_48 and adjust kernel as necessary
* make ARCH=arm64 CROSS_COMPILE=/opt/aarch64-rpi3-linux-gnueabi/bin/aarch64-rpi3-linux-gnueabi-
* INSTALL_MOD_PATH=foobar make ARCH=arm64 CROSS_COMPILE=/opt/aarch64-rpi3-linux-gnueabi/bin/aarch64-rpi3-linux-gnueabi- modules_install
* Copy across the module directory indicated above, and the generated kernel ./arch/arm64/boot/Image (aarch64 requires this new [Image format](https://patchwork.ozlabs.org/patch/379898/) which contains ARM64 magic)
* Update extlinux.conf

And now Qt Quick applications are working splendidly out of the box using the Fedora packaged version of Qt 5.6. The only drawback I can see is that the QtWayland compositor functionality is not enabled, and our wayland clients are still barfing as noted above, which provides sufficient impetus to package Qt for this device (for further investigation)

Thus far packaging Qt 5.7/5.8 for this image (using my [AUR PKGBUILD](https://aur.archlinux.org/packages/qt-sdk-raspberry-pi/)) has not yielded any functional advantage beyond the stock Fedora Qt install, beyond the advances in Qt itself. (Qt Wayland for instance still barfs)

## 09/06/2016

And the Qt developers have provided a [patch](https://codereview.qt-project.org/#/c/169892/) which resolves this against an aarch kernel with 48 bit address spacing
