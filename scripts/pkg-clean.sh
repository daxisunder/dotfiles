#!/usr/bin/env bash

# Header Helper
print_header() { echo -e "\033[1;34m--- $1 ---\033[0m"; }

# Get current available blocks (in KB)
get_space() { df / --output=avail | tail -1; }

# Record Start Time and Initial Space
start_space=$(get_space)
current_time=$(date "+%Y-%m-%d %H:%M:%S")

# 0. Welcome Header with Date
print_header "System Cleanup Started: $current_time"

print_header "Cleaning Pacman Cache"

# 1. Remove Orphans
ORPHANS=$(pacman -Qdtq)
if [[ -n "$ORPHANS" ]]; then
  # Removed quotes so it treats multiple orphans as separate packages??? ## test ##
  pacman -Rns --noconfirm $ORPHANS
else
  echo "No orphaned packages to remove."
fi

# 2. Clean Pacman Cache
paccache -rk1 | sed '/^$/d'
paccache -ruk0 | sed '/^$/d'

# 3. Clean Yay / AUR Cache
if command -v yay &>/dev/null; then
  print_header "Cleaning Yay (AUR) Cache"
  # Using sed '/^$/d' to delete the specific empty lines yay is known for
  yay -Yc --noconfirm -q | sed '/^$/d'
  yay -Sc --aur --noconfirm -q | sed '/^$/d'

  YAY_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/yay"
  if [ -d "$YAY_CACHE" ]; then
    paccache -rk1 -c "$YAY_CACHE"
    find "$YAY_CACHE" -mindepth 1 -type d \( -name "src" -o -name "pkg" \) -exec rm -rf {} +
    echo "Source and build directories cleared."
  fi
fi

# 4. Vacuum Systemd Journal
print_header "Vacuuming Journal Logs"
sudo journalctl --vacuum-time=2d

# Calculate System Clean Savings
mid_space=$(get_space)
system_saved=$(((mid_space - start_space) / 1024))

# 5. Trash Management
print_header "Trash Management"
TRASH_DIR="$HOME/.local/share/Trash/files"

if [ -d "$TRASH_DIR" ] && [ "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
  file_count=$(find "$TRASH_DIR" -mindepth 1 | wc -l)
  trash_size=$(du -sh "$TRASH_DIR" | cut -f1)

  echo "Trash contains $file_count items ($trash_size)."

  # We use printf to keep the prompt tight
  printf "Empty it? [y/N] "
  read -n 1 -r REPLY

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # \r cleans up the prompt line, \n moves down once
    printf "\r\033[KForce-emptying trash...\n"
    rm -rf "$HOME/.local/share/Trash/files"/* 2>/dev/null
    rm -rf "$HOME/.local/share/Trash/info"/* 2>/dev/null

    end_space=$(get_space)
    trash_saved=$(((end_space - mid_space) / 1024))
    echo "Trash cleared (Reclaimed: ${trash_saved} MB)."
  else
    # \r\033[K clears the [y/N] prompt line and replaces it immediately
    printf "\r\033[KTrash cleanup skipped.\n"
    trash_saved=0
    end_space=$mid_space
  fi
else
  echo "Trash is already empty."
  trash_saved=0
  end_space=$mid_space
fi

# 6. Final Summary
total_saved=$(((end_space - start_space) / 1024))

print_header "Cleanup Results"
echo -e "System & Cache:  $(printf "%'8d" $system_saved) MB"
echo -e "Trash Bin:       $(printf "%'8d" $trash_saved) MB"
echo "---------------------------"
echo -e "Total Reclaimed: \033[1;32m$(printf "%'8d" $total_saved) MB\033[0m"

print_header "System Cleanup Complete: $current_time"

# 7. Desktop Notification
if command -v notify-send &>/dev/null; then
  notify-send "System Cleanup Complete" "Total Space Reclaimed: ${total_saved} MB" --icon=user-trash
fi
