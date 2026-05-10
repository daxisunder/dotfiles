#!/usr/bin/env bash
sleep 2
aplay -d 1 -t raw -r 48000 -c 2 -f S16_LE /dev/zero >/dev/null 2>&1
