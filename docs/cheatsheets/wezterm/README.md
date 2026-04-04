# WezTerm Cheat Sheet

## Snapshot
- Role: Primary terminal emulator on Windows
- Install entrypoint: manual
- Verify command: `wezterm --version`

## Install
```bash
winget install -e --id wez.wezterm
```

## Daily Commands
```bash
wezterm
wezterm cli list
wezterm start -- wsl.exe -d Ubuntu
./scripts/sync-wezterm.sh --to-windows
./scripts/sync-wezterm.sh --to-repo
```

## AI Workflow Notes
- Use WezTerm tabs for high-level contexts.
- Use tmux inside WSL for persistent sessions.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If WezTerm reports config traversal or untrusted mount errors, sync a regular Windows copy: `./scripts/sync-wezterm.sh --to-windows`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
