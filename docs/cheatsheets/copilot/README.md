# GitHub Copilot CLI Cheat Sheet

## Snapshot
- Role: GitHub Copilot in terminal via gh extension
- Install entrypoint: ./scripts/install/tools/copilot.sh
- Verify command: `gh copilot --help`

## Install
```bash
./scripts/install-tools.sh copilot
```

## Daily Commands
```bash
gh auth status
gh copilot suggest 'write a bash loop'
gh copilot explain 'git rebase --rebase-merges'
```

## AI Workflow Notes
- Keep prompts scoped and explicit for better completions.
- Use gh auth refresh if extension commands fail.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
