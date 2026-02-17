#!/usr/bin/env bash
status=$(cat /run/etckeeper-status 2>/dev/null)

case "$status" in
committed)
  systemd-run --user --quiet notify-send -i github "Etckeeper:" "Daily autocommit completed."
  ;;
failed)
  systemd-run --user --quiet notify-send -i github "Etckeeper:" "Daily autocommit failed!"
  ;;
*)
  systemd-run --user --quiet notify-send -i github "Etckeeper:" "No changes, nothing to commit."
  ;;
esac
