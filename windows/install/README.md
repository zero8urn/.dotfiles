# Windows install scripts

These scripts implement the phased setup in `docs/plan/windows-dotfiles-setup.md`.

## Run order

Run from an elevated PowerShell prompt unless noted otherwise:

```powershell
pwsh -File .\windows\install\00-prereqs.ps1 -RequireAdmin
pwsh -File .\windows\install\10-winget-core.ps1 -UpgradeInstalled
pwsh -File .\windows\install\30-custom-installers.ps1
pwsh -File .\windows\install\20-runtime-toolchains.ps1
pwsh -File .\windows\install\50-chezmoi-apply.ps1 -RepoUrl <your-repo-url>
pwsh -File .\windows\install\60-bootstrap-profile.ps1
pwsh -File .\windows\install\90-verify.ps1
```

## Post-install

Run after authenticating GitHub CLI:

```powershell
gh auth login
pwsh -File .\windows\install\40-gh-extensions.ps1
```

## Notes

- `10-winget-core.ps1` only handles tools with vetted winget package IDs.
- `30-custom-installers.ps1` covers non-winget tooling and official installer fallbacks.
- `20-runtime-toolchains.ps1` installs Go-managed tools (including sesh) and expects `nvm` to be available if Node install is desired.
- `40-gh-extensions.ps1` is intended for post-install use after `gh auth login`.
- `50-chezmoi-apply.ps1` initializes and applies chezmoi from your dotfiles source.
- `60-bootstrap-profile.ps1` links/copies `windows/home/posh/dev.profile.ps1` to `$HOME\dev.profile.ps1` and appends a thin loader to `$PROFILE`.
