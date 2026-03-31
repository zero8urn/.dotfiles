#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists dotnet; then
  ok "dotnet already installed"
  exit 0
fi

install_apt_packages curl ca-certificates
curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
bash /tmp/dotnet-install.sh --channel LTS
rm -f /tmp/dotnet-install.sh

if [ -d "$HOME/.dotnet" ]; then
  ok "dotnet installed to $HOME/.dotnet"
else
  warn "dotnet install script completed but $HOME/.dotnet not found"
  exit 1
fi
