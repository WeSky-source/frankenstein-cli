#!/usr/bin/env bash
# Frankenstein installer — copies CLAUDE.md, skills, hooks, and commands into ~/.claude
# Safe to re-run. Never overwrites without backing up first. No sudo required.

set -euo pipefail

BOLD='\033[1m'; DIM='\033[2m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
BACKUP_DIR="$CLAUDE_DIR/frankenstein-backup-$(date +%Y%m%d-%H%M%S)"
BACKED_UP=0

step() { echo -e "${CYAN}▶${RESET} $1"; }
ok()   { echo -e "${GREEN}✓${RESET} $1"; }
warn() { echo -e "${YELLOW}⚠${RESET} $1"; }

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ]; then
    local rel="${target#"$CLAUDE_DIR"/}"
    mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
    cp -r "$target" "$BACKUP_DIR/$rel"
    BACKED_UP=1
  fi
}

echo -e "${BOLD}Frankenstein installer${RESET} — a lean Claude Code brain"
echo -e "${DIM}Installing into $CLAUDE_DIR — nothing outside it is touched.${RESET}\n"

mkdir -p "$CLAUDE_DIR"/{skills,hooks,commands}

step "Installing CLAUDE.md"
backup_if_exists "$CLAUDE_DIR/CLAUDE.md"
cp "$SRC_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
ok "CLAUDE.md installed"

step "Installing skills (frontend, logic, security)"
for skill in frontend logic security; do
  mkdir -p "$CLAUDE_DIR/skills/$skill"
  backup_if_exists "$CLAUDE_DIR/skills/$skill/SKILL.md"
  cp "$SRC_DIR/skills/$skill/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"
done
ok "3 skills installed"

echo
echo -e "${DIM}islamic-foundation is the original author's personal ethical reasoning${RESET}"
echo -e "${DIM}layer. Everything else here works fine without it — it's genuinely optional.${RESET}"
read -r -p "$(echo -e "${CYAN}?${RESET} Install islamic-foundation skill too? [y/N] ")" reply
if [[ "${reply:-}" =~ ^[Yy]$ ]]; then
  mkdir -p "$CLAUDE_DIR/skills/islamic-foundation"
  backup_if_exists "$CLAUDE_DIR/skills/islamic-foundation/SKILL.md"
  cp "$SRC_DIR/skills/islamic-foundation/SKILL.md" "$CLAUDE_DIR/skills/islamic-foundation/SKILL.md"
  ok "islamic-foundation installed"
else
  warn "Skipped islamic-foundation — re-run this installer anytime to add it later"
fi

echo
step "Installing safety hooks"
for hook in pre-tool-gate.sh post-format.sh scope-guard.sh; do
  backup_if_exists "$CLAUDE_DIR/hooks/$hook"
  cp "$SRC_DIR/hooks/$hook" "$CLAUDE_DIR/hooks/$hook"
  chmod +x "$CLAUDE_DIR/hooks/$hook"
done
ok "3 hooks installed and made executable"

step "Installing commands"
for cmd in plan-ceo-review plan-eng-review review ship qa; do
  backup_if_exists "$CLAUDE_DIR/commands/$cmd.md"
  cp "$SRC_DIR/commands/$cmd.md" "$CLAUDE_DIR/commands/$cmd.md"
done
ok "5 commands installed: /plan-ceo-review /plan-eng-review /review /ship /qa"

echo
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  warn "settings.json already exists — hooks/MCP servers were NOT auto-merged"
  echo -e "  ${DIM}Compare settings.example.json against yours and merge the hooks/mcpServers blocks by hand.${RESET}"
else
  step "No settings.json found — installing the example as a starting point"
  cp "$SRC_DIR/settings.example.json" "$CLAUDE_DIR/settings.json"
  ok "settings.json installed (hooks wired, MCP servers configured)"
fi

if [ "$BACKED_UP" -eq 1 ]; then
  echo
  warn "Existing files you had were backed up to:"
  echo -e "  ${DIM}$BACKUP_DIR${RESET}"
fi

echo
echo -e "${BOLD}Done.${RESET} Frankenstein is installed at ${CYAN}$CLAUDE_DIR${RESET}"
echo
echo -e "${DIM}Try this next:${RESET}"
echo -e "  ${CYAN}1.${RESET} Open CLAUDE.md, edit IDENTITY and STACK SCOPE to match you and your stack"
echo -e "  ${CYAN}2.${RESET} Make a small change, then run ${BOLD}/review${RESET} on the diff"
echo -e "  ${CYAN}3.${RESET} Before your next real feature, run ${BOLD}/plan-eng-review${RESET}"
echo -e "  ${CYAN}4.${RESET} When you're ready to open a PR, run ${BOLD}/ship${RESET} — it still asks before it pushes"
echo -e "  ${CYAN}5.${RESET} Set ${BOLD}GITHUB_TOKEN${RESET} as an env var if you want the github MCP server working"
echo
