#!/usr/bin/env bash
swaync-client -swb | while read -r line; do
  count=$(echo "$line" | jq -r '.text')
  alt=$(echo "$line" | jq -r '.alt')
  class=$(echo "$line" | jq -r '.class')

  case "$alt" in
  "dnd-none" | "dnd-inhibited-none")
    icon="󰀨"
    icon_color="#ff9e64"
    ;;
  "dnd-notification" | "dnd-inhibited-notification")
    icon="󰀨"
    icon_color="#ff6c6b"
    ;;
  "notification" | "inhibited-notification")
    icon="󰗖"
    icon_color="#ff9e64"
    ;;
  *)
    icon="󰗖"
    icon_color="#8db0ff"
    ;;
  esac

  text="<span color='$icon_color'>$icon</span> <span color='#9fe044'>$count</span>"

  jq -cn --arg text "$text" --arg class "$class" \
    '{text: $text, class: $class}'
done
