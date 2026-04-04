#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists fzf; then
  ok "fzf already installed"
  exit 0
fi

install_apt_packages fzf
ok "fzf installed"
