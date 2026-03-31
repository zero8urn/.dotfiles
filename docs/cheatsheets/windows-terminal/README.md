# Windows Terminal Cheat Sheet

## Snapshot
- Role: Fallback terminal for host workflows
- Install entrypoint: manual
- Verify command: `wt --version`

## Install
```bash
winget install -e --id Microsoft.WindowsTerminal
```

## Daily Commands
```bash
wt
wt -p PowerShell
wt -p Ubuntu
```

## AI Workflow Notes
- Use as backup when testing host-native shells.
- Keep profile list minimal and explicit.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
