#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if ! command_exists npm; then
  warn "npm not found. Run node installer first."
  exit 1
fi

npm install -g npm@latest
ok "npm updated to latest"
