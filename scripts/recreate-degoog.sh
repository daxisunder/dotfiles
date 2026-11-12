#!/usr/bin/env bash
set -euo pipefail

NAME="degoog"
IMAGE="ghcr.io/fccview/degoog:latest"
DATA_DIR="/home/daxis/docker/degoog/data"
PASSWORD="R#t66*%2b2Lpdy"

docker pull "$IMAGE"
docker rm -f "$NAME" 2>/dev/null || true

docker run -d \
  --name "$NAME" \
  --restart unless-stopped \
  -p 4444:4444 \
  -v "$DATA_DIR":/app/data \
  -e DEGOOG_SETTINGS_PASSWORDS="$PASSWORD" \
  "$IMAGE"
