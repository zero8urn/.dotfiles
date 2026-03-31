# GitHub CLI Cheat Sheet

## Snapshot
- Role: GitHub operations, auth, and API access
- Install entrypoint: ./scripts/install/tools/gh.sh
- Verify command: `gh --version`

## Install
```bash
./scripts/install-tools.sh gh
```

## Daily Commands
```bash
gh auth login
gh repo view
gh pr status
```

## AI Workflow Notes
- Use gh as backbone for PR and issue automation.
- Extensions (copilot, gh-dash) depend on gh auth.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
