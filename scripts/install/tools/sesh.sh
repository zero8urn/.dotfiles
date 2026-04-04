#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists sesh && (version_check "sesh" sesh --version || version_check "sesh" sesh -V); then
  ok "sesh already installed"
  exit 0
fi

if ! command_exists go; then
  info "Go runtime is required for sesh installation"
  if ! bash "$SCRIPT_DIR/go.sh"; then
    warn "Failed to install Go runtime for sesh"
    exit 1
  fi
fi

info "Installing sesh via Go"
go install github.com/joshmedeski/sesh@latest
export PATH="$(go env GOPATH)/bin:$PATH"

if command_exists sesh && (version_check "sesh" sesh --version || version_check "sesh" sesh -V); then
  ok "sesh installed"
  exit 0
fi

warn "sesh install failed. Ensure Go is on PATH and retry."
exit 1
