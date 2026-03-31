#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/link-home.sh [--adopt] [--simulate] [--restow] [--skip-windows] [package...]

Options:
  --adopt     Let stow adopt existing plain files into the stow package.
  --simulate  Print what would be changed without writing.
  --restow    Unstow and stow again (more aggressive, sometimes unnecessary).
  --skip-windows  Skip Windows host sync (for example %USERPROFILE%\.wezterm.lua copy).
  --help      Show this help.

Examples:
  ./scripts/link-home.sh
  ./scripts/link-home.sh --adopt
  ./scripts/link-home.sh --restow git
  ./scripts/link-home.sh --simulate git
EOF
}

ADOPT=0
SIMULATE=0
RESTOW=0
SKIP_WINDOWS=0
requested_packages=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --adopt)
      ADOPT=1
      ;;
    --simulate)
      SIMULATE=1
      ;;
    --restow)
      RESTOW=1
      ;;
    --skip-windows)
      SKIP_WINDOWS=1
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      requested_packages+=("$1")
      ;;
  esac
  shift
done

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    echo "This script must run in WSL/Linux, not Git Bash/MSYS."
    echo "Run from WSL, for example:"
    echo "  cd /mnt/c/dev/.dotfiles && ./scripts/link-home.sh"
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DOTFILES_HOME="$REPO_ROOT/home"
TARGET_HOME="$HOME"

if command -v realpath >/dev/null 2>&1; then
  DOTFILES_HOME="$(realpath "$DOTFILES_HOME")"
  TARGET_HOME="$(realpath "$TARGET_HOME")"
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU stow is required. Install it first: sudo apt-get install -y stow"
  exit 1
fi

if [ ! -d "$DOTFILES_HOME" ]; then
  echo "Missing folder: $DOTFILES_HOME"
  exit 1
fi

mapfile -t packages < <(find "$DOTFILES_HOME" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)

if [ "${#packages[@]}" -eq 0 ]; then
  echo "No stow packages found in $DOTFILES_HOME"
  exit 0
fi

if [ "${#requested_packages[@]}" -gt 0 ]; then
  filtered=()
  for pkg in "${requested_packages[@]}"; do
    if [ -d "$DOTFILES_HOME/$pkg" ]; then
      filtered+=("$pkg")
    else
      echo "Unknown stow package: $pkg"
      exit 1
    fi
  done
  packages=("${filtered[@]}")
fi

stow_args=(--target "$TARGET_HOME")
if [ "$ADOPT" -eq 1 ]; then
  stow_args+=(--adopt)
fi
if [ "$SIMULATE" -eq 1 ]; then
  stow_args+=(--simulate)
fi
if [ "$RESTOW" -eq 1 ]; then
  stow_args+=(--restow)
fi

has_conflicts=0
check_conflicts() {
  local pkg="$1"
  local pkg_root="$DOTFILES_HOME/$pkg"
  local src rel target
  while IFS= read -r -d '' src; do
    rel="${src#"$pkg_root"/}"
    target="$TARGET_HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "[conflict] $target already exists and is not a symlink"
      has_conflicts=1
    fi
  done < <(find "$pkg_root" \( -type f -o -type l \) -print0)
}

cleanup_symlink_targets() {
  local pkg="$1"
  local pkg_root="$DOTFILES_HOME/$pkg"
  local src rel target parent
  while IFS= read -r -d '' src; do
    rel="${src#"$pkg_root"/}"
    target="$TARGET_HOME/$rel"

    # If any parent path is a symlink from an old stow root, remove it first.
    parent="$(dirname "$target")"
    while [ "$parent" != "$TARGET_HOME" ] && [ "$parent" != "/" ]; do
      if [ -L "$parent" ]; then
        echo "[cleanup] removing conflicting symlink path $parent"
        rm -f "$parent"
      fi
      parent="$(dirname "$parent")"
    done

    if [ -L "$target" ]; then
      echo "[cleanup] removing existing symlink $target"
      rm -f "$target"
    fi
  done < <(find "$pkg_root" \( -type f -o -type l \) -print0)
}

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

sync_windows_wezterm_copy() {
  local source="$REPO_ROOT/windows/wezterm/.wezterm.lua"
  local windows_home=""
  local target=""
  local backup=""

  if ! is_wsl; then
    return 0
  fi

  if [ ! -f "$source" ]; then
    return 0
  fi

  if ! windows_home="$(resolve_windows_home)"; then
    echo "[warn] Could not resolve Windows user profile; skipping WezTerm Windows link"
    return 0
  fi

  target="$windows_home/.wezterm.lua"

  if [ "$SIMULATE" -eq 1 ]; then
    echo "[simulate] sync Windows WezTerm config: $source -> $target"
    return 0
  fi

  mkdir -p "$windows_home"

  if [ -L "$target" ]; then
    backup="$target.symlink.backup.$(date +%Y%m%d%H%M%S)"
    echo "[cleanup] replacing unsupported Windows WezTerm symlink with regular file copy: $target"
    cp -P "$target" "$backup" 2>/dev/null || true
    rm -f "$target"
  fi

  if [ -e "$target" ] && [ "$ADOPT" -eq 1 ]; then
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    echo "[adopt] moving existing Windows WezTerm config to $backup"
    mv "$target" "$backup"
  fi

  cp "$source" "$target"
  echo "[ok] synced Windows WezTerm config (file copy): $source -> $target"
}

if [ "$ADOPT" -eq 0 ]; then
  for pkg in "${packages[@]}"; do
    check_conflicts "$pkg"
  done

  if [ "$has_conflicts" -eq 1 ]; then
    echo
    echo "Conflicts detected. Re-run with --adopt to let stow adopt existing files."
    echo "Example: ./scripts/link-home.sh --adopt"
    exit 1
  fi
fi

echo "==> Linking packages into $TARGET_HOME"
(
  cd "$DOTFILES_HOME"
  for pkg in "${packages[@]}"; do
    if [ "$ADOPT" -eq 1 ]; then
      cleanup_symlink_targets "$pkg"
    fi
    echo "- stow $pkg"
    stow "${stow_args[@]}" "$pkg"
  done
)

if [ "$SKIP_WINDOWS" -eq 0 ]; then
  echo "==> Syncing Windows host config (WSL only)"
  sync_windows_wezterm_copy
fi

echo "==> Dotfiles linked"
