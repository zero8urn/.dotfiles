#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/link-home.sh [--adopt] [--simulate] [--restow] [package...]

Options:
  --adopt     Let stow adopt existing plain files into the stow package.
  --simulate  Print what would be changed without writing.
  --restow    Unstow and stow again (more aggressive, sometimes unnecessary).
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
    echo "- stow $pkg"
    stow "${stow_args[@]}" "$pkg"
  done
)

echo "==> Dotfiles linked"
