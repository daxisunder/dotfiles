#!/usr/bin/env bash
set -e

# Run the real etckeeper daily script
if /etc/etckeeper/daily; then
  echo "committed" >/run/etckeeper-status
else
  echo "failed" >/run/etckeeper-status
fi
