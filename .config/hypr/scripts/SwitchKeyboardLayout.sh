#!/usr/bin/env bash
# This script cycles through keyboard layouts defined in UserSettings.conf
layout_f="$HOME/.cache/kb_layout"
settings_file="$HOME/.config/hypr/UserConfigs/UserSettings.conf"
notif="$HOME/.config/swaync/images/bell.png"

echo "Starting script..."

# Read current layout from cache
if [ ! -f "$layout_f" ]; then
  echo "Layout file does not exist. Creating it..."
  # Use the first layout from settings as the initial layout
  kb_layout_line=$(grep 'kb_layout = ' "$settings_file" | cut -d '=' -f 2)
  IFS=',' read -ra layout_mapping <<<"$kb_layout_line"
  current_layout="${layout_mapping[0]}"
  echo "Initial layout set to $current_layout"
  echo '<span foreground="#e0af68"></span> <span foreground="#9fe044">'"$current_layout"'</span>' >"$layout_f"
else
  # Extract current layout from markup
  current_layout=$(cat "$layout_f" | sed -E 's/.*foreground="#9fe044">([^<]*)<\/span>.*/\1/')
  echo "Current layout: $current_layout"
fi

# Read keyboard layout settings from Settings.conf
if [ -f "$settings_file" ]; then
  echo "Reading keyboard layout settings from $settings_file..."
  kb_layout_line=$(grep 'kb_layout = ' "$settings_file" | cut -d '=' -f 2)
  IFS=',' read -ra layout_mapping <<<"$kb_layout_line"
  echo "Available layouts: ${layout_mapping[@]}"
else
  echo "Settings file not found!"
  exit 1
fi

layout_count=${#layout_mapping[@]}
echo "Number of layouts: $layout_count"

# Find the index of the current layout in the mapping
for ((i = 0; i < layout_count; i++)); do
  if [ "$current_layout" == "${layout_mapping[i]}" ]; then
    current_index=$i
    echo "Current layout index: $current_index"
    break
  fi
done

# Calculate the index of the next layout
next_index=$(((current_index + 1) % layout_count))
new_layout="${layout_mapping[next_index]}"
echo "Next layout: $new_layout"

# Function to get keyboard names
get_keyboard_names() {
  hyprctl devices -j | jq -r '.keyboards[].name'
}

# Function to change layout
change_layout() {
  local got_error=false
  while read -r name; do
    echo "Switching layout for $name to $new_layout..."
    hyprctl switchxkblayout "$name" "$new_layout"
    if [[ $? -eq 0 ]]; then
      echo "Switched the layout for $name."
    else
      >&2 echo "Error while switching the layout for $name."
      got_error=true
    fi
  done <<<"$(get_keyboard_names)"
  if [ "$got_error" = true ]; then
    >&2 echo "Some errors were found during the process..."
    return 1
  fi
  return 0
}

# Change layout
if ! change_layout; then
  notify-send -u low -t 2000 'Keyboard layout' 'Error: Layout change failed'
  >&2 echo "Layout change failed."
  exit 1
else
  # Notification for the new keyboard layout
  notify-send -u low -i "$notif" "New KB_Layout: $new_layout"
  echo "Layout change notification sent."
fi

# Write the new layout to the file with Pango markup
echo '<span foreground="#e0af68"></span> <span foreground="#9fe044">'"$new_layout"'</span>' >"$layout_f"
