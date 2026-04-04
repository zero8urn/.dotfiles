#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists node; then
  ok "node already installed"
  exit 0
fi

if ! ensure_nvm_loaded; then
  warn "nvm is required. Run: ./scripts/install/tools/nvm.sh"
  exit 1
fi

nvm install --lts
ok "node installed via nvm"
