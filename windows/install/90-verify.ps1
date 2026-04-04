Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

$checks = @(
    @{ Name = 'winget'; Args = '--version' },
    @{ Name = 'git'; Args = '--version' },
    @{ Name = 'chezmoi'; Args = '--version' },
    @{ Name = 'zoxide'; Args = '--version' },
    @{ Name = 'fzf'; Args = '--version' },
    @{ Name = 'lazygit'; Args = '--version' },
    @{ Name = 'yazi'; Args = '--version' },
    @{ Name = 'tv'; Args = '--version' },
    @{ Name = 'rg'; Args = '--version' },
    @{ Name = 'jq'; Args = '--version' },
    @{ Name = 'gh'; Args = '--version' },
    @{ Name = 'dotnet'; Args = '--version' },
    @{ Name = 'go'; Args = 'version' },
    @{ Name = 'uv'; Args = '--version' },
    @{ Name = 'tmuxp'; Args = '--version' },
    @{ Name = 'python'; Args = '--version' },
    @{ Name = 'node'; Args = '--version' },
    @{ Name = 'npm'; Args = '--version' },
    @{ Name = 'docker'; Args = '--version' },
    @{ Name = 'psmux'; Args = '--version' },
    @{ Name = 'sesh'; Args = '--version' },
    @{ Name = 'opencode'; Args = '--version' }
)

$fallbackExecutables = @{
    go = Join-Path $env:ProgramFiles 'Go\bin\go.exe'
    sesh = Join-Path $env:USERPROFILE 'go\bin\sesh.exe'
}

$missing = @()

foreach ($check in $checks) {
    $name = $check.Name
    $commandToRun = $name

    if (-not (Test-CommandExists -Name $name)) {
        if ($fallbackExecutables.ContainsKey($name) -and (Test-Path -Path $fallbackExecutables[$name])) {
            $commandToRun = $fallbackExecutables[$name]
            Write-WarnMsg "$name is not on PATH; using fallback executable: $commandToRun"
        }
        else {
            Write-WarnMsg "$name is missing"
            $missing += $name
            continue
        }
    }

    Write-Info "Verifying $name"
    & $commandToRun $check.Args | Select-Object -First 1 | Out-Host
    if ($LASTEXITCODE -ne 0) {
        Write-WarnMsg "$name command failed"
        $missing += $name
    }
}

if ($missing.Count -gt 0) {
    Write-WarnMsg ('Missing tools: ' + ($missing -join ', '))
    throw 'One or more tools are missing. Review earlier install phases.'
}

Write-Ok 'Verification phase complete'
