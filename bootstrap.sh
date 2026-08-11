#!/usr/bin/env bash
# Frankenstein one-line installer.
# Downloads the repo (no git required) and hands off to install.sh.
# Usage: curl -fsSL https://raw.githubusercontent.com/WeSky-source/frankenstein-cli/master/bootstrap.sh | bash

set -euo pipefail

REPO="WeSky-source/frankenstein-cli"
BOLD='\033[1m'; RED='\033[0;31m'; GREEN='\033[0;32m'; RESET='\033[0m'

echo -e "${BOLD}Frankenstein${RESET} — downloading...\n"

if ! command -v curl >/dev/null 2>&1; then
  echo -e "${RED}Missing 'curl'.${RESET} It comes with every Mac. On Linux: sudo apt install curl (or your distro's package manager)."
  exit 1
fi
if ! command -v tar >/dev/null 2>&1; then
  echo -e "${RED}Missing 'tar'.${RESET} This should already be on your system — try updating it, or ask for help."
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if ! curl -fsSL "https://github.com/$REPO/archive/refs/heads/master.tar.gz" -o "$TMP_DIR/frankenstein.tar.gz"; then
  echo -e "${RED}Download failed.${RESET} Check your internet connection and try again."
  exit 1
fi

tar -xzf "$TMP_DIR/frankenstein.tar.gz" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name "frankenstein-cli-*")"

if [ -z "$EXTRACTED_DIR" ]; then
  echo -e "${RED}Something went wrong unpacking the download.${RESET} Try the manual install in the README instead."
  exit 1
fi

echo -e "${GREEN}✓${RESET} Downloaded. Handing off to the installer...\n"

# Piping this whole script into bash consumes stdin, so install.sh's
# yes/no prompt would otherwise silently get skipped (read hits EOF).
# Reattach the real terminal explicitly when one exists.
# `[ -r /dev/tty ]` only checks permission bits — the device node can exist
# and pass that check with no controlling terminal actually behind it (CI,
# containers, some sandboxes), which crashes a plain redirect. Try to
# actually open it in a no-op subshell first and fall back on failure.
if ( : < /dev/tty ) 2>/dev/null; then
  bash "$EXTRACTED_DIR/install.sh" < /dev/tty
else
  bash "$EXTRACTED_DIR/install.sh"
fi
