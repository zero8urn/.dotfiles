#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if [ -d "$HOME/.nvm" ]; then
  ok "nvm already installed"
  exit 0
fi

install_apt_packages curl ca-certificates
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
ok "nvm installed"
