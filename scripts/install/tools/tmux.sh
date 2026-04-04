#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists tmux; then
  ok "tmux already installed"
  exit 0
fi

install_apt_packages tmux
ok "tmux installed"
