param(
    [string]$ToolsDir = "$env:USERPROFILE\\tools",
    [string]$NvmVersion = '1.2.2'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

Write-Info 'Installing tools that require custom installers or non-winget methods'

if (-not (Test-Path -Path $ToolsDir)) {
    New-Item -ItemType Directory -Path $ToolsDir -Force | Out-Null
}

if (-not (Test-CommandExists -Name 'nvm')) {
    $nvmUrl = "https://github.com/coreybutler/nvm-windows/releases/download/$NvmVersion/nvm-setup.exe"
    $nvmSetup = Join-Path $env:TEMP 'nvm-setup.exe'

    Write-WarnMsg "Installing nvm-windows from official release: $nvmUrl"
    Invoke-WebRequest -Uri $nvmUrl -OutFile $nvmSetup
    Start-Process -FilePath $nvmSetup -Wait
    Remove-Item -Path $nvmSetup -Force -ErrorAction SilentlyContinue
    Write-WarnMsg 'nvm-windows installer finished. You may need to open a new shell before nvm is available.'
}
else {
    Write-Info 'nvm-windows already installed'
}

if (-not (Test-CommandExists -Name 'psmux')) {
    Write-WarnMsg 'psmux is not installed. Install from official releases: https://github.com/psmux/psmux/releases'
}
else {
    Write-Info 'psmux already installed'
}

Write-Info 'sesh installation is handled in 20-runtime-toolchains.ps1 after Go install.'

if (-not (Test-CommandExists -Name 'opencode')) {
    if (Test-CommandExists -Name 'npm') {
        Write-Info 'Installing opencode via npm'
        npm i -g opencode-ai@latest | Out-Host
    }
    else {
        Write-WarnMsg 'npm not found. Install Node via nvm first, then run: npm i -g opencode-ai@latest'
    }
}
else {
    Write-Info 'opencode already installed'
}

Write-Ok 'Custom installer phase complete'
