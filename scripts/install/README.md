# Installer Framework

This directory contains dedicated installers used by `scripts/install-tools.sh`.

## Structure
- `lib/common.sh`: shared shell helpers.
- `tools/<tool>.sh`: one installer per tool.

## Usage
```bash
./scripts/install-tools.sh --list
./scripts/install-tools.sh all
./scripts/install-tools.sh gh television lazygit go
```

## Notes
- Some tools are installed directly via apt.
- Some tools are installed via vendor scripts (for example, nvm and dotnet).
- Some tools use layered install fallbacks (apt, vendor scripts, Homebrew, or release binaries).
- `sesh` is installed via `go install` and depends on the `go` installer.
- Docker Desktop is treated as a Windows host prerequisite and is not part of `install-tools.sh all`.

## Layered-fallback installers
- `scripts/install/tools/lazygit.sh`
- `scripts/install/tools/yazi.sh`
- `scripts/install/tools/television.sh`
- `scripts/install/tools/worktrunk.sh`
- `scripts/install/tools/homebrew.sh`

## Runtime installers
- `scripts/install/tools/go.sh`

## Host prerequisite checkers
- `scripts/install/tools/docker-desktop.sh`
