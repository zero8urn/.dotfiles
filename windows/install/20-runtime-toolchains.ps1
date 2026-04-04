param(
    [string]$DotNetPackageId = 'Microsoft.DotNet.SDK.10',
    [string]$NodeVersion = 'lts'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

Write-Info 'Installing runtime toolchains'

Invoke-Safe -Label "winget package $DotNetPackageId" -Script {
    Ensure-WingetPackage -Id $DotNetPackageId -AllowUpgrade
}

Invoke-Safe -Label 'winget package astral-sh.uv' -Script {
    Ensure-WingetPackage -Id 'astral-sh.uv' -AllowUpgrade
}

Invoke-Safe -Label 'winget package GoLang.Go' -Script {
    Ensure-WingetPackage -Id 'GoLang.Go' -AllowUpgrade
}

$goExecutable = $null
if (Test-CommandExists -Name 'go') {
    $goExecutable = 'go'
}
else {
    $goFallback = Join-Path $env:ProgramFiles 'Go\bin\go.exe'
    if (Test-Path -Path $goFallback) {
        $goExecutable = $goFallback
    }
}

if ($goExecutable) {
    Write-Info 'Installing sesh via Go: github.com/joshmedeski/sesh/v2@latest'
    & $goExecutable install github.com/joshmedeski/sesh/v2@latest | Out-Host

    $goUserBin = Join-Path $env:USERPROFILE 'go\bin'
    $seshExe = Join-Path $goUserBin 'sesh.exe'
    if (Test-Path -Path $seshExe) {
        Write-Ok "sesh installed to: $seshExe"
    }
    else {
        Write-WarnMsg 'sesh install completed but sesh.exe was not found in %USERPROFILE%\\go\\bin yet.'
    }
}
else {
    Write-WarnMsg 'Go was installed but go executable is not available in this shell yet. Re-open shell and run: go install github.com/joshmedeski/sesh/v2@latest'
}

Invoke-Safe -Label 'winget package Docker.DockerDesktop' -Script {
    Ensure-WingetPackage -Id 'Docker.DockerDesktop' -AllowUpgrade
}

if (Test-CommandExists -Name 'nvm') {
    Write-Info "Installing Node via nvm-windows: $NodeVersion"
    nvm install $NodeVersion | Out-Host
    nvm use $NodeVersion | Out-Host
    Write-Ok 'Node configured via nvm-windows'
}
else {
    Write-WarnMsg 'nvm was not found. Run 30-custom-installers.ps1 to install nvm-windows first.'
}

if (Test-CommandExists -Name 'uv') {
    Write-Info 'Installing Python runtime via uv'
    uv python install 3.12 | Out-Host

    Write-Info 'Installing tmuxp via uv tool install'
    uv tool install tmuxp | Out-Host
    Write-Ok 'Python installed via uv'
}
else {
    Write-WarnMsg 'uv was not found after install. Open a new shell and rerun this script.'
}

Write-Ok 'Runtime toolchain phase complete'
