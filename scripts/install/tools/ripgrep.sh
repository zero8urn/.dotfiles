#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists rg; then
  ok "ripgrep already installed"
  exit 0
fi

install_apt_packages ripgrep
ok "ripgrep installed"
