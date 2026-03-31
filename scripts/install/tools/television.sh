#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists tv; then
  ok "television already installed"
  exit 0
fi

if apt_has_package television; then
  install_apt_packages television
  ok "television installed"
  exit 0
fi

warn "television is not available from apt on most distros. Install from alexpasmantier/television release binaries."
exit 1
