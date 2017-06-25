---
layout: post
title:  "Getting the Raspberry Pi 2 working as an AirPlay/Pulse sink (using Arch)"
date:   2017-06-24 12:10:59 -0700
published: true
tags: [arch, linux, oss, sound]
---

# Introduction

The only thing worse than solving oddly trivial problems in Linux land is solving the same frigging problem multiple times. That is why this document exists.

# Gotchas

0. https://wiki.archlinux.org/index.php/Raspberry_Pi#Audio
    The audio device tree is disabled by default. Fucking awesome, and not something which comes up if you google blindly. Gotta be reading that wiki.

# Functionality

## Shairport

### Status: Just Works (TM)

pacman -S shairport-sync
systemctl enable shairport-sync.service

### Requires: Avahi
