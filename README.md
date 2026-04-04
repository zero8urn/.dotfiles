# .dotfiles

Personal development environment configs and setup scripts for Windows + WSL2.

Prerequisite: install Docker Desktop on Windows host and enable WSL integration for your distro.

## Goals
- Keep all terminal/editor/dev-tool config in one repo.
- Bootstrap a fresh machine quickly.
- Run an AI-first terminal workflow with WezTerm + tmux + popup TUIs.

## Repo layout
```
.
|-- docs/
|   |-- cheatsheets/
|   |   |-- README.md
|   |   `-- <tool>/README.md
|   `-- plan/
|       `-- setup-dotfiles-plan.md
|-- home/
|   |-- git/
|   |   |-- .gitconfig
|   |   `-- .gitignore_global
|   |-- lazygit/
|   |   `-- .config/lazygit/config.yml
|   |-- sesh/
|   |   `-- .config/sesh/sesh.toml
|   `-- tmux/
|       `-- .tmux.conf
|-- scripts/
|   |-- bootstrap-wsl.sh
|   |-- doctor.sh
|   |-- install-tools.sh
|   |-- link-home.sh
|   `-- install/
|       |-- lib/
|       |   `-- common.sh
|       |-- README.md
|       `-- tools/
|           `-- <tool>.sh
`-- windows/
    `-- wezterm/
        `-- .wezterm.lua
```

## Quickstart (WSL)
Run from inside WSL:

```bash
cd /mnt/c/dev/.dotfiles
chmod +x scripts/*.sh
chmod +x scripts/install-tools.sh scripts/install/tools/*.sh
./scripts/bootstrap-wsl.sh
./scripts/install-tools.sh tmux fzf ripgrep jq gh nvm node npm pyenv python dotnet claude copilot
./scripts/link-home.sh
./scripts/doctor.sh
```

If you already have local dotfiles (for example `~/.gitconfig`), use adopt mode:

```bash
./scripts/link-home.sh --adopt
```

Notes:
- Run `link-home.sh` from WSL/Linux, not Git Bash/MSYS.
- Use `--simulate` first if you want a dry run: `./scripts/link-home.sh --simulate`.
- Use `--restow` only when you explicitly need to restow a package: `./scripts/link-home.sh --restow git`.
- In `--adopt` mode, existing symlink targets for managed files are cleaned up first. This helps when migrating from an older clone path.

Optional tools that may require distro-specific/manual steps:

```bash
./scripts/install-tools.sh lazygit yazi television sesh gh-dash worktrunk opencode
```

Host prerequisite check (from WSL):

```bash
bash ./scripts/install/tools/docker-desktop.sh
```

What this does:
- Installs base prerequisites like tmux, stow, fzf, ripgrep, jq, git, and build deps.
- Installs selected tools through one-script-per-tool installers.
- Symlinks stow packages from `home/` into your `$HOME`.

## Windows setup
Run from an elevated PowerShell 7 terminal:

```powershell
pwsh -File .\windows\install\00-prereqs.ps1 -RequireAdmin
pwsh -File .\windows\install\10-winget-core.ps1 -UpgradeInstalled
pwsh -File .\windows\install\20-runtime-toolchains.ps1
pwsh -File .\windows\install\30-custom-installers.ps1
pwsh -File .\windows\install\50-chezmoi-apply.ps1 -RepoUrl <your-repo-url>
pwsh -File .\windows\install\60-bootstrap-profile.ps1
pwsh -File .\windows\install\90-verify.ps1
```

Post-install (after auth):

```powershell
gh auth login
pwsh -File .\windows\install\40-gh-extensions.ps1
```

Notes:
- Run in a PowerShell tab directly (not `pwsh` launched inside Git Bash) for cleaner native tool output.
- If execution policy blocks local scripts, run this in the current terminal session first:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass
```

### PowerShell profile UTF-8 setup
Some native installers emit UTF-8 progress characters. Set UTF-8 in your PowerShell profile to avoid garbled output.

Open your profile:

```powershell
if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }
notepad $PROFILE
```

Add:

```powershell
# UTF-8 for native command output and input
if ([Console]::OutputEncoding.CodePage -ne 65001) { chcp 65001 > $null }
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [Console]::OutputEncoding
```

Open a new PowerShell tab and verify:

```powershell
[Console]::OutputEncoding.WebName
[Console]::OutputEncoding.CodePage
chcp
```

Expected:
- `utf-8`
- `65001`
- `Active code page: 65001`

## Installer model
This repo now uses dedicated installers:
- One tool per script in `scripts/install/tools/`
- One parent executor in `scripts/install-tools.sh`

Useful commands:

```bash
./scripts/install-tools.sh --list
./scripts/install-tools.sh all
./scripts/install-tools.sh gh television lazygit
```

## WezTerm on Windows
WezTerm reads `%USERPROFILE%\\.wezterm.lua` on Windows. Copy this repo config into place:

```powershell
Copy-Item -Path .\windows\wezterm\.wezterm.lua -Destination $HOME\.wezterm.lua -Force
```

If your WSL distro is not named `Ubuntu`, update `default_prog` in `windows/wezterm/.wezterm.lua`.

## tmux workflow defaults
`home/tmux/.tmux.conf` includes:
- Prefix `Ctrl+a`
- Pane splits in current working directory
- Popup keybinds for common tools:
	- `prefix + g` -> lazygit
	- `prefix + y` -> yazi
	- `prefix + a` -> claude code
	- `prefix + d` -> gh-dash (or `gh dash` fallback)
	- `prefix + s` -> sesh picker via fzf
	- `prefix + t` -> television (`tv`)
	- `prefix + p` -> `gh pr status`

## Git diff viewer strategy
This setup uses two layers:
- `delta` for command-line diffs (`git diff`, `git log -p`, etc.)
- `lazygit` popup in tmux for interactive staging/review while agents are making changes

## Next additions
- Add machine profiles (`personal`, `work`) with per-host overrides.
- Improve non-apt installers (yazi, television, sesh, worktrunk) with release-binary automation.
- Add post-install auth setup helpers for claude, gh, copilot, and opencode.

## Cheat sheets
Per-technology cheat sheets now live under:
- `docs/cheatsheets/README.md`

Each technology has its own `README.md` using the same structure for consistency.