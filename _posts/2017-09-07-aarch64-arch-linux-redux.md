---
title:  "The state of Qt on Arch Linux on the Raspberry Pi 3 aarch64"
date:   2017-06-24 12:10:59 -0700
published: true
tags: [arch, linux, oss, glesv2, egl, raspberry pi, vc4, gbm, kms, aarch64]
---

# In Brief

The good news is you can grab the Arch [aarch64 image](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3), boot it, adjust the boot args by tagging on "cma=512M@256M" and then qpi will successfully be able to launch Open GL ES2 applications. (The stock Qt packaged for Arch sprays shit everywhere to the point where I dont even want to debug it).

The bad news is that applications which load a lot of graphical resources will barf pretty quickly as vc4 runs out of memory.

  Sep 10 23:15:12 boombox kernel: [drm:drm_atomic_helper_commit_cleanup_done [drm_kms_helper]] *ERROR* [CRTC:66:crtc-2] flip_done timed out
  Sep 10 23:15:01 boombox kernel: alloc_contig_range: [18f00, 19f00) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:55 boombox kernel: alloc_contig_range: 4 callbacks suppressed
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:40 boombox kernel: alloc_contig_range: 102 callbacks suppressed
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [10120, 10121) PFNs busy
  Sep 10 23:14:34 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:32 boombox kernel: alloc_contig_range: [1011d, 1011e) PFNs busy
  Sep 10 23:14:28 boombox kernel: alloc_contig_range: [10180, 10183) PFNs busy
  Sep 10 23:14:28 boombox kernel: alloc_contig_range: [1017c, 1017f) PFNs busy
  Sep 10 23:14:15 boombox kernel: alloc_contig_range: [1017c, 1017f) PFNs busy
  Sep 10 23:13:57 boombox kernel: alloc_contig_range: [10181, 10182) PFNs busy
  Sep 10 23:13:57 boombox kernel: alloc_contig_range: [10180, 10181) PFNs busy
  Sep 10 23:13:57 boombox kernel: alloc_contig_range: [1017f, 10180) PFNs busy
  Sep 10 23:13:55 boombox kernel: alloc_contig_range: [10181, 10182) PFNs busy
  Sep 10 23:13:55 boombox kernel: alloc_contig_range: [10180, 10181) PFNs busy
  Sep 10 23:13:55 boombox kernel: alloc_contig_range: [14800, 14b6a) PFNs busy
  Sep 10 23:13:55 boombox kernel: alloc_contig_range: [14600, 14a6a) PFNs busy
  Sep 10 23:13:55 boombox kernel: alloc_contig_range: [14600, 1496a) PFNs busy
  Sep 10 23:13:54 boombox kernel: alloc_contig_range: [10181, 10182) PFNs busy
  Sep 10 23:13:54 boombox kernel: alloc_contig_range: [10180, 10181) PFNs busy
  Sep 10 23:13:54 boombox kernel: alloc_contig_range: 21 callbacks suppressed
  Sep 10 23:12:06 boombox kernel: alloc_contig_range: [1017a, 1017b) PFNs busy
  Sep 10 23:12:06 boombox kernel: alloc_contig_range: [10178, 10179) PFNs busy
  Sep 10 23:12:06 boombox kernel: alloc_contig_range: [1017a, 1017b) PFNs busy

with this earlier in the stack preceding the volley of alloc_contig_range barfs by a minute.

---
Sep 10 22:49:09 boombox kernel: [drm:vc4_get_tiling_ioctl [vc4]] *ERROR* Failed to look up GEM BO 0

---

The next thing for me to do is attempt vc4 usage against the armv7 image and establish whether this is isolated to the aarch64 one or not.

# Interesting bits

I hit this for the first time:

[https://bugreports.qt.io/browse/QTBUG-60330](https://bugreports.qt.io/browse/QTBUG-60330)

which warrants reading, along with all its ancillary links. It is a hoot; I am damn lucky Laszlo pulled my ass from the flames or I would have sunk more time into trying to make sense of a shit situation. The TL&DR is: "Qt <5.10 falls through the branches on surface allocation with GBM/KMS on platforms like Arch which have defaulted to compiling mesa with glvnd support. Export magic env var: EGL_PLATFORM=0x31D7 and you are fucking golden."

Once I can run my art application without it falling over after 10 minutes due to failing memory allocations, I can start to recommend aarch64 bit usage to people.
