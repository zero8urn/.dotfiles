# tmux Cheat Sheet

## Snapshot
- Role: Session and pane multiplexer for deep workflow
- Install entrypoint: ./scripts/install/tools/tmux.sh
- Verify command: `tmux -V`

## Install
```bash
./scripts/install-tools.sh tmux
```

## Daily Commands
```bash
tmux new -s dotfiles
tmux ls
tmux attach -t dotfiles
```

## AI Workflow Notes
- Use sessions per project and windows per concern.
- Pair with popup tools for review-heavy agent workflows.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
