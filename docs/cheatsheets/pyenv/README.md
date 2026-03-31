# pyenv Cheat Sheet

## Snapshot
- Role: Python version manager
- Install entrypoint: ./scripts/install/tools/pyenv.sh
- Verify command: `pyenv --version`

## Install
```bash
./scripts/install-tools.sh pyenv
```

## Daily Commands
```bash
pyenv install 3.12.10
pyenv versions
pyenv global 3.12.10
```

## AI Workflow Notes
- Keep one stable global version plus project-local overrides.
- Rehash after installing global tools.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
