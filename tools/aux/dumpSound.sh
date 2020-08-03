#!/bin/bash
dd if=seasons.gbc bs=1 count=64 skip=$((0x3d*0x4000+0x3fca)) of=/tmp/sound.bin
xxd -g1 /tmp/sound.bin
