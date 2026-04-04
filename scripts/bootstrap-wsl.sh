#!/usr/bin/env bash
set -euo pipefail

if ! grep -qi microsoft /proc/version 2>/dev/null; then
  echo "Warning: this script is designed for WSL, but it can still run on Linux."
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required to install packages."
  exit 1
fi

echo "==> Updating apt index"
sudo apt-get update

base_packages=(
  build-essential
  ca-certificates
  curl
  fd-find
  fzf
  git
  jq
  ripgrep
  stow
  tmux
  unzip
  zip
  zoxide
  zsh
)

python_build_packages=(
  libbz2-dev
  libffi-dev
  liblzma-dev
  libncursesw5-dev
  libreadline-dev
  libsqlite3-dev
  libssl-dev
  llvm
  make
  tk-dev
  xz-utils
  zlib1g-dev
)

optional_packages=(gh)
if apt-cache show git-delta >/dev/null 2>&1; then
  optional_packages+=(git-delta)
elif apt-cache show delta >/dev/null 2>&1; then
  optional_packages+=(delta)
fi

echo "==> Installing base packages"
sudo apt-get install -y "${base_packages[@]}" "${python_build_packages[@]}" "${optional_packages[@]}"

echo "==> Bootstrap complete"
if command -v zsh >/dev/null 2>&1; then
  echo "zsh installed. Set as default shell if desired: chsh -s \"$(command -v zsh)\""
fi
echo "Next steps:"
echo "  1) ./scripts/install-tools.sh tmux fzf ripgrep jq gh nvm node npm pyenv python dotnet go"
echo "  2) ./scripts/link-home.sh"
echo "  3) ./scripts/doctor.sh"
