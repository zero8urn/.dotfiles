#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if ensure_brew_loaded; then
  ok "homebrew already installed"
  exit 0
fi

if ! command_exists curl; then
  install_apt_packages curl ca-certificates
fi

info "Installing Homebrew via official install script"
NONINTERACTIVE=1 CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if ensure_brew_loaded; then
  ok "homebrew installed"
  exit 0
fi

warn "homebrew installation completed, but brew is not available in this shell. Start a new shell and retry."
exit 1