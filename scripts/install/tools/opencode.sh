#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists opencode; then
  ok "opencode already installed"
  exit 0
fi

if ! command_exists npm; then
  warn "npm is required. Run node/npm installers first."
  exit 1
fi

OPENCODE_NPM_PACKAGE="${OPENCODE_NPM_PACKAGE:-opencode-ai}"
if npm install -g "$OPENCODE_NPM_PACKAGE"; then
  ok "opencode installed via npm package: $OPENCODE_NPM_PACKAGE"
  exit 0
fi

warn "Failed to install opencode package '$OPENCODE_NPM_PACKAGE'. Set OPENCODE_NPM_PACKAGE and retry."
exit 1
