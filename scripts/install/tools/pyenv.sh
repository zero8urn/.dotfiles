#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

if ensure_pyenv_loaded; then
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

if ensure_pyenv_loaded; then
  ok "pyenv installed"
  exit 0
fi

warn "pyenv installation completed, but pyenv is not available in this shell"
exit 1
