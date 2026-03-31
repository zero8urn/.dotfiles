# Git Bash Cheat Sheet

## Snapshot
- Role: Fallback POSIX-like shell on Windows
- Install entrypoint: manual
- Verify command: `bash --version`

## Install
```bash
winget install -e --id Git.Git
```

## Daily Commands
```bash
git --version
bash -lc 'echo /usr/bin/bash'
bash -lc 'pwd'
```

## AI Workflow Notes
- Useful for quick host-side git operations.
- Prefer WSL bash for primary dev parity.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
