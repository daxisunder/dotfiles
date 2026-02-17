#!/usr/bin/env bash

set -e

# Function to check if a DBus session is available
can_notify() {
  [ -n "$DBUS_SESSION_BUS_ADDRESS" ]
}

# Trap for genuine errors only
cleanup() {
  local exit_code=$?
  if [ "$exit_code" -ne 0 ] && can_notify; then
    notify-send -u critical -i github "Dotfiles" "Push failed with exit code $exit_code"
  fi
}

trap cleanup EXIT

cd "$HOME/projects/dotfiles"

# Stage changes
git add .

# Check for staged changes
# --cached looks at what you just 'git add'-ed against the HEAD
if git diff-index --quiet --cached HEAD; then
  if can_notify; then
    notify-send -i github "Dotfiles" "No changes to push."
  fi
  exit 0
fi

# If we reached here, there ARE changes
git commit -m "Automated dotfiles update: $(date)"
git push

if can_notify; then
  notify-send -i github "Dotfiles" "Push to GitHub successful."
fi
