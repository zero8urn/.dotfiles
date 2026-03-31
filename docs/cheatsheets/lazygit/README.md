# Lazygit Cheat Sheet

## Snapshot
- Role: Interactive git UI and diff review
- Install entrypoint: ./scripts/install/tools/lazygit.sh
- Verify command: `lazygit --version`

## Install
```bash
./scripts/install-tools.sh lazygit
```

## Daily Commands
```bash
lazygit
git status -sb
git diff
```

## AI Workflow Notes
- Use as the primary review surface while agents edit code.
- Pair with delta in CLI for side-by-side diff detail.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
