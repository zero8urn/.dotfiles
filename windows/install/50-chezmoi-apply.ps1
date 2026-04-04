param(
    [string]$RepoUrl,
    [switch]$SkipApply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

Assert-CommandExists -Name 'chezmoi' -Hint 'Install chezmoi first (winget package twpayne.chezmoi).'

$currentSource = $null
$currentSourceRaw = chezmoi source-path 2>$null
if ($LASTEXITCODE -eq 0 -and $currentSourceRaw) {
    $currentSource = ($currentSourceRaw | Select-Object -First 1).Trim()
}

if ($currentSource) {
    Write-Info "chezmoi is already initialized at: $currentSource"
}
else {
    if (-not $RepoUrl) {
        throw 'chezmoi is not initialized. Re-run with -RepoUrl <your-repo-url>.'
    }

    Write-Info "Initializing chezmoi with source repo: $RepoUrl"
    chezmoi init $RepoUrl | Out-Host
}

if (-not $SkipApply) {
    Write-Info 'Applying chezmoi-managed dotfiles'
    chezmoi apply | Out-Host
    Write-Ok 'chezmoi apply completed'
}
else {
    Write-Info 'Skipping apply because -SkipApply was requested'
}
