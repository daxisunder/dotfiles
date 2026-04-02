#!/usr/bin/env bash

set -e

# Load API keys directly, independent of shell environment
API_ENV="$HOME/api.env"
if [[ -f "$API_ENV" ]]; then
  # shellcheck source=/dev/null
  source "$API_ENV"
fi

GROQ_API_KEY="${GROQ_API_KEY:-}"
GROQ_URL="https://api.groq.com/openai/v1/chat/completions"
GROQ_MODEL="llama-3.3-70b-versatile"
MAX_DIFF_CHARS=120000
TIMEOUT=60

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
    notify-send -u critical -i github "Dotfiles" "GROQ_API_KEY not set. Falling back to timestamp commit."
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
          content: "You are a git commit message generator. You will receive a raw git diff.

          Follow these steps internally — do NOT output them:

          1. **Parse all changed files** from the diff. For each file, identify:
            - What changed (additions, deletions, modifications)
            - The category of change (logic/behavior, API/interface, config, deps, docs, tests, style/formatting)

          2. **Rank changes by importance** using this priority order:
            - breaking changes or behavior-altering logic (highest)
            - new features or capabilities
            - bug fixes
            - performance improvements
            - dependency updates
            - refactoring without behavior change
            - config, build, or tooling changes
            - docs, tests, style/formatting (lowest)

          3. **Determine the dominant commit type** from the highest-ranked change:
            revert > feat > fix > perf > deps > refactor > build > docs > test > style > chore

          4. **Write the commit message** based on what matters most, not a file-by-file dump.

          Output format — two parts, nothing else:
          1. A subject line in Conventional Commits format (type(optional-scope): short summary), max 72 characters, imperative mood.
          2. A blank line, then a body that:
            - Leads with the most impactful change and why it was made
            - Briefly covers secondary changes in descending order of importance
            - Groups related changes across files rather than listing files
            - Focuses on WHY, not just what

          No markdown. No code blocks. No bullet points in output. No extra commentary."
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
