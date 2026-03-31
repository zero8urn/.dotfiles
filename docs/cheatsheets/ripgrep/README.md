# ripgrep Cheat Sheet

## Snapshot
- Role: Fast code search engine
- Install entrypoint: ./scripts/install/tools/ripgrep.sh
- Verify command: `rg --version`

## Install
```bash
./scripts/install-tools.sh ripgrep
```

## Daily Commands
```bash
rg TODO
rg --files
rg 'function|class' src
```

## AI Workflow Notes
- Prefer rg over grep for speed in large repos.
- Use regex alternation to reduce repeated scans.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
