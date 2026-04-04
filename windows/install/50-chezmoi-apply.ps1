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

$needsInit = $false
if ($currentSource) {
    if (Test-Path -Path $currentSource) {
        Write-Info "chezmoi is already initialized at: $currentSource"
    }
    else {
        Write-WarnMsg "chezmoi reports source path '$currentSource' but it does not exist."
        $needsInit = $true
    }
}
else {
    $needsInit = $true
}

if ($needsInit) {
    if (-not $RepoUrl) {
        throw 'chezmoi is not initialized (or source path is missing). Re-run with -RepoUrl <your-repo-url>.'
    }

    Write-Info "Initializing chezmoi with source repo: $RepoUrl"
    chezmoi init --force $RepoUrl | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw 'chezmoi init failed. See output above.'
    }
}

if (-not $SkipApply) {
    Write-Info 'Applying chezmoi-managed dotfiles'
    chezmoi apply | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw 'chezmoi apply failed. See output above.'
    }
    Write-Ok 'chezmoi apply completed'
}
else {
    Write-Info 'Skipping apply because -SkipApply was requested'
}
