# yazi Cheat Sheet

## Snapshot
- Role: Terminal file manager
- Install entrypoint: ./scripts/install/tools/yazi.sh
- Verify command: `yazi --version`

## Install
```bash
./scripts/install-tools.sh yazi
```

## Daily Commands
```bash
yazi
yazi ~/dev
yazi .
```

## AI Workflow Notes
- Use as popup tool to browse trees without leaving shell.
- Keep yazi transient; return to tmux pane for commands.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
