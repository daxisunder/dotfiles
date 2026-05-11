#!/usr/bin/bash

# Mute default sink immediately before initialization
wpctl set-mute @DEFAULT_AUDIO_SINK@ 1

# Wait for PipeWire to fully bring up the device
sleep 3

# Trigger DAC power-on silently while muted
aplay -d 1 -t raw -r 48000 -c 2 -f S16_LE /dev/zero >/dev/null 2>&1

# Let the hardware settle after the pop
sleep 1

# Unmute and restore a comfortable default volume
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.40
