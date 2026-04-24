#!/usr/bin/bash
# Scripts for refreshing waybar, rofi, swaync

file_exists() {
  if [ -e "$1" ]; then
    return 0
  else
    return 1
  fi
}

# Kill already running processes — use -f for Python-wrapped apps
_ps=(waybar rofi swaync)
for _prs in "${_ps[@]}"; do
  if pidof "${_prs}" >/dev/null; then
    pkill "${_prs}"
  fi
done

# protonvpn-app is a Python entry-point; must match full cmdline
if pgrep -f "protonvpn-app" >/dev/null; then
  pkill -f "protonvpn-app"
fi

# Restart waybar
sleep 0.3
waybar &

# Relaunch swaync
sleep 0.3
swaync >/dev/null 2>&1 &

# Relaunch Proton VPN
sleep 0.5
protonvpn-app &

exit 0
