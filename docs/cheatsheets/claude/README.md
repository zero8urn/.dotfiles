# Claude Code Cheat Sheet

## Snapshot
- Role: Agentic coding assistant in terminal
- Install entrypoint: ./scripts/install/tools/claude.sh
- Verify command: `claude --version`

## Install
```bash
./scripts/install-tools.sh claude
```

## Daily Commands
```bash
claude
claude .
claude --help
```

## AI Workflow Notes
- Run in a dedicated tmux pane or popup to isolate context.
- Review changes continuously with lazygit or delta.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
