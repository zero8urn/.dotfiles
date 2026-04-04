
# Setting up .dotfiles for Windows

For tmux support on Windows, use psmux:
- https://github.com/psmux/psmux

Tmux has 3 layers:
- Panes: instances of terminals
- Windows: collections of panes
- Sessions: collections of windows

Example workflow:
- Session: UI
  - Window: qa-proxy
    - Pane 1: ssl-proxy
    - Pane 2: watcher
  - Window: code
    - Pane 1: Claude Code
    - Pane 2: terminal

## Goals
- Prefer `winget` for install and upgrade when packages are current.
- If `winget` is missing or package is stale, use an official fallback installer.
- Keep Windows-specific setup isolated under `windows/home` and `windows/install`.
- Use `chezmoi` as the dotfiles source of truth.

## Prerequisites
- Windows 11 (or Windows 10 with modern PowerShell and winget support)
- PowerShell 7+
- Windows Terminal (recommended)
- Git for Windows
- Administrator shell for installs that require elevation
- A GitHub account/token for `gh auth login` and private repos

## Consolidated TODO
- [ ] [Validate base prerequisites](#validate-base-prerequisites)
- [x] [Create Windows installer script layout](#create-windows-installer-script-layout)
- [ ] [Install package-manager-first tools](#install-package-manager-first-tools)
- [ ] [Install runtimes and language toolchains](#install-runtimes-and-language-toolchains)
- [ ] [Install tools that require custom installers](#install-tools-that-require-custom-installers)
- [ ] [Install GitHub CLI extensions and related tools](#install-github-cli-extensions-and-related-tools)
- [x] [Initialize and apply chezmoi dotfiles](#initialize-and-apply-chezmoi-dotfiles)
- [x] [Bootstrap PowerShell dev profile](#bootstrap-powershell-dev-profile)
- [x] [Wire shell profile and PATH](#wire-shell-profile-and-path)
- [ ] [Validate toolchain end-to-end](#validate-toolchain-end-to-end)

## Implementation status (2026-04-04)
- Added script scaffold under `windows/install`:
  - `windows/install/00-prereqs.ps1`
  - `windows/install/10-winget-core.ps1`
  - `windows/install/20-runtime-toolchains.ps1`
  - `windows/install/30-custom-installers.ps1`
  - `windows/install/40-gh-extensions.ps1`
  - `windows/install/50-chezmoi-apply.ps1`
  - `windows/install/60-bootstrap-profile.ps1`
  - `windows/install/90-verify.ps1`
  - `windows/install/lib/common.ps1`
  - `windows/install/README.md`
- Added PowerShell dev profile template:
  - `windows/home/posh/dev.profile.ps1`
- Scripts are authored with idempotent checks and exact winget IDs where validated.
- Execution and Windows-host validation are still pending.

## Validate base prerequisites
- Confirm `winget`, `pwsh`, and `git` exist.
- If `winget` is not present, install App Installer from Microsoft Store first.
- Confirm you can run an elevated PowerShell session.

## Create Windows installer script layout
Recommended script structure:
- `windows/install/00-prereqs.ps1`
- `windows/install/10-winget-core.ps1`
- `windows/install/20-runtime-toolchains.ps1`
- `windows/install/30-custom-installers.ps1`
- `windows/install/40-gh-extensions.ps1`
- `windows/install/90-verify.ps1`

Guidelines:
- Keep one script per install strategy category.
- Use idempotent checks (`Get-Command`, existing install paths, version checks).
- Use `winget install -e --id <ID>` and `winget upgrade --id <ID>` where available.

## Install strategy and tool matrix

| Tool | Type | Preferred install choice | Winget package / command | Fallback if winget unavailable or outdated | Prerequisites / notes |
|---|---|---|---|---|---|
| zoxide | CLI | winget | `ajeetdsouza.zoxide` | Scoop/Chocolatey or GitHub release binary | Add init hook in PowerShell profile |
| fzf | CLI | winget | `junegunn.fzf` | GitHub release binary | Confirm shell keybindings in profile |
| psmux | CLI | custom install (do not trust name-only winget hit) | `winget search --exact psmux` (manual verify required) | GitHub release zip or Scoop/Chocolatey from official docs | Be careful: `psmux.TerminalMap` exists in winget and is unrelated to tmux binary |
| tmuxp | Python package | `uv tool install` (or `pipx`) | n/a | `pip install tmuxp` in managed env | Requires Python/uv first |
| sesh | CLI | Go install | `winget search --exact sesh` (expected no result) | GitHub release binary (`joshmedeski/sesh`) | Install with `go install github.com/joshmedeski/sesh/v2@latest`; ensure Go bin is on user PATH |
| chezmoi | CLI | winget | `twpayne.chezmoi` | Official one-liner install script | Bootstrap and apply dotfiles |
| lazygit | CLI | winget | `JesseDuffield.lazygit` | GitHub release binary | Optional terminal UI for git |
| yazi | CLI | winget | `sxyazi.yazi` | GitHub release binary | May need file association tweaks |
| television | CLI | winget | `alexpasmantier.television` | GitHub release binary | Verify publisher is `alexpasmantier` (official) |
| ripgrep | CLI | winget | `BurntSushi.ripgrep.MSVC` | Scoop/Chocolatey or release zip | Used by search workflows |
| jq | CLI | winget | `jqlang.jq` | Release binary | JSON scripting utility |
| GitHub CLI (`gh`) | CLI | winget | `GitHub.cli` | Official MSI installer | Run `gh auth login` after install |
| gh-dash | gh extension | `gh extension install` | `gh extension install dlvhdr/gh-dash` | Build from source in Go env | Requires `gh` first |
| worktrunk | gh extension | `gh extension install` | `gh extension install max-sixty/worktrunk` | Build from source/manual install | Requires `gh` first |
| Copilot CLI | CLI | winget | `GitHub.Copilot` | `npm install -g @github/copilot` | Official docs explicitly provide winget + npm install paths |
| opencode | CLI | custom install | `winget search --exact opencode` (expected no official result) | `npm i -g opencode-ai@latest` or official install script | Official docs provide install script/npm/scoop/choco, not winget |
| .NET SDK | Runtime | winget | `Microsoft.DotNet.SDK.10` (or latest LTS) | `dotnet-install.ps1` from install-scripts repo | Pin LTS major in script |
| nvm-windows | Runtime manager | official installer | Use installer from `coreybutler/nvm-windows` releases | Manual install from official release EXE | Use official method for this setup; install Node via `nvm install <version>` |
| Node.js/npm | Runtime | via nvm-windows | `nvm install lts` then `nvm use lts` | Direct Node installer (less preferred) | Prefer nvm for version management |
| uv | Runtime/tool manager | winget | `astral-sh.uv` | Official install script | Use for Python + tools |
| Python | Runtime | via uv | `uv python install <version>` | python.org installer | Keep global Python minimal |
| Go | Runtime | winget | `GoLang.Go` | Official MSI | Set `GOPATH` only if needed |
| Docker Desktop | Container runtime | manual or winget | `Docker.DockerDesktop` | Manual GUI installer | Requires virtualization + WSL2 features |

## Install package-manager-first tools
- Install all tools with stable `winget` packages first.
- Record package IDs in `windows/install/10-winget-core.ps1`.
- Add retry logic and non-zero exit handling.

## Winget verification audit (2026-04-04)

Validation method used:
- Parsed each tool's official GitHub install documentation to confirm whether winget is officially mentioned.
- Attempted `winget search` locally, but this Linux environment does not have `winget` (`command not found`).
- Used `microsoft/winget-pkgs` manifest paths as a source-of-truth proxy for package presence/version, then compared to latest upstream release tags.

| Tool | Official docs mention winget? | `winget search` result intent | Package ID / source found | Winget package version seen | Latest upstream release | Status | Third-party risk | Concrete install plan |
|---|---|---|---|---|---|---|---|---|
| psmux | Yes (`winget install psmux`) | `winget search --exact psmux` | No official `psmux` package confirmed in checked winget manifests; only `psmux.TerminalMap` found | `psmux.TerminalMap` at `0.1.0` (unrelated package) | `psmux/psmux` latest `v3.3.1` | Treat as not reliably available via official winget package ID | High if selecting by name only | Install from `https://github.com/psmux/psmux/releases` (zip) and add to PATH; optionally use Scoop/Chocolatey route from official docs |
| sesh | No | `winget search --exact sesh` | No manifest found in checked partitions | n/a | `joshmedeski/sesh` latest `v2.24.2` | Not available via winget in this audit | Medium (name collisions possible) | Primary: `go install github.com/joshmedeski/sesh/v2@latest`; fallback: GitHub release binary in user PATH |
| television | Yes (`winget install --exact --id alexpasmantier.television`) | `winget search --exact alexpasmantier.television` | `alexpasmantier.television` | `0.15.4` | `alexpasmantier/television` latest `0.15.4` | Up to date | Low (publisher matches upstream) | Keep winget as primary; fallback to GitHub release binary |
| Copilot CLI | Yes (`winget install GitHub.Copilot`) | `winget search --exact GitHub.Copilot` | `GitHub.Copilot` | `v1.0.18` manifest directory present | `github/copilot-cli` latest `v1.0.18` | Up to date | Low (official GitHub publisher ID) | Keep winget as primary; fallback to `npm install -g @github/copilot` |
| opencode | No | `winget search --exact opencode` | No official manifest found in checked partitions | n/a | `anomalyco/opencode` latest `v1.3.13` | Not available via winget in this audit | Medium (unofficial packages may appear later) | Primary: `npm i -g opencode-ai@latest` or `curl -fsSL https://opencode.ai/install | bash`; Windows fallback: Scoop/Chocolatey from official README |

Notes:
- Re-run `winget search --exact <id>` directly on Windows before finalizing scripts.
- Prefer exact IDs and verified publishers over name-only searches.

## Install runtimes and language toolchains
- Install: .NET SDK, nvm-windows, uv, Go, Docker Desktop.
- Install nvm-windows using the official installer from `coreybutler/nvm-windows` releases (not winget for this plan).
- Install Node/npm through nvm-windows, not direct Node MSI.
- Install Python through uv where possible.

## Install tools that require custom installers
- Put each non-winget/custom flow in `windows/install/30-custom-installers.ps1`.
- For every manual step, add an explicit comment and URL in script output.
- For `sesh` on Windows, use Go as primary install method:
  - `go install github.com/joshmedeski/sesh/v2@latest`
  - Verify `sesh --version`

## Install GitHub CLI extensions and related tools
- Install `gh` first, then run:
  - `gh extension install dlvhdr/gh-dash`
  - `gh extension install max-sixty/worktrunk`
- Authenticate with `gh auth login` before extension install if required.

## Initialize and apply chezmoi dotfiles
- `chezmoi init <your-repo>`
- `chezmoi apply`
- Keep Windows-specific config in `windows/home` and Windows scripts in `windows/install`.

## Bootstrap PowerShell dev profile
- Use a PowerShell-first profile model for Windows setup.
- Add repo-managed profile content at `windows/home/posh/dev.profile.ps1`.
- During apply/bootstrap, copy or symlink that file to `$HOME\dev.profile.ps1`.
- Ensure `$PROFILE` includes an idempotent bootstrap block that dot-sources `$HOME\dev.profile.ps1` if the file exists.
- Add the loader block to `$PROFILE` only if it is not already present.
- Keep all PATH edits and shell init logic in `dev.profile.ps1`, leaving `$PROFILE` as a thin loader.
- Validation:
  - Start a new PowerShell tab and confirm loader runs without errors.
  - Confirm expected PATH additions and tool commands are available.

Suggested bootstrap (append only if missing):

```powershell
if (!(Test-Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$loaderBlock = @'
# dotfiles dev profile loader
$devProfile = Join-Path $HOME 'dev.profile.ps1'
if (Test-Path $devProfile -and -not $script:DotfilesDevProfileLoaded) {
  . $devProfile
  $script:DotfilesDevProfileLoaded = $true
}
'@

if (-not (Select-String -Path $PROFILE -SimpleMatch 'DotfilesDevProfileLoaded' -Quiet)) {
  Add-Content -Path $PROFILE -Value "`r`n$loaderBlock"
}
```

Notes:
- Symlinks are valid for PowerShell profile sourcing. Dot-sourcing a symlinked `dev.profile.ps1` works.
- If symlink creation is restricted on a machine, copy the file instead.
- Under `RemoteSigned`, locally created/copied profile files are typically allowed. If blocked, review execution policy and file origin metadata.

## Wire shell profile and PATH
- Update PowerShell profile to initialize: zoxide, fzf bindings, and any tool shims.
- Manage PATH in `dev.profile.ps1` only for now (PowerShell-first approach).
- Add PATH entries idempotently in `dev.profile.ps1` for winget, nvm, uv tools, Go binaries, and custom binaries.
- Keep `$PROFILE` limited to loading `dev.profile.ps1`; do not duplicate PATH logic in `$PROFILE`.

## Validate toolchain end-to-end
- Validate versions with one command per tool (`--version` or equivalent).
- Validate workflows:
  - psmux session/window/pane creation
  - gh auth and extension commands
  - nvm-managed Node/npm
  - uv-managed Python tooling
  - chezmoi apply and diff

## Notes
- Always verify package freshness before locking package IDs into scripts.
- If a package is missing or stale on winget, prefer official installer or project-supported install method.
  