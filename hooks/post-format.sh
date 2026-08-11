#!/usr/bin/env bash
# POST-TOOL FORMATTER — Frankenstein Auto-Quality Hook
# Fires after every file write
# Runs: prettier, eslint fix, type check on changed files

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
TOOL_OUTPUT="${CLAUDE_TOOL_OUTPUT:-}"

# Only act on file writes
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

# Extract file path from tool output
FILE_PATH=$(echo "$TOOL_OUTPUT" | python3 -c "
import sys, json
try:
  d = json.load(sys.stdin)
  print(d.get('path', ''))
except:
  print('')
" 2>/dev/null || echo "")

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"

# ── JAVASCRIPT / TYPESCRIPT ───────────────────────────────────────
if [[ "$EXT" =~ ^(js|jsx|ts|tsx|mjs|cjs)$ ]]; then
  # Prettier
  if command -v prettier &>/dev/null; then
    prettier --write "$FILE_PATH" --log-level warn 2>/dev/null && \
      echo "✓ Formatted: $FILE_PATH"
  fi

  # ESLint auto-fix (non-blocking)
  if command -v eslint &>/dev/null; then
    eslint --fix "$FILE_PATH" --quiet 2>/dev/null || true
  fi
fi

# ── PHP (Laravel) ─────────────────────────────────────────────────
if [[ "$EXT" == "php" ]]; then
  if command -v ./vendor/bin/pint &>/dev/null; then
    ./vendor/bin/pint "$FILE_PATH" --quiet 2>/dev/null && \
      echo "✓ Formatted: $FILE_PATH"
  fi
fi

# ── CSS ───────────────────────────────────────────────────────────
if [[ "$EXT" =~ ^(css|scss|sass)$ ]]; then
  if command -v prettier &>/dev/null; then
    prettier --write "$FILE_PATH" --log-level warn 2>/dev/null && \
      echo "✓ Formatted: $FILE_PATH"
  fi
fi

exit 0
