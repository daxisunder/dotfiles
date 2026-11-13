#!/usr/bin/env bash
set -euo pipefail
umask 077

NAME="degoog"
IMAGE="ghcr.io/degoog-org/degoog:latest"
BASE_DIR="/home/daxis/docker/degoog"
DATA_DIR="$BASE_DIR/data"
BACKUP_DIR="$BASE_DIR/backups"

ENV_FILE="$(mktemp)"
trap 'rm -f "$ENV_FILE"' EXIT

docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' \
  "$NAME" | grep '^DEGOOG_' >"$ENV_FILE"

if ! grep -q '^DEGOOG_SETTINGS_PASSWORDS=.' "$ENV_FILE"; then
  echo "No settings password found in the current container. Aborting."
  exit 1
fi

if [[ ! -d "$DATA_DIR" ]]; then
  echo "Data directory not found: $DATA_DIR"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

echo "Pulling the current Degoog image..."
docker pull "$IMAGE"

echo "Stopping Degoog for backup..."
docker stop "$NAME"

BACKUP="$BACKUP_DIR/data-$(date +%Y%m%d-%H%M%S).tar.gz"

if ! tar -czf "$BACKUP" -C "$BASE_DIR" data; then
  echo "Backup failed. Restarting the existing container."
  docker start "$NAME"
  exit 1
fi

echo "Backup saved: $BACKUP"

docker rm "$NAME"

docker run -d \
  --name "$NAME" \
  --restart unless-stopped \
  --network bridge \
  -p 4444:4444 \
  --mount "type=bind,source=$DATA_DIR,target=/app/data" \
  --env-file "$ENV_FILE" \
  "$IMAGE"

echo "Recent startup logs:"
docker logs --tail 30 "$NAME"
