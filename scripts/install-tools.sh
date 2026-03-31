#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/install/tools"

if [ ! -d "$TOOLS_DIR" ]; then
  echo "Missing tools directory: $TOOLS_DIR"
  exit 1
fi

ordered_tools=(
  tmux
  fzf
  ripgrep
  jq
  gh
  homebrew
  lazygit
  yazi
  television
  go
  sesh
  gh-dash
  worktrunk
  nvm
  node
  npm
  pyenv
  python
  dotnet
  claude
  copilot
  opencode
)

list_tools() {
  printf '%s\n' "${ordered_tools[@]}"
}

run_tool() {
  local tool="$1"
  local installer="$TOOLS_DIR/$tool.sh"

  if [ ! -f "$installer" ]; then
    echo "[missing] Installer not found for tool: $tool"
    return 2
  fi

  echo
  echo "==> Installing $tool"
  if bash "$installer"; then
    echo "[ok] $tool"
    return 0
  fi

  echo "[failed] $tool"
  return 1
}

if [ "${1:-}" = "--list" ]; then
  list_tools
  exit 0
fi

selected_tools=()
if [ "$#" -eq 0 ] || [ "${1:-}" = "all" ]; then
  selected_tools=("${ordered_tools[@]}")
else
  selected_tools=("$@")
fi

failures=()
missing=()

for tool in "${selected_tools[@]}"; do
  if run_tool "$tool"; then
    rc=0
  else
    rc=$?
  fi

  if [ "$rc" -ne 0 ]; then
    case "$rc" in
      1) failures+=("$tool") ;;
      2) missing+=("$tool") ;;
    esac
  fi
done

echo
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing installer scripts: ${missing[*]}"
fi

if [ "${#failures[@]}" -gt 0 ]; then
  echo "Installers with failures: ${failures[*]}"
  exit 1
fi

echo "All requested installers completed."
