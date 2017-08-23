---
layout: post
title:  "Getting the Raspberry Pi 2/3 working as an audio/AirPlay/Pulse sink (using Arch)"
date:   2017-06-24 12:10:59 -0700
published: true
tags: [arch, linux, oss, sound, raspberry pi]
---

# Introduction

The only thing worse than solving oddly trivial problems in Linux land is solving the same frigging problem multiple times. That is why this document exists. Also, the defaults of Arch on the Pi (possibly elsewhere) seem pretty nadiric.

# Gotchas

0. [Arch wiki: audio disabled in device tree](https://wiki.archlinux.org/index.php/Raspberry_Pi#Audio)

The onboard audio device tree is disabled by default. Fucking awesome, and not something which comes up if you google blindly. Gotta be reading that wiki. Add:

dtparam=audio=on

to config.txt

1. [Use the new fucking code path](https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=136445)

Add:

audio_pwm_mode=2

to config.txt.

By the author:

"Available with rpi-update firmware is an experimental audio driver that should significantly increase the quality of sound produced by the 3.5mm audio jack.

I've reimplemented the original PWM-based 11-bit audio @48kHz as 7-bit 2nd-order Sigma-Delta modulated at 781.25kHz. The effective noise floor with this scheme approximates that of CD-quality audio DACs."

Dude appears to know his shit as the link about indicates.

# Functionality

## Shairport

### Status: Just Works (TM)

* pacman -S shairport-sync
* systemctl enable shairport-sync.service

### Requires: Avahi
