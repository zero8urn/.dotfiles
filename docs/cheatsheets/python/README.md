# Python Cheat Sheet

## Snapshot
- Role: Python runtime for tools and scripts
- Install entrypoint: ./scripts/install/tools/python.sh
- Verify command: `python --version`

## Install
```bash
./scripts/install-tools.sh python
```

## Daily Commands
```bash
python -m venv .venv
python -m pip install -U pip
python -m pip list
```

## AI Workflow Notes
- Install interpreter via pyenv for version control.
- Use per-project virtualenvs for isolation.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
