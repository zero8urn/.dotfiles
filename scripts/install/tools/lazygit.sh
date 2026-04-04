#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if command_exists lazygit && version_check "lazygit" lazygit --version; then
  ok "lazygit already installed"
  exit 0
fi

if ls /etc/apt/sources.list.d/lazygit-team-ubuntu-release* >/dev/null 2>&1; then
  warn "Removing stale lazygit PPA entries from previous installer runs"
  sudo rm -f /etc/apt/sources.list.d/lazygit-team-ubuntu-release*
  sudo apt-get update -y || warn "apt update failed after removing stale lazygit PPA; continuing with GitHub release install"
fi

info "Installing lazygit from GitHub release binary"

if ! command_exists curl; then
  warn "curl is required to download lazygit release assets"
  exit 1
fi

if ! command_exists tar; then
  warn "tar is required to extract lazygit release assets"
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

lazygit_version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | sed -n 's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p' | head -n1)"
if [ -z "$lazygit_version" ]; then
  warn "Unable to detect latest lazygit version from GitHub API"
  exit 1
fi

case "$(uname -m)" in
  x86_64|amd64) lazygit_arch="x86_64" ;;
  aarch64|arm64) lazygit_arch="arm64" ;;
  *)
    warn "Unsupported architecture for lazygit auto-install: $(uname -m)"
    exit 1
    ;;
esac

archive="$tmpdir/lazygit.tar.gz"
curl -fLo "$archive" "https://github.com/jesseduffield/lazygit/releases/download/v${lazygit_version}/lazygit_${lazygit_version}_Linux_${lazygit_arch}.tar.gz"
tar -xf "$archive" -C "$tmpdir" lazygit
sudo install "$tmpdir/lazygit" -D -t /usr/local/bin/

if command_exists lazygit && version_check "lazygit" lazygit --version; then
  ok "lazygit installed"
  exit 0
fi

warn "lazygit installation failed. Try installing manually from GitHub releases."
exit 1
