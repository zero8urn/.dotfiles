# jq Cheat Sheet

## Snapshot
- Role: JSON transformation and filtering
- Install entrypoint: ./scripts/install/tools/jq.sh
- Verify command: `jq --version`

## Install
```bash
./scripts/install-tools.sh jq
```

## Daily Commands
```bash
cat package.json | jq '.'
gh api user | jq '.login'
jq -r '.[] | .name' data.json
```

## AI Workflow Notes
- Use jq to extract exact fields for scripts.
- Combine gh api + jq for GitHub automation.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
