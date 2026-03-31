#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists tv && (version_check "television" tv --version || version_check "television" tv -V); then
  ok "television already installed"
  exit 0
fi

if apt_has_package television; then
  install_apt_packages television
  if command_exists tv && (version_check "television" tv --version || version_check "television" tv -V); then
    ok "television installed"
    exit 0
  fi
fi

if command_exists curl; then
  info "Installing television via upstream install script"
  if curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash; then
    if command_exists tv && (version_check "television" tv --version || version_check "television" tv -V); then
      ok "television installed"
      exit 0
    fi
  fi
  warn "television install script finished, but tv was not found in PATH"
fi

if ensure_brew_loaded || bash "$SCRIPT_DIR/homebrew.sh"; then
  ensure_brew_loaded
  info "Installing television via Homebrew"
  brew install television
  if command_exists tv && (version_check "television" tv --version || version_check "television" tv -V); then
    ok "television installed"
    exit 0
  fi
fi

warn "television install failed. Try: curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash"
exit 1
