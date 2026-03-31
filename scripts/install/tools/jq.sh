#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists jq; then
  ok "jq already installed"
  exit 0
fi

install_apt_packages jq
ok "jq installed"
