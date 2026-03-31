# Installer Framework

This directory contains dedicated installers used by `scripts/install-tools.sh`.

## Structure
- `lib/common.sh`: shared shell helpers.
- `tools/<tool>.sh`: one installer per tool.

## Usage
```bash
./scripts/install-tools.sh --list
./scripts/install-tools.sh all
./scripts/install-tools.sh gh television lazygit
```

## Notes
- Some tools are installed directly via apt.
- Some tools are installed via vendor scripts (for example, nvm and dotnet).
- Some tools still require manual release installs and currently return a non-zero status with guidance.
- Docker Desktop is treated as a Windows host prerequisite and is not part of `install-tools.sh all`.

## Current manual-fallback installers
- `scripts/install/tools/yazi.sh`
- `scripts/install/tools/television.sh`
- `scripts/install/tools/sesh.sh`
- `scripts/install/tools/worktrunk.sh`

## Host prerequisite checkers
- `scripts/install/tools/docker-desktop.sh`
