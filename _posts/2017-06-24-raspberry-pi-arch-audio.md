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

## Onboard audio: disabled and suboptimal by default

### [Arch wiki: audio disabled in device tree](https://wiki.archlinux.org/index.php/Raspberry_Pi#Audio)

The onboard audio device tree is disabled by default. Fucking awesome, and not something which comes up if you google blindly. Gotta be reading that wiki. Add:

dtparam=audio=on

to config.txt

### [Use the new fucking code path](https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=136445)

Add:

audio_pwm_mode=2

to config.txt.

By the author:

"Available with rpi-update firmware is an experimental audio driver that should significantly increase the quality of sound produced by the 3.5mm audio jack.

I've reimplemented the original PWM-based 11-bit audio @48kHz as 7-bit 2nd-order Sigma-Delta modulated at 781.25kHz. The effective noise floor with this scheme approximates that of CD-quality audio DACs."

Dude appears to know his shit as the link above indicates.

# Functionality

## Shairport

### Status: Just Works (TM)

* pacman -S shairport-sync
* systemctl enable shairport-sync.service

### Requires: Avahi

## Pulseaudio sink

### Status: Kinda Just Works (TM)

You can really chase you tail with Pulse. I have had it working as a sink in the past, but hit major buffering issues. Tonight I attempted to hoist a grender-resurrect (including install base-devel and attemping to build locally on a Pi, which is a cardinal sin but the kind of compromise one has to make when people show their autotools to you in 2017. I digress.) UPNP sink. Long story short, it was a ballache and went nowhere. So I attempted pulseaudio again using [this blog and a little experimentation](https://manurevah.com/blah/en/p/PulseAudio-Sound-over-the-network)

The sequence of steps required to make this jive on Arch on the Pi is:

* pacman -S pulseaudio-zeroconf pulseaudio-alsa
* useradd pulse -G audio
* /etc/pulse/system.pa (clearly adjust for your own subnet)
    * load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;192.168.1.0/24
    * load-module module-zeroconf-publish
* pulseaudio --system
* watch out for the volume; I am using hifiberry-dacplus (w/SainSmart HIFI DAC Audio Sound Card) and analog playback boost nearly blew myself and every poor fucker out of my apartment block at 2am local time

Then on the host

* pop open paprefs
* Make discoverable PulseAudio network sound devices available locally

Then it all just bloody works. Great, now you need it daemonized. Just as well this turkey has this [blogged to a t, like a boss](https://fhackts.wordpress.com/2017/07/01/running-pulseaudio-system-wide-with-pacmd-on-arch/).

### Requires: Avahi, pulseaudio, systemd (This is why Poettering is my man crush along with the king penguin pimp(daddy?) himself)
