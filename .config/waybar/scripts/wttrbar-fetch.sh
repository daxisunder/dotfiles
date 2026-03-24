#!/usr/bin/env bash

CACHE="/tmp/wttrbar-cache.json"
TMP="/tmp/wttrbar-cache.tmp"

rm -f "$CACHE"

wttrbar >"$TMP" 2>/dev/null

if [[ -s "$TMP" ]] && jq -e '.text' "$TMP" &>/dev/null; then
  mv "$TMP" "$CACHE"
else
  rm -f "$TMP"
fi
