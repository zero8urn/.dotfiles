#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/sync-wezterm.sh [--to-windows|--to-repo] [--simulate] [--adopt]

Options:
  --to-windows  Copy repo config to Windows (%USERPROFILE%\\.wezterm.lua). Default.
  --to-repo     Copy Windows config back into repo (windows/wezterm/.wezterm.lua).
  --simulate    Print what would be changed without writing.
  --adopt       Backup destination file before replacing it.
  --help        Show this help.
EOF
}

MODE="to-windows"
SIMULATE=0
ADOPT=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --to-windows)
      MODE="to-windows"
      ;;
    --to-repo)
      MODE="to-repo"
      ;;
    --simulate)
      SIMULATE=1
      ;;
    --adopt)
      ADOPT=1
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

is_wsl() {
  if [ -n "${WSL_DISTRO_NAME:-}" ]; then
    return 0
  fi
  grep -qi microsoft /proc/version 2>/dev/null
}

resolve_windows_home() {
  local raw=""

  if [ -n "${USERPROFILE:-}" ]; then
    raw="$USERPROFILE"
  elif command -v powershell.exe >/dev/null 2>&1; then
    raw="$(powershell.exe -NoProfile -Command '$env:USERPROFILE' 2>/dev/null | tr -d '\r')"
  fi

  if [ -z "$raw" ]; then
    return 1
  fi

  if command -v wslpath >/dev/null 2>&1; then
    wslpath "$raw"
  else
    echo "$raw"
  fi
}

backup_if_needed() {
  local dst="$1"
  if [ -e "$dst" ] && [ "$ADOPT" -eq 1 ]; then
    local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
    echo "[adopt] moving existing file to $backup"
    mv "$dst" "$backup"
  fi
}

if ! is_wsl; then
  echo "This script is intended for WSL/Linux where Windows home is reachable."
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
REPO_WEZTERM="$REPO_ROOT/windows/wezterm/.wezterm.lua"

if ! WINDOWS_HOME="$(resolve_windows_home)"; then
  echo "Could not resolve Windows user profile."
  exit 1
fi

WINDOWS_WEZTERM="$WINDOWS_HOME/.wezterm.lua"

if [ "$MODE" = "to-windows" ]; then
  src="$REPO_WEZTERM"
  dst="$WINDOWS_WEZTERM"

  if [ ! -f "$src" ]; then
    echo "Missing source file: $src"
    exit 1
  fi

  if [ "$SIMULATE" -eq 1 ]; then
    echo "[simulate] copy $src -> $dst"
    exit 0
  fi

  mkdir -p "$WINDOWS_HOME"
  if [ -L "$dst" ]; then
    echo "[cleanup] removing symlink destination: $dst"
    rm -f "$dst"
  fi
  backup_if_needed "$dst"
  cp "$src" "$dst"
  echo "[ok] synced WezTerm config to Windows: $src -> $dst"
else
  src="$WINDOWS_WEZTERM"
  dst="$REPO_WEZTERM"

  if [ ! -f "$src" ]; then
    echo "Missing source file: $src"
    exit 1
  fi

  if [ "$SIMULATE" -eq 1 ]; then
    echo "[simulate] copy $src -> $dst"
    exit 0
  fi

  mkdir -p "$(dirname "$dst")"
  backup_if_needed "$dst"
  cp "$src" "$dst"
  echo "[ok] synced WezTerm config to repo: $src -> $dst"
fi
