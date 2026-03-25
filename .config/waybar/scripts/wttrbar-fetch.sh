#!/usr/bin/env bash

CACHE="/tmp/wttrbar-cache.json"
TMP="/tmp/wttrbar-cache.tmp"

rm -f /tmp/wttrbar--*.json

wttrbar >"$TMP" 2>/dev/null
EXIT=$?

if [[ $EXIT -eq 0 && -s "$TMP" ]]; then
  mv "$TMP" "$CACHE"
  sleep 1
  ~/.config/hypr/scripts/Refresh.sh
else
  rm -f "$TMP"
fi
