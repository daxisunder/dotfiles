#!/usr/bin/env bash
ADDRESS="0x$1"

# Toggle floating, resize to 50% x 50% of screen, and center it
hyprctl dispatch togglefloating "address:$ADDRESS" ||
  exit 0 # exit silently if window no longer exists

hyprctl dispatch resizewindowpixel exact 50% 50%,"address:$ADDRESS"
hyprctl dispatch centerwindow "address:$ADDRESS"
