#!/usr/bin/env bash

CACHE="/tmp/wttrbar-cache.json"
TMP="/tmp/wttrbar-cache.tmp"

# Try to fetch fresh data into a temp file
wttrbar >"$TMP" 2>/dev/null

# Only overwrite cache if output is valid non-empty JSON
if [[ -s "$TMP" ]] && jq -e . "$TMP" &>/dev/null; then
  mv "$TMP" "$CACHE"
else
  rm -f "$TMP"
fi
