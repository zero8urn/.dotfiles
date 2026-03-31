# fzf Cheat Sheet

## Snapshot
- Role: Interactive fuzzy finder
- Install entrypoint: ./scripts/install/tools/fzf.sh
- Verify command: `fzf --version`

## Install
```bash
./scripts/install-tools.sh fzf
```

## Daily Commands
```bash
history | fzf
fd . | fzf
git branch | fzf
```

## AI Workflow Notes
- Pipe command outputs into fzf for fast selection.
- Use in tmux popups to avoid layout churn.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
