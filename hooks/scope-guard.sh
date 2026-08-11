#!/usr/bin/env bash
# SCOPE GUARD — Frankenstein Anti-Scope-Creep Hook
# Fires on Stop event
# Checks if new files were created outside original task scope
# Logs unexpected new files for review

set -euo pipefail

PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-$(pwd)}"
SESSION_LOG="${PROJECT_ROOT}/.claude/session-files.log"
IDEAS_FILE="${PROJECT_ROOT}/IDEAS.md"

# Track files created this session
if [[ "${CLAUDE_HOOK_EVENT:-}" == "Stop" ]]; then

  # Find files modified in last 60 minutes
  MODIFIED=$(find "$PROJECT_ROOT" \
    -newer "$SESSION_LOG" \
    -not -path "*/.git/*" \
    -not -path "*/.claude/*" \
    -not -path "*/node_modules/*" \
    -not -path "*/vendor/*" \
    -type f 2>/dev/null || echo "")

  COUNT=$(echo "$MODIFIED" | grep -c . 2>/dev/null || echo "0")

  if [[ "$COUNT" -gt 10 ]]; then
    echo "⚠ Scope alert: $COUNT files modified this session"
    echo "Review session output and check IDEAS.md for logged divergences"
  fi

  # Update session log timestamp
  touch "$SESSION_LOG"
fi

exit 0
