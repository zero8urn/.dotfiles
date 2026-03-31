#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists gh-dash; then
  ok "gh-dash already installed"
  exit 0
fi

if ! command_exists gh; then
  warn "gh is required first. Run: ./scripts/install/tools/gh.sh"
  exit 1
fi

if gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
  ok "gh-dash extension already installed"
  exit 0
fi

gh extension install dlvhdr/gh-dash
ok "gh-dash extension installed"
