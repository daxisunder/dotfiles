#!/usr/bin/env bash
# Script for Random Wallpaper (SUPER ALT W)

wallDIR="$HOME/Pictures/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

# Initiate awww if not running
awww query &>/dev/null || {
  awww-daemon --format xrgb &
  sleep 0.5
}

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

mapfile -d '' PICS < <(find "${wallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)
RANDOMPIC="${PICS[$RANDOM%${#PICS[@]}]}"

# Transition config
FPS=60
TYPE="random"
DURATION=1
BEZIER=".43,1.19,1,.4"
AWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

if [[ -n "$focused_monitor" ]]; then
  awww img -o "$focused_monitor" "$RANDOMPIC" $AWWW_PARAMS
else
  awww img "$RANDOMPIC" $AWWW_PARAMS
fi

"${scriptsDir}/WallustSwww.sh"
sleep 1
