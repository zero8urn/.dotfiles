# npm Cheat Sheet

## Snapshot
- Role: Node package manager
- Install entrypoint: ./scripts/install/tools/npm.sh
- Verify command: `npm --version`

## Install
```bash
./scripts/install-tools.sh npm
```

## Daily Commands
```bash
npm ci
npm run test
npm outdated
```

## AI Workflow Notes
- Use npm scripts as the canonical task interface.
- Prefer npm ci in CI-style reproducible installs.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
