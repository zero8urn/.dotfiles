param(
    [switch]$UpgradeInstalled
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

# Tools with verified and current winget packages from the setup plan audit.
$coreWingetPackages = @(
    'ajeetdsouza.zoxide',
    'junegunn.fzf',
    'twpayne.chezmoi',
    'JesseDuffield.lazygit',
    'sxyazi.yazi',
    'alexpasmantier.television',
    'BurntSushi.ripgrep.MSVC',
    'jqlang.jq',
    'GitHub.cli',
    'GitHub.Copilot'
)

Write-Info 'Installing package-manager-first tools with winget'

foreach ($packageId in $coreWingetPackages) {
    Invoke-Safe -Label "winget package $packageId" -Script {
        Ensure-WingetPackage -Id $packageId -AllowUpgrade:$UpgradeInstalled
    }
}

Write-Ok 'Core winget install phase complete'
