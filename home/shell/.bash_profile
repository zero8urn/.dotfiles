# Load interactive shell settings for login shells.
if [ -f "$HOME/.bashrc" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.bashrc"
fi
