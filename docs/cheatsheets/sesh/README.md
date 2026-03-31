# sesh Cheat Sheet

## Snapshot
- Role: tmux session manager and quick switcher
- Install entrypoint: ./scripts/install/tools/sesh.sh
- Verify command: `sesh --help`

## Install
```bash
./scripts/install-tools.sh sesh
```

## Daily Commands
```bash
sesh list
sesh connect dotfiles
sesh connect home
```

## AI Workflow Notes
- Use sesh for jump-based session selection.
- Combine with tmux popup keybind for low-friction switching.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
