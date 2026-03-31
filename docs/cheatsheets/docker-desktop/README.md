# Docker Desktop Cheat Sheet

## Snapshot
- Role: Container runtime bridge for Windows + WSL
- Install entrypoint: Windows host install + prerequisite check script
- Verify command: `docker --version`

## Install
```bash
winget install -e --id Docker.DockerDesktop
bash ./scripts/install/tools/docker-desktop.sh
```

## Daily Commands
```bash
docker context ls
docker ps
docker run --rm hello-world
```

## AI Workflow Notes
- Install and update from Windows host, then use in WSL.
- Enable WSL integration for your distro in Docker Desktop settings.

## Common Troubleshooting
- If command is missing, re-run installer and open a new shell.
- If PATH looks stale, run: `exec bash`.
- If auth is required, run each tool's login command before automation.

## Links
- Main plan: [docs/plan/setup-dotfiles-plan.md](../../plan/setup-dotfiles-plan.md)
- Installer runner: [scripts/install-tools.sh](../../../scripts/install-tools.sh)
