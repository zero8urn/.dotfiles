#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists yazi && version_check "yazi" yazi --version; then
  ok "yazi already installed"
  exit 0
fi

if apt_has_package yazi; then
  install_apt_packages yazi
  if command_exists yazi && version_check "yazi" yazi --version; then
    ok "yazi installed"
    exit 0
  fi
fi

if ensure_brew_loaded || bash "$SCRIPT_DIR/homebrew.sh"; then
  ensure_brew_loaded
  info "Installing yazi via Homebrew"
  brew install yazi
  if command_exists yazi && version_check "yazi" yazi --version; then
    ok "yazi installed"
    exit 0
  fi
fi

warn "yazi install failed. On Debian/Ubuntu, install official binary release from sxyazi/yazi releases."
exit 1
