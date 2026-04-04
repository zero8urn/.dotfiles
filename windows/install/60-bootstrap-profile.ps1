param(
    [switch]$UseSymlink
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$managedProfile = Join-Path $repoRoot 'windows\home\posh\dev.profile.ps1'
$targetDevProfile = Join-Path $HOME 'dev.profile.ps1'

if (-not (Test-Path -Path $managedProfile)) {
    throw "Managed profile file not found: $managedProfile"
}

if ($UseSymlink) {
    if (Test-Path -Path $targetDevProfile) {
        Remove-Item -Path $targetDevProfile -Force
    }

    try {
        New-Item -ItemType SymbolicLink -Path $targetDevProfile -Target $managedProfile -Force | Out-Null
        Write-Ok "Created symlink: $targetDevProfile -> $managedProfile"
    }
    catch {
        Write-WarnMsg 'Symlink creation failed; falling back to copy mode. Re-run elevated if you need symlinks.'
        Copy-Item -Path $managedProfile -Destination $targetDevProfile -Force
        Write-Ok "Copied managed profile to: $targetDevProfile"
    }
}
else {
    Copy-Item -Path $managedProfile -Destination $targetDevProfile -Force
    Write-Ok "Copied managed profile to: $targetDevProfile"
}

if (-not (Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$brokenLoaderLine = "if (Test-Path `$devProfile -and -not `$script:DotfilesDevProfileLoaded) {"
$fixedLoaderLine = "if ((Test-Path `$devProfile) -and -not `$script:DotfilesDevProfileLoaded) {"
if (Select-String -Path $PROFILE -SimpleMatch $brokenLoaderLine -Quiet) {
        $profileRaw = Get-Content -Path $PROFILE -Raw
        $profileRaw = $profileRaw.Replace($brokenLoaderLine, $fixedLoaderLine)
        Set-Content -Path $PROFILE -Value $profileRaw
        Write-Ok "Repaired invalid loader condition in: $PROFILE"
}

$loaderBlock = @'
# dotfiles dev profile loader
$devProfile = Join-Path $HOME 'dev.profile.ps1'
if ((Test-Path $devProfile) -and -not $script:DotfilesDevProfileLoaded) {
  . $devProfile
  $script:DotfilesDevProfileLoaded = $true
}
'@

if (-not (Select-String -Path $PROFILE -SimpleMatch 'DotfilesDevProfileLoaded' -Quiet)) {
    Add-Content -Path $PROFILE -Value "`r`n$loaderBlock"
    Write-Ok "Appended dev profile loader block to: $PROFILE"
}
else {
    Write-Info "Dev profile loader block already present in: $PROFILE"
}
