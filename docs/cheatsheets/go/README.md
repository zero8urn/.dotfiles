# Go Cheat Sheet

## Snapshot
- Role: Go toolchain for CLI builds and `go install` workflows
- Install entrypoint: ./scripts/install/tools/go.sh
- Verify command: `go version`

## Install
```bash
./scripts/install-tools.sh go
```

## Daily Commands
```bash
go version
go env GOPATH
go install github.com/joshmedeski/sesh@latest
```

## AI Workflow Notes
- Use `go install <module>@latest` for lightweight CLI tool installs.
- Keep `$(go env GOPATH)/bin` on PATH for user-installed binaries.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
