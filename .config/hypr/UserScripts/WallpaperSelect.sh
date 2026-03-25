#!/usr/bin/env bash
# This script is for selecting wallpapers (SUPER W)

# WALLPAPERS PATH
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Variables
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# awww transition config
FPS=60
TYPE="simple"
DURATION=2
AWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg >/dev/null; then
  pkill swaybg
fi

# Retrieve image files using null delimiter to handle spaces in filenames
mapfile -d '' PICS < <(find "${wallDIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")

    if [[ ! "$pic_name" =~ \.gif$ ]]; then
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    else
      printf "%s\n" "$pic_name"
    fi
  done
}

# Initiate awww if not running
awww query &>/dev/null || {
  awww-daemon --format xrgb &
  sleep 0.5
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
  sleep 1
fi

# Choice of wallpapers
main() {
  choice=$(menu | $rofi_command)

  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
    if [[ -n "$focused_monitor" ]]; then
      awww img -o "$focused_monitor" "$RANDOM_PIC" $AWWW_PARAMS
    else
      awww img "$RANDOM_PIC" $AWWW_PARAMS
    fi
    sleep 0.5
    "$SCRIPTSDIR/Refresh.sh"
    exit 0
  fi

  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    if [[ -n "$focused_monitor" ]]; then
      awww img -o "$focused_monitor" "${PICS[$pic_index]}" $AWWW_PARAMS
    else
      awww img "${PICS[$pic_index]}" $AWWW_PARAMS
    fi
  else
    echo "Image not found."
    exit 1
  fi
}

main

sleep 0.2
"$SCRIPTSDIR/Refresh.sh"
