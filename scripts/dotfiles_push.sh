#!/usr/bin/env bash

set -e

API_ENV="$HOME/api.env"
if [[ -f "$API_ENV" ]]; then
  # shellcheck source=/dev/null
  source "$API_ENV"
fi

GEMINI_API_KEY="${GEMINI_API_KEY:-}"
GEMINI_MODEL="gemini-3-flash-preview"
GEMINI_URL="https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent"
MAX_DIFF_CHARS=120000
TIMEOUT=60

DEBUG="${DEBUG:-0}"

SYSTEM_PROMPT='You are a git commit message generator. You will receive a raw git diff.

Follow these steps internally — do NOT output them:

1. Parse all changed files from the diff. For each file, identify what changed (additions, deletions, modifications) and the category of change (logic/behavior, API/interface, config, deps, docs, tests, style/formatting).

2. Rank changes by importance using this priority order: breaking changes or behavior-altering logic (highest), new features or capabilities, bug fixes, performance improvements, dependency updates, refactoring without behavior change, config/build/tooling changes, docs/tests/style/formatting (lowest).

3. Determine the dominant commit types from the highest-ranked changes: revert > feat > fix > perf > deps > refactor > build > docs > test > style > chore.

4. Write the commit message based on what matters most, not a file-by-file dump.

Output format — two parts, nothing else:
1. A subject line in Conventional Commits format (type(optional-scope): short summary), max 150 characters, imperative mood.
2. A blank line, then a body that leads with the most impactful changes and why they were made, briefly covers secondary changes in descending order of importance, groups related changes across files rather than listing files, and focuses on WHY not just what.

No markdown. No code blocks. No bullet points in output. No extra commentary.'

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
    notify-send -i github "Dotfiles" "No changes since last push."
  fi
  exit 0
fi

DIFF=$(git diff --cached)
if [[ ${#DIFF} -gt $MAX_DIFF_CHARS ]]; then
  DIFF="${DIFF:0:$MAX_DIFF_CHARS}"$'\n[diff truncated...]'
fi

if [[ -z "$GEMINI_API_KEY" ]]; then
  if can_notify; then
    notify-send -u critical -i github "Dotfiles" "GEMINI_API_KEY not set. Falling back to timestamped commit."
  fi
  COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
else
  # maxOutputTokens must cover thinking tokens + actual output.
  # 2048 leaves room for ~150-token thinking overhead in Gemini 3 Flash.
  PAYLOAD=$(jq -n \
    --arg system "$SYSTEM_PROMPT" \
    --arg diff "$DIFF" \
    '{
      systemInstruction: {
        parts: [{ text: $system }]
      },
      contents: [
        {
          role: "user",
          parts: [{ text: $diff }]
        }
      ],
      generationConfig: {
        temperature: 0.1,
        maxOutputTokens: 2048
      },
      safetySettings: [
        { category: "HARM_CATEGORY_HARASSMENT", threshold: "BLOCK_NONE" },
        { category: "HARM_CATEGORY_HATE_SPEECH", threshold: "BLOCK_NONE" },
        { category: "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold: "BLOCK_NONE" },
        { category: "HARM_CATEGORY_DANGEROUS_CONTENT", threshold: "BLOCK_NONE" }
      ]
    }')

  REQUEST_URL="${GEMINI_URL}?key=${GEMINI_API_KEY}"

  if [[ "$DEBUG" == "1" ]]; then
    echo "[DEBUG] Request URL: ${REQUEST_URL//${GEMINI_API_KEY}/***REDACTED***}" >&2
    echo "[DEBUG] Payload size: $((${#PAYLOAD})) bytes" >&2
  fi

  HTTP_CODE=$(curl -s --max-time "$TIMEOUT" \
    -o /tmp/gemini_response.json \
    -w "%{http_code}" \
    --request POST \
    --url "$REQUEST_URL" \
    --header "Content-Type: application/json" \
    --data "$PAYLOAD")

  if [[ "$DEBUG" == "1" ]]; then
    echo "[DEBUG] HTTP status: $HTTP_CODE" >&2
    cat /tmp/gemini_response.json >&2
  fi

  if [[ "$HTTP_CODE" -ne 200 ]]; then
    if can_notify; then
      ERROR_MSG=$(jq -r '.error.message // "Unknown error"' /tmp/gemini_response.json 2>/dev/null || echo "HTTP $HTTP_CODE")
      notify-send -u normal -i github "Dotfiles" "Gemini failed: $ERROR_MSG. Falling back."
    fi
    COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
  else
    CANDIDATES=$(jq '.candidates | length' /tmp/gemini_response.json)
    if [[ "$CANDIDATES" -eq 0 ]]; then
      if can_notify; then
        PROMPT_BLOCK=$(jq -r '.promptFeedback.blockReason // "empty candidates"' /tmp/gemini_response.json)
        notify-send -u normal -i github "Dotfiles" "Gemini returned no candidates ($PROMPT_BLOCK). Falling back."
      fi
      COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
    else
      # Do NOT pipe through xargs; it mangles newlines and multiline bodies.
      COMMIT_MSG=$(jq -r '.candidates[0].content.parts[0].text // empty' /tmp/gemini_response.json)

      # Warn if the response hit the token ceiling
      FINISH_REASON=$(jq -r '.candidates[0].finishReason // empty' /tmp/gemini_response.json)
      if [[ "$FINISH_REASON" == "MAX_TOKENS" ]] && can_notify; then
        notify-send -u normal -i github "Dotfiles" "Commit message was truncated by token limit."
      fi

      if [[ -z "$COMMIT_MSG" ]]; then
        if can_notify; then
          notify-send -u normal -i github "Dotfiles" "Gemini returned empty text. Falling back to timestamped commit."
        fi
        COMMIT_MSG="chore: dotfiles update $(date '+%Y-%m-%d %H:%M')"
      fi
    fi
  fi
fi

git commit -m "$COMMIT_MSG"
git pull --rebase origin main
git push

if can_notify; then
  notify-send -i github "Dotfiles" "Pushed: $(echo "$COMMIT_MSG" | head -n 1)"
fi
