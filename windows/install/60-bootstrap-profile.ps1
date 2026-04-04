Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

# dev.profile.ps1 is placed by chezmoi apply (50-chezmoi-apply.ps1).
# This script only wires the loader block into $PROFILE.

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
