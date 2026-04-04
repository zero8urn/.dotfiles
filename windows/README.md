# Windows Setup

Run from an elevated PowerShell 7 terminal. See `docs/plan/windows-dotfiles-setup.md` for
the detailed planning reference and tool matrix.

## Run order

```powershell
pwsh -File .\windows\install\00-prereqs.ps1 -RequireAdmin
pwsh -File .\windows\install\10-winget-core.ps1 -UpgradeInstalled
pwsh -File .\windows\install\20-runtime-toolchains.ps1
pwsh -File .\windows\install\30-custom-installers.ps1
pwsh -File .\windows\install\50-chezmoi-apply.ps1 -RepoUrl https://github.com/zero8urn/.dotfiles.git
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

- Run in a PowerShell tab directly (not `pwsh` launched inside Git Bash) for cleaner native tool output.
- If execution policy blocks local scripts, run this in the current terminal session first:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy ByPass
```

## Keeping dotfiles in sync

`chezmoi apply` (step 50) copies managed files to `~` — it does not symlink. Edit files in
`windows/chezmoi/` in the repo, commit, then apply.

`chezmoi` commands can be run from **any directory** — chezmoi operates on its internal source
at `~/.local/share/chezmoi`, not your working directory. The only exception is the initial
install script (`50-chezmoi-apply.ps1`), which uses a relative path and must be run from the
repo root.

| Situation | Command |
|---|---|
| First-time setup | `pwsh -File .\windows\install\50-chezmoi-apply.ps1 -RepoUrl <url>` |
| You changed a file in the repo | `chezmoi apply` |
| Pull latest repo changes and apply | `chezmoi update` |
| Check for drift before applying | `chezmoi diff` |
| You edited a target file directly, want to sync back | `chezmoi re-add` |

---

## PowerShell profile UTF-8 setup

Some native installers emit UTF-8 progress characters. Set UTF-8 in your PowerShell profile to
avoid garbled output.

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
