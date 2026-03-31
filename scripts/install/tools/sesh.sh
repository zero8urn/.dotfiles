#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists sesh; then
  ok "sesh already installed"
  exit 0
fi

warn "sesh install is not fully automated yet. Install from joshmedeski/sesh release artifacts."
exit 1
