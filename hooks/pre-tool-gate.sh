#!/usr/bin/env bash
# PRE-TOOL GATE — Frankenstein Security Hook
# Fires before every tool execution
# Blocks: secrets exposure, dangerous writes, destructive commands

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"

# ── SECRET PATTERNS ──────────────────────────────────────────────
SECRET_PATTERNS=(
  "sk-[a-zA-Z0-9]{20,}"          # OpenAI keys
  "AKIA[A-Z0-9]{16}"             # AWS access keys
  "ghp_[a-zA-Z0-9]{36}"         # GitHub personal tokens
  "xoxb-[0-9-a-zA-Z]{50,}"      # Slack bot tokens
  "AIza[0-9A-Za-z_-]{35}"       # Google API keys
  "-----BEGIN.*PRIVATE KEY-----" # Private keys
  "password\s*=\s*['\"][^'\"]{4,}" # Hardcoded passwords
)

for pattern in "${SECRET_PATTERNS[@]}"; do
  if echo "$TOOL_INPUT" | grep -qE "$pattern" 2>/dev/null; then
    echo "🔴 BLOCKED: Possible secret detected in tool input"
    echo "Pattern matched: $pattern"
    echo "Review and use environment variables instead."
    exit 1
  fi
done

# ── DANGEROUS COMMAND PATTERNS ───────────────────────────────────
if [[ "$TOOL_NAME" == "Bash" ]]; then
  DANGEROUS_PATTERNS=(
    "rm -rf /"
    "rm -rf \*"
    "dd if=/dev/zero"
    "mkfs\."
    "> /dev/sd"
    "chmod -R 777"
    "sudo rm"
    "DROP TABLE"
    "DROP DATABASE"
    "TRUNCATE"
    ":(){:|:&};:"  # Fork bomb
  )

  for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$TOOL_INPUT" | grep -qF "$pattern" 2>/dev/null; then
      echo "🔴 BLOCKED: Dangerous command pattern detected: $pattern"
      exit 1
    fi
  done
fi

# ── WRITE SCOPE ENFORCEMENT ──────────────────────────────────────
# Block writes outside project directory
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
  PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-$(pwd)}"
  FILE_PATH=$(echo "$TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('path',''))" 2>/dev/null || echo "")

  if [[ -n "$FILE_PATH" && "$FILE_PATH" != "$PROJECT_ROOT"* ]]; then
    echo "⚠ Write outside project root attempted: $FILE_PATH"
    echo "Project root: $PROJECT_ROOT"
    echo "Confirm this is intentional."
    exit 1
  fi
fi

# ── ENV FILE PROTECTION ──────────────────────────────────────────
if [[ "$TOOL_INPUT" == *".env"* && "$TOOL_NAME" == "Read" ]]; then
  echo "⚠ Reading .env file — ensure no secrets are passed to model output"
fi

exit 0
