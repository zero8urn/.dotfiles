#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists worktrunk; then
  ok "worktrunk already installed"
  exit 0
fi

warn "worktrunk install is not fully automated yet. Install from max-sixty/worktrunk release artifacts."
exit 1
