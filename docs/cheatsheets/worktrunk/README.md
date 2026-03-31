# Worktrunk Cheat Sheet

## Snapshot
- Role: Branch/worktree helper for parallel tasks
- Install entrypoint: ./scripts/install/tools/worktrunk.sh
- Verify command: `worktrunk --help`

## Install
```bash
./scripts/install-tools.sh worktrunk
```

## Daily Commands
```bash
worktrunk --help
git worktree list
git branch -vv
```

## AI Workflow Notes
- Use worktree-first branching for concurrent agent tasks.
- Keep one tmux session per active worktree.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
