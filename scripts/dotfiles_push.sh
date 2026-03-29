#!/usr/bin/env bash

set -e

GROQ_API_KEY="${GROQ_API_KEY:-}"
GROQ_URL="https://api.groq.com/openai/v1/chat/completions"
GROQ_MODEL="llama-3.3-70b-versatile"
MAX_DIFF_CHARS=4000
TIMEOUT=30

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

DIFF=$(git diff --cached)
if [[ ${#DIFF} -gt $MAX_DIFF_CHARS ]]; then
  DIFF="${DIFF:0:$MAX_DIFF_CHARS}"$'\n[diff truncated...]'
fi

if [[ -z "$GROQ_API_KEY" ]]; then
  if can_notify; then
    notify-send -u critical -i github "Dotfiles" "GROQ_API_KEY not set. Using timestamp commit."
  fi
  COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
else
  PAYLOAD=$(jq -n \
    --arg model "$GROQ_MODEL" \
    --arg diff "$DIFF" \
    '{
      model: $model,
      messages: [
        {
          role: "system",
          content: "You are a git commit message generator. Output a commit message with two parts:\n1. A subject line in Conventional Commits format (feat:, fix:, chore:, refactor:, etc.), max 72 characters.\n2. A blank line followed by a short body explaining what changed and why.\nOutput only the commit message. No markdown, no code blocks, no extra commentary."
        },
        {
          role: "user",
          content: $diff
        }
      ]
    }')

  RESPONSE=$(curl -sf --max-time "$TIMEOUT" \
    --request POST \
    --url "$GROQ_URL" \
    --header "Authorization: Bearer ${GROQ_API_KEY}" \
    --header "Content-Type: application/json" \
    --data "$PAYLOAD") || true

  COMMIT_MSG=$(printf '%s' "$RESPONSE" | jq -r '.choices[0].message.content // empty' | xargs -0)

  if [[ -z "$COMMIT_MSG" ]]; then
    if can_notify; then
      notify-send -u normal -i github "Dotfiles" "Groq failed. Using timestamp commit."
    fi
    COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
  fi
fi

git commit -m "$COMMIT_MSG"
git pull --rebase origin main
git push

if can_notify; then
  notify-send -i github "Dotfiles" "Pushed: $COMMIT_MSG"
fi
