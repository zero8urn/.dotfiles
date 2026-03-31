# .NET SDK Cheat Sheet

## Snapshot
- Role: C# and .NET CLI toolchain
- Install entrypoint: ./scripts/install/tools/dotnet.sh
- Verify command: `dotnet --info`

## Install
```bash
./scripts/install-tools.sh dotnet
```

## Daily Commands
```bash
dotnet --list-sdks
dotnet new console -n hello-dotnet
dotnet test
```

## AI Workflow Notes
- Use local SDK version pinning when needed.
- Keep PATH including /c/Users/bboyd/.dotnet for shell sessions.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
