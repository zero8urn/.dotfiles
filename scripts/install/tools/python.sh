#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/common.sh"

PYTHON_VERSION="${PYTHON_VERSION:-3.12.10}"

if ! ensure_pyenv_loaded; then
  warn "pyenv is required. Run: ./scripts/install/tools/pyenv.sh"
  exit 1
fi

if pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
  ok "python ${PYTHON_VERSION} already installed in pyenv"
else
  pyenv install "$PYTHON_VERSION"
fi

pyenv global "$PYTHON_VERSION"
ok "python ${PYTHON_VERSION} set as global via pyenv"
