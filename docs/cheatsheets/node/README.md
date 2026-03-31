# Node.js Cheat Sheet

## Snapshot
- Role: JavaScript runtime
- Install entrypoint: ./scripts/install/tools/node.sh
- Verify command: `node --version`

## Install
```bash
./scripts/install-tools.sh node
```

## Daily Commands
```bash
node -e 'console.log(process.version)'
node -e 'console.log(ok)'
node --test
```

## AI Workflow Notes
- Install through nvm to avoid global drift.
- Keep project versions aligned with .nvmrc when present.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
