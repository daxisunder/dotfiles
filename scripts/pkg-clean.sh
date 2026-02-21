#!/usr/bin/env bash

# Force root for system tasks
if [[ $EUID -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

# Header Helper
print_header() { echo -e "\033[1;34m--- $1 ---\033[0m"; }

# Get current available blocks (in KB)
get_space() { df / --output=avail | tail -1; }

# Initialize Counters
deleted_count=0
start_space=$(get_space)
current_time=$(date "+%Y-%m-%d %H:%M:%S")

print_header "System Cleanup Started: $current_time"

# 1. Remove Orphans & Clean Pacman Cache
print_header "Cleaning Pacman Cache"

# Orphan Removal
ORPHANS=$(pacman -Qdtq)
if [[ -n "$ORPHANS" ]]; then
  orphan_count=$(echo "$ORPHANS" | wc -w)
  pacman -Rns --noconfirm $ORPHANS
  deleted_count=$((deleted_count + orphan_count))
else
  echo "No orphaned packages to remove."
fi

# Paccache (Cleaning /var/cache/pacman/pkg)
# We capture the output of both paccache commands
PAC_CLEAN=$(paccache -rk1 2>&1)
PAC_UNINST=$(paccache -ruk0 2>&1)

if [[ "$PAC_CLEAN" == *"pruned"* ]] || [[ "$PAC_UNINST" == *"pruned"* ]]; then
  # If something was actually removed, show the result (filtered)
  echo "$PAC_CLEAN" | sed '/no candidate/d; /^$/d'
  echo "$PAC_UNINST" | sed '/no candidate/d; /^$/d'
else
  # If both returned "no candidate packages found"
  echo "Pacman cache is already clean."
fi

# 2. Clean Yay / AUR Cache
if command -v yay &>/dev/null; then
  print_header "Cleaning Yay (AUR) Cache"

  # Silence standard yay headers
  sudo -u daxis yay -Yc --noconfirm -q >/dev/null 2>&1
  sudo -u daxis yay -Sc --aur --noconfirm -q >/dev/null 2>&1

  YAY_CACHE="/home/daxis/.cache/yay"

  if [ -d "$YAY_CACHE" ]; then
    PAC_OUT=$(paccache -rk1 -c "$YAY_CACHE" 2>&1)
    # Find non-empty build directories
    DEBRIS=$(find "$YAY_CACHE" -maxdepth 3 -type d \( -name "src" -o -name "pkg" \) -not -empty)

    if [[ "$PAC_OUT" == *"pruned"* ]] || [[ -n "$DEBRIS" ]]; then
      [[ "$PAC_OUT" == *"pruned"* ]] && echo "$PAC_OUT" | sed '/^$/d'

      if [[ -n "$DEBRIS" ]]; then
        debris_count=$(echo "$DEBRIS" | wc -l)
        find "$YAY_CACHE" -mindepth 1 -type d \( -name "src" -o -name "pkg" \) -exec rm -rf {} +
        echo "Source and build directories cleared ($debris_count items)."
        deleted_count=$((deleted_count + debris_count))
      fi
    else
      echo "AUR cache is already clean. Nothing to do."
    fi
  fi
fi

# 3. Vacuum Systemd Journal
print_header "Vacuuming Journal Logs"
JOURNAL_OUT=$(journalctl --vacuum-time=2d 2>&1)

if [[ "$JOURNAL_OUT" == *"freed 0B"* ]]; then
  echo "Journal logs are within limits. Nothing to vacuum."
else
  echo "$JOURNAL_OUT" | sed '/^$/d'
fi

# Calculate Space
mid_space=$(get_space)
system_saved=$(((mid_space - start_space) / 1024))

# 4. Trash Management
print_header "Trash Management"
TRASH_DIR="/home/daxis/.local/share/Trash/files"

if [ -d "$TRASH_DIR" ] && [ "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
  file_count=$(find "$TRASH_DIR" -mindepth 1 | wc -l)
  trash_size=$(du -sh "$TRASH_DIR" | cut -f1)

  echo "Trash contains $file_count items ($trash_size)."
  printf "Empty it? [y/N] "
  read -n 1 -r REPLY

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\r\033[KForce-emptying trash...\n"
    rm -rf "/home/daxis/.local/share/Trash/files"/* 2>/dev/null
    rm -rf "/home/daxis/.local/share/Trash/info"/* 2>/dev/null

    deleted_count=$((deleted_count + file_count))
    end_space=$(get_space)
    trash_saved=$(((end_space - mid_space) / 1024))
    echo "Trash cleared (Reclaimed: ${trash_saved} MB)."
  else
    printf "\r\033[KTrash cleanup skipped.\n"
    trash_saved=0
    end_space=$mid_space
  fi
else
  echo "Trash is already empty."
  trash_saved=0
  end_space=$mid_space
fi

# 5. Final Summary
total_saved=$(((end_space - start_space) / 1024))

print_header "Cleanup Results"
echo -e "Items Removed:   $(printf "%6d" $deleted_count)"
echo -e "System & Cache:  $(printf "%6d" $system_saved) MB"
echo -e "Trash Bin:       $(printf "%6d" $trash_saved) MB"
echo "---------------------------"
echo -e "Total Reclaimed: \033[1;32m$(printf "%6d" $total_saved) MB\033[0m"

print_header "System Cleanup Complete: $(date "+%H:%M:%S")"

# 6. Desktop Notification
if command -v notify-send &>/dev/null; then
  sudo -u daxis DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u daxis)/bus" \
    notify-send "System Cleanup Complete" "Reclaimed: ${total_saved} MB | Items: ${deleted_count}" --icon=user-trash
fi
