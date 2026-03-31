# Television Cheat Sheet

## Snapshot
- Role: Fuzzy picker and command launcher
- Install entrypoint: ./scripts/install/tools/television.sh
- Verify command: `tv --version`

## Install
```bash
./scripts/install-tools.sh television
```

## Daily Commands
```bash
tv
tv files
tv recent
```

## AI Workflow Notes
- Use tv for command/file recall when context switching.
- Keep key muscle-memory aligned with fzf usage.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
