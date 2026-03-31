#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists docker; then
  ok "docker CLI already available in this shell"
  exit 0
fi

warn "Docker Desktop is a Windows install. Install/update it on Windows and enable WSL integration."
warn "After install, reopen WSL and verify with: docker --version"
exit 1
