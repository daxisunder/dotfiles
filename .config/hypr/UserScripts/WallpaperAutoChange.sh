#!/usr/bin/env bash
# source https://wiki.archlinux.org/title/Hyprland#Using_a_script_to_change_wallpaper_every_X_minutes

# This script will randomly go through the specified directory, setting it
# up as the wallpaper at regular intervals (SUPER SHIFT W)
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

wallDIR="$HOME/Pictures/wallpapers"
wallust_refresh="$HOME/.config/hypr/scripts/RefreshNoWaybar.sh"

# Initiate awww if not running
awww query &>/dev/null || {
  awww-daemon --format xrgb &
  sleep 0.5
}

# Edit below to control the image transition
export AWWW_TRANSITION_FPS=60
export AWWW_TRANSITION_TYPE=simple

# Controls (in seconds) when to switch to the next image
INTERVAL=1800

while true; do
  find "$wallDIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) |
    while read -r img; do
      echo "$((RANDOM % 1000)):$img"
    done |
    sort -n | cut -d':' -f2- |
    while read -r img; do
      focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
      if [[ -n "$focused_monitor" ]]; then
        awww img -o "$focused_monitor" "$img"
      else
        awww img "$img"
      fi
      "$wallust_refresh"
      sleep "$INTERVAL"
    done
done
