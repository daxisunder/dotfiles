#!/usr/bin/env bash

set -e

OLLAMA_MODEL="${OLLAMA_MODEL:-llama3.2}"
OLLAMA_URL="http://localhost:11434/api/chat"
MAX_DIFF_CHARS=12000

can_notify() {
  [ -n "$DBUS_SESSION_BUS_ADDRESS" ]
}

cleanup() {
  local exit_code=$?
  if [ "$exit_code" -ne 0 ] && can_notify; then
    notify-send -u critical -i github "Dotfiles" "Push failed with exit code $exit_code"
  fi
}

trap cleanup EXIT

cd "$HOME/projects/dotfiles"

git add .

if git diff-index --quiet --cached HEAD; then
  if can_notify; then
    notify-send -i github "Dotfiles" "No changes to push."
  fi
  exit 0
fi

# Capture staged diff, truncate if too large
DIFF=$(git diff --cached)
if [[ ${#DIFF} -gt $MAX_DIFF_CHARS ]]; then
  DIFF="${DIFF:0:$MAX_DIFF_CHARS}"$'\n[diff truncated...]'
fi

# Check Ollama is running
if ! curl -sf "$OLLAMA_URL" >/dev/null 2>&1; then
  if can_notify; then
    notify-send -u critical -i github "Dotfiles" "Ollama is not running. Falling back to timestamp commit."
  fi
  COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
else
  # Build JSON payload safely with jq
  PAYLOAD=$(jq -n \
    --arg model "$OLLAMA_MODEL" \
    --arg diff "$DIFF" \
    '{
      model: $model,
      stream: false,
      messages: [
        {
          role: "system",
          content: "You are an expert developer assistant. Analyze git diffs and write concise commit messages following Conventional Commits (feat:, fix:, chore:, refactor:, etc.). Output ONLY the commit message. No markdown, no explanation, no quotes."
        },
        {
          role: "user",
          content: ("Write a commit message for this dotfiles diff:\n\n" + $diff)
        }
      ]
    }')

  RESPONSE=$(curl -sf --request POST \
    --url "$OLLAMA_URL" \
    --header "Content-Type: application/json" \
    --data "$PAYLOAD")

  COMMIT_MSG=$(echo "$RESPONSE" | jq -r '.message.content // empty' | head -n1 | xargs)

  # Fallback if model returned nothing
  if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
  fi
fi

git commit -m "$COMMIT_MSG"
git push

if can_notify; then
  notify-send -i github "Dotfiles" "Pushed: $COMMIT_MSG"
fi
