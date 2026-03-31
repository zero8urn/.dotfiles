#!/usr/bin/env bash
set -euo pipefail

log() {
  local level="$1"
  shift
  printf '[%s] %s\n' "$level" "$*"
}

info() {
  log INFO "$*"
}

warn() {
  log WARN "$*"
}

ok() {
  log OK "$*"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

apt_update() {
  info "Updating apt package index"
  sudo apt-get update -y
}

install_apt_packages() {
  local packages=("$@")
  apt_update
  sudo apt-get install -y "${packages[@]}"
}

apt_has_package() {
  apt-cache show "$1" >/dev/null 2>&1
}

ensure_nvm_loaded() {
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
    return 0
  fi

  return 1
}

ensure_pyenv_loaded() {
  if command_exists pyenv; then
    eval "$(pyenv init -)"
    return 0
  fi

  if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command_exists pyenv; then
      eval "$(pyenv init -)"
      return 0
    fi
  fi

  return 1
}
