#!/usr/bin/env bash

# Header Helper
print_header() { echo -e "\n\033[1;34m--- $1 ---\033[0m"; }

# Get current available blocks (in KB)
get_space() { df / --output=avail | tail -1; }

# Initial state
start_space=$(get_space)

print_header "Cleaning Pacman Cache"

# 1. Remove Orphans
ORPHANS=$(pacman -Qdtq)
if [[ -n "$ORPHANS" ]]; then
  sudo pacman -Rns --noconfirm $ORPHANS
else
  echo "No orphaned packages to remove."
fi

# 2. Clean Pacman Cache
sudo paccache -rk1
sudo paccache -ruk0

# 3. Clean Yay / AUR Cache
if command -v yay &>/dev/null; then
  print_header "Cleaning Yay (AUR) Cache"
  yay -Sc --aur --noconfirm

  YAY_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/yay"
  if [ -d "$YAY_CACHE" ]; then
    paccache -rk1 -c "$YAY_CACHE"
    find "$YAY_CACHE" -type d \( -name "src" -o -name "pkg" \) -exec rm -rf {} +
    echo "Source and build directories cleared."
  fi
fi

# 4. Vacuum Systemd Journal
print_header "Vacuuming Journal Logs"
sudo journalctl --vacuum-time=2d

# Calculate System Clean Savings
mid_space=$(get_space)
system_saved=$(((mid_space - start_space) / 1024))

# 5. Trash Management (Forceful to avoid hangs)
print_header "Trash Management"
read -p "Do you want to empty the Trash? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Force-emptying trash..."
  sudo rm -rf ~/.local/share/Trash/files/* 2>/dev/null
  sudo rm -rf ~/.local/share/Trash/info/* 2>/dev/null

  end_space=$(get_space)
  trash_saved=$(((end_space - mid_space) / 1024))
  echo "Trash cleared (Reclaimed: ${trash_saved} MB)."
else
  trash_saved=0
  end_space=$mid_space
  echo "Trash cleanup skipped."
fi

# 6. Final Summary
total_saved=$(((end_space - start_space) / 1024))

print_header "Cleanup Results"
echo -e "System & Cache:  ${system_saved} MB"
echo -e "Trash Bin:       ${trash_saved} MB"
echo -e "---------------------------"
echo -e "Total Reclaimed: \033[1;32m${total_saved} MB\033[0m"
print_header "All Done!"
