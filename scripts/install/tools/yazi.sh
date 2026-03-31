#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists yazi; then
  ok "yazi already installed"
  exit 0
fi

if apt_has_package yazi; then
  install_apt_packages yazi
  ok "yazi installed"
  exit 0
fi

warn "yazi apt package not available. Recommended: install via binary release from yazi-rs/yazi."
exit 1
