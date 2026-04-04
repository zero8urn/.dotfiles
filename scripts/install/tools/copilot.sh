#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists gh; then
  warn "gh CLI is required for Copilot CLI extension."
  exit 1
fi

if gh extension list 2>/dev/null | grep -q "github/gh-copilot"; then
  ok "gh-copilot extension already installed"
  exit 0
fi

gh extension install github/gh-copilot
ok "gh-copilot extension installed"
