# Setup .dotfiles

## Context
- Host OS: Windows
- Linux environment: WSL2
- Main terminal: WezTerm (Windows) into WSL
- Backup terminals: Windows Terminal and Git Bash when needed
- Editor: VS Code + agentic coding tools

## Tool inventory
- Core shell/dev flow:
	- tmux
	- sesh
	- fzf
	- ripgrep
	- jq
	- yazi
	- television: https://github.com/alexpasmantier/television
- AI-assisted coding:
	- claude code (CLI + VS Code workflow)
	- GitHub Copilot (CLI + VS Code workflow)
	- opencode
- Source control and review:
	- gh cli: https://cli.github.com/
	- lazygit
	- gh-dash: https://github.com/dlvhdr/gh-dash?tab=readme-ov-file
	- worktrunk: https://github.com/max-sixty/worktrunk
- Runtime/toolchains:
	- dotnet
	- node
	- npm
	- nvm
	- python
	- pyenv
- Platform:
	- Docker Desktop (Windows host prerequisite)

## Installer architecture
- `scripts/install-tools.sh`: parent executor
- `scripts/install/tools/<tool>.sh`: one installer per tool
- `scripts/install/lib/common.sh`: shared helper functions
- `scripts/install/tools/docker-desktop.sh`: host prerequisite checker (not included in `all`)

### Installer usage
1. List supported tools:
	 - `./scripts/install-tools.sh --list`
2. Install all:
	 - `./scripts/install-tools.sh all`
3. Install selected tools:
	 - `./scripts/install-tools.sh gh television lazygit`

### Cheatsheets
- `docs/cheatsheets/README.md` is the index.
- Each technology has its own cheatsheet file at `docs/cheatsheets/<tool>/README.md`.

## Phased plan

### Phase 1: Baseline repo scaffolding
- Create a predictable folder layout for configs and scripts.
- Add idempotent bootstrap scripts for WSL.
- Use stow-based symlink management for home directory files.
- Add a doctor script to verify command availability and linked config presence.

### Phase 2: Terminal + session ergonomics
- Configure WezTerm for WSL-first startup.
- Configure tmux with popup workflows for tool UIs.
- Add sesh config for named session roots (home, dotfiles, work).
- Keep keybindings small and memorable; iterate after one week of usage.

### Phase 3: Git and diff visibility for agentic coding
- Standardize git paging with `delta` for high-signal CLI diffs.
- Use lazygit in a tmux popup as the primary interactive review surface.
- Add optional difftool strategy only if needed after baseline (avoid premature complexity).

### Phase 4: Language and toolchain installers
- Keep one script per tool for repeatability and testability.
- Add scripts for node via nvm and python via pyenv.
- Add script for dotnet setup in WSL.
- Pin versions by project type later (do not over-pin globally too early).

### Phase 5: AI tooling integration
- Validate claude code, copilot CLI, and opencode auth/config in WSL.
- Add quick command aliases for launching AI tools in current repo context.
- Add guidance for using tmux popup vs dedicated pane per task type.

### Phase 6: Cross-machine repeatability
- Add machine profile support (`personal`, `work`) with environment-specific overrides.
- Document bootstrap sequence for a fresh Windows + WSL machine.
- Add a post-bootstrap checklist so setup is testable and repeatable.

## Initial workflow decision (recommended)
- Use WezTerm tabs for coarse context switching (project/workstream).
- Use tmux sessions for project isolation.
- Use tmux panes for active coding + tests/logs.
- Use tmux popups for transient review tools: lazygit, yazi, gh-dash, AI assistants.

This keeps the main pane layout stable while still giving fast access to interactive tools.

## Immediate next steps
1. Run bootstrap and stow scripts.
2. Run `./scripts/install-tools.sh --list` and install selected tools.
3. Validate tmux popup keybinds and sesh session switching.
4. Tune WezTerm default distro/font and verify startup UX.
5. Improve installers that still rely on manual release downloads.