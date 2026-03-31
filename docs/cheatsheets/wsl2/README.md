# WSL2 Cheat Sheet

## Snapshot
- Role: Primary Linux runtime for local dev
- Install entrypoint: manual
- Verify command: `wsl --status`

## Install
```bash
wsl --install -d Ubuntu
```

## Daily Commands
```bash
wsl -l -v
wsl --shutdown
wsl -d Ubuntu
```

## AI Workflow Notes
- Run development tools in WSL for consistency.
- Keep repo under /mnt/c or inside Linux home based on perf needs.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
