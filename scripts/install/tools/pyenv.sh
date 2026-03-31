#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if [ -d "$HOME/.pyenv" ] && command_exists pyenv; then
  ok "pyenv already installed"
  exit 0
fi

install_apt_packages \
  build-essential \
  curl \
  git \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  llvm \
  make \
  tk-dev \
  xz-utils \
  zlib1g-dev

curl -fsSL https://pyenv.run | bash
ok "pyenv installed"
