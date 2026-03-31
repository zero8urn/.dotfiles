# gh-dash Cheat Sheet

## Snapshot
- Role: GitHub dashboard TUI
- Install entrypoint: ./scripts/install/tools/gh-dash.sh
- Verify command: `gh-dash --help`

## Install
```bash
./scripts/install-tools.sh gh-dash
```

## Daily Commands
```bash
gh-dash
gh pr list
gh issue list
```

## AI Workflow Notes
- Use in tmux popup for PR triage loops.
- Keep filters focused on current project/team scope.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
