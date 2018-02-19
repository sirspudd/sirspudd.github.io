---
title:  "Using Qt Creator inside of a hardware accelerated Virtualbox image"
date:   2017-06-04 12:10:59 -0700
published: true
tags: [gl, vm, linux, oss, qt, qtcreator]
---

# Introduction

I recently had the joy of being handed a Mac laptop running QtCreator inside of a VM in order to demonstrate my 1337 QML skills. The VM was dog slow, and it was not hard to see why; GPU hardware acceleration was disabled. being a rocket scientist, one immediately enables video acceleration and is promptly rewarded with (a) black window(s) where Qt Creator's aspecto is meant to present itself. Awesome.

# Solution

Luckily there is a solution:

export QMLSCENE_DEVICE=softwarecontext

prior to running Qt Creator in your VM, and you are cooking with gas. (as documented [here](http://doc.qt.io/QtQuick2DRenderer/))

If it seems counter intuitive to you to enable hardware acceleration only to use software rasterization in the sole application you are running, then you are suffering from a sever case of over rationality. I suggest a beer and maybe ratifying it.
