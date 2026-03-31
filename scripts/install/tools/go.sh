#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists go && version_check "go" go version; then
  ok "go already installed"
  exit 0
fi

if apt_has_package golang-go; then
  install_apt_packages golang-go
elif apt_has_package golang; then
  install_apt_packages golang
else
  warn "Go package not found in apt repositories"
  exit 1
fi

if command_exists go && version_check "go" go version; then
  ok "go installed"
  exit 0
fi

warn "go installation failed"
exit 1
