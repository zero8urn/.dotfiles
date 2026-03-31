# Windows Cheat Sheet

## Snapshot
- Role: Host OS and package manager surface
- Install entrypoint: manual
- Verify command: `ver`

## Install
```bash
winget upgrade --all
```

## Daily Commands
```bash
winget list
systeminfo | head -n 5
wsl --status
```

## AI Workflow Notes
- Keep Windows updated before WSL-heavy work.
- Use winget for reproducible host-side installs.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
