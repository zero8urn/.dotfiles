#!/usr/bin/env bash
set -euo pipefail

required_cmds=(git tmux rg fzf jq stow zsh)
optional_cmds=(gh gh-dash lazygit yazi tv sesh docker node npm pyenv dotnet go claude opencode wt)

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

if [ -f "$HOME/.config/dotfiles/shell/env.sh" ]; then
  echo "[ok] shared shell env found at ~/.config/dotfiles/shell/env.sh"
else
  echo "[missing] shared shell env not found at ~/.config/dotfiles/shell/env.sh"
fi

if [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qi microsoft /proc/version 2>/dev/null; then
  windows_home=""
  if [ -n "${USERPROFILE:-}" ] && command -v wslpath >/dev/null 2>&1; then
    windows_home="$(wslpath "$USERPROFILE" 2>/dev/null || true)"
  elif command -v powershell.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then
    userprofile_win="$(powershell.exe -NoProfile -Command '$env:USERPROFILE' 2>/dev/null | tr -d '\r')"
    if [ -n "$userprofile_win" ]; then
      windows_home="$(wslpath "$userprofile_win" 2>/dev/null || true)"
    fi
  fi

  if [ -n "$windows_home" ]; then
    windows_wezterm="$windows_home/.wezterm.lua"
    if [ -L "$windows_wezterm" ]; then
      echo "[warn] Windows WezTerm config is a symlink at $windows_wezterm"
      echo "[warn] Recent WezTerm builds may reject symlink traversal from WSL mounts."
      echo "[warn] Run ./scripts/sync-wezterm.sh --to-windows to replace it with a regular file copy."
    elif [ -f "$windows_wezterm" ]; then
      echo "[ok] Windows WezTerm config exists as regular file at $windows_wezterm"
    else
      echo "[missing] Windows WezTerm config not found: $windows_wezterm"
    fi
  else
    echo "[warn] Could not resolve Windows user profile to check WezTerm config"
  fi
fi

if [ "$missing_required" -ne 0 ]; then
  echo
  echo "Doctor found missing required commands."
  exit 1
fi

echo
echo "Doctor check complete."
