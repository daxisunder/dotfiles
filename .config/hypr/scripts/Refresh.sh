#!/usr/bin/bash
# Scripts for refreshing waybar, rofi, swaync
# Define file_exists function
file_exists() {
  if [ -e "$1" ]; then
    return 0 # File exists
  else
    return 1 # File does not exist
  fi
}

# Kill already running processes
_ps=(waybar rofi swaync)
for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    pkill "${_prs}"
  fi
done

#Restart waybar
sleep 0.3
waybar &

# relaunch swaync
sleep 0.3
swaync >/dev/null 2>&1 &

exit 0
