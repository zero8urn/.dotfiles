# VS Code Cheat Sheet

## Snapshot
- Role: Main editor and AI agent host
- Install entrypoint: manual
- Verify command: `code --version`

## Install
```bash
winget install -e --id Microsoft.VisualStudioCode
```

## Daily Commands
```bash
code .
code --install-extension GitHub.copilot
code --install-extension ms-vscode-remote.remote-wsl
```

## AI Workflow Notes
- Prefer Remote-WSL sessions for Linux toolchains.
- Use workspace settings to pin formatting and shell behavior.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
