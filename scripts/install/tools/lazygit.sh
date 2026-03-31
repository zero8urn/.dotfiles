#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists lazygit; then
  ok "lazygit already installed"
  exit 0
fi

if apt_has_package lazygit; then
  install_apt_packages lazygit
  ok "lazygit installed"
  exit 0
fi

warn "lazygit apt package not available on this distro. Install manually from GitHub releases."
exit 1
