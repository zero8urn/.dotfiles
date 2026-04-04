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
|   |-- shell/
|   |   |-- .bash_profile
|   |   |-- .bashrc
|   |   |-- .profile
|   |   |-- .zshrc
|   |   `-- .config/dotfiles/shell/env.sh
|   |-- sesh/
|   |   `-- .config/sesh/sesh.toml
|   `-- tmux/
|       `-- .tmux.conf
|-- scripts/
|   |-- bootstrap-wsl.sh
|   |-- doctor.sh
|   |-- install-tools.sh
|   |-- link-home.sh
|   |-- sync-wezterm.sh
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
./scripts/install-tools.sh tmux fzf ripgrep jq gh nvm node npm pyenv python dotnet go claude copilot
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
- On WSL, `link-home.sh` also syncs `windows/wezterm/.wezterm.lua` to `%USERPROFILE%\\.wezterm.lua` as a regular file copy by default. Use `--skip-windows` to opt out.

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
- Installs zsh for interactive shell use (scripts remain bash-based).
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
./scripts/install-tools.sh gh television lazygit go
```

## Shell setup
This repo provides a shared shell environment file at `home/shell/.config/dotfiles/shell/env.sh`.

After running `./scripts/link-home.sh`, this file is sourced from:
- `.zshrc`
- `.bashrc`
- `.bash_profile`
- `.profile`

This ensures tools installed through Homebrew, pyenv, nvm, and Go are available across zsh, bash, tmux, and login shells on first setup.

## Environment variables
`PYENV_ROOT` is set in the shared shell env file. If you are not using the stowed shell package, set it manually in your shell profile:

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
```

## WezTerm on Windows
WezTerm reads `%USERPROFILE%\\.wezterm.lua` on Windows. This is synced automatically as a regular file copy when you run `./scripts/link-home.sh` in WSL.

Why copy and not symlink:
- Recent WezTerm builds can block config traversal through untrusted mount points from WSL.
- A regular file copy at `%USERPROFILE%\\.wezterm.lua` avoids startup errors.

Two-way sync helper:

```bash
./scripts/sync-wezterm.sh --to-windows   # repo -> Windows (default)
./scripts/sync-wezterm.sh --to-repo      # Windows -> repo
```

Manual fallback (if you skip Windows linking):

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