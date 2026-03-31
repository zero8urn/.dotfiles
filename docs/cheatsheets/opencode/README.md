# OpenCode Cheat Sheet

## Snapshot
- Role: Additional AI coding CLI in toolbox
- Install entrypoint: ./scripts/install/tools/opencode.sh
- Verify command: `opencode --help`

## Install
```bash
./scripts/install-tools.sh opencode
```

## Daily Commands
```bash
opencode
opencode .
opencode --help
```

## AI Workflow Notes
- Use as second-opinion agent for design alternatives.
- Validate generated diffs with git tooling before commit.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
