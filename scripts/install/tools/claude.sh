#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists claude; then
  ok "claude already installed"
  exit 0
fi

if ! command_exists npm; then
  warn "npm is required. Run node/npm installers first."
  exit 1
fi

npm install -g @anthropic-ai/claude-code
ok "claude code installed"
