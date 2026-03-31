# Shared shell environment for bash and zsh in WSL/Linux

# Guard against duplicate loads from nested startup files.
if [ -n "${DOTFILES_SHELL_ENV_LOADED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
export DOTFILES_SHELL_ENV_LOADED=1

# Homebrew (Linux)
if [ -x "$HOME/.linuxbrew/bin/brew" ]; then
  eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$("/home/linuxbrew/.linuxbrew/bin/brew" shellenv)"
fi

# pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
if [ -d "$PYENV_ROOT/bin" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Go-installed CLI tools
if [ -d "$HOME/go/bin" ]; then
  export PATH="$HOME/go/bin:$PATH"
fi

# nvm (optional)
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "$NVM_DIR/nvm.sh"
fi
