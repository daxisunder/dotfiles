#!/usr/bin/env bash
# os-age.sh — print OS age in days based on root filesystem birth time (Tokyo Night colors)
set -euo pipefail

birth_install=$(stat -c %W /)
current=$(date +%s)
days=$(((current - birth_install) / 86400))

red=$'\e[38;2;247;118;142m'   # f7768e
white=$'\e[38;2;255;255;255m' # ffffff
cyan=$'\e[38;2;125;207;255m'  # 7dcfff
reset=$'\e[0m'

printf '%sOS age%s:%s %d days%s\n' "$red" "$white" "$cyan" "$days" "$reset"
