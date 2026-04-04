param(
    [switch]$RequireAdmin
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

Write-Info 'Validating base prerequisites for Windows dotfiles setup'

Assert-CommandExists -Name 'pwsh' -Hint 'Install PowerShell 7+ first.'
Write-Ok 'PowerShell is available'

Assert-CommandExists -Name 'git' -Hint 'Install Git for Windows first.'
Write-Ok 'Git is available'

if (Test-CommandExists -Name 'winget') {
    Write-Ok 'winget is available'
}
else {
    Write-WarnMsg 'winget was not found. Install App Installer from Microsoft Store.'
    throw 'winget is required for package-manager-first installs in this setup.'
}

$isAdmin = Test-IsAdministrator
if ($RequireAdmin -and -not $isAdmin) {
    throw 'This script requires an elevated PowerShell session. Re-run as Administrator.'
}

if ($isAdmin) {
    Write-Ok 'Running in elevated session'
}
else {
    Write-WarnMsg 'Not running as Administrator. Some installs may fail if elevation is required.'
}

Write-Ok 'Prerequisite validation complete'
