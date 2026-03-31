#!/usr/bin/env bash
set -euo pipefail

required_cmds=(git tmux rg fzf jq stow)
optional_cmds=(gh gh-dash lazygit yazi tv sesh docker node npm pyenv dotnet claude opencode worktrunk)

missing_required=0

echo "==> Required commands"
for cmd in "${required_cmds[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "[ok] %s\n" "$cmd"
  else
    printf "[missing] %s\n" "$cmd"
    missing_required=1
  fi
done

echo
echo "==> Optional commands"
for cmd in "${optional_cmds[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "[ok] %s\n" "$cmd"
  else
    printf "[missing] %s\n" "$cmd"
  fi
done

echo
echo "==> Runtime checks"
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  echo "[ok] nvm init script found"
else
  echo "[missing] nvm init script not found at ~/.nvm/nvm.sh"
fi

if command -v pyenv >/dev/null 2>&1; then
  echo "[ok] pyenv command found"
else
  echo "[missing] pyenv command not found"
fi

for path in "$HOME/.gitconfig" "$HOME/.tmux.conf" "$HOME/.config/sesh/sesh.toml"; do
  if [ -L "$path" ] || [ -f "$path" ]; then
    echo "[ok] $path present"
  else
    echo "[missing] $path not found"
  fi
done

if [ "$missing_required" -ne 0 ]; then
  echo
  echo "Doctor found missing required commands."
  exit 1
fi

echo
echo "Doctor check complete."
