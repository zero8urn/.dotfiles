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

brew_bin_path() {
  if command_exists brew; then
    command -v brew
    return 0
  fi

  local candidate
  for candidate in "$HOME/.linuxbrew/bin/brew" "/home/linuxbrew/.linuxbrew/bin/brew"; do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

ensure_brew_loaded() {
  local brew_bin
  if ! brew_bin="$(brew_bin_path)"; then
    return 1
  fi

  # shellcheck disable=SC1090
  eval "$("$brew_bin" shellenv)"
  command_exists brew
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
  local pyenv_bin

  if command_exists pyenv; then
    pyenv_bin="$(command -v pyenv)"
    if [[ "$(uname -s)" = "Linux" && "$pyenv_bin" == *"pyenv-win"* ]]; then
      info "Ignoring Windows pyenv at $pyenv_bin while running on Linux/WSL"
    else
      eval "$(pyenv init -)"
      return 0
    fi
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

version_check() {
  local tool_name="$1"
  shift

  local output
  if output="$("$@" 2>&1)"; then
    output="$(printf '%s\n' "$output" | head -n1)"
    if [ -n "$output" ]; then
      ok "$tool_name version: $output"
    else
      ok "$tool_name version check passed"
    fi
    return 0
  fi

  warn "$tool_name installed but version check failed: $*"
  return 1
}
