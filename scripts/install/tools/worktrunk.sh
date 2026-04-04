#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

worktrunk_cmd() {
  if command_exists wt; then
    printf '%s\n' wt
    return 0
  fi

  if command_exists worktrunk; then
    printf '%s\n' worktrunk
    return 0
  fi

  return 1
}

verify_worktrunk_version() {
  local cmd
  if ! cmd="$(worktrunk_cmd)"; then
    return 1
  fi

  version_check "worktrunk" "$cmd" --version || version_check "worktrunk" "$cmd" -V
}

if verify_worktrunk_version; then
  ok "worktrunk already installed"
  exit 0
fi

if ensure_brew_loaded || bash "$SCRIPT_DIR/homebrew.sh"; then
  ensure_brew_loaded
  info "Installing worktrunk via Homebrew"
  brew install worktrunk
  if verify_worktrunk_version; then
    ok "worktrunk installed"
    exit 0
  fi
fi

warn "worktrunk install failed. Try: brew install worktrunk"
exit 1
