Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib/common.ps1')

Assert-CommandExists -Name 'gh' -Hint 'Install GitHub CLI first (winget package GitHub.cli).'

gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-WarnMsg 'GitHub CLI is not authenticated. Skipping extension install for now.'
    Write-Info 'Run: gh auth login'
    Write-Info 'Then run: pwsh -File .\windows\install\40-gh-extensions.ps1'
    return
}

Invoke-Safe -Label 'gh extension dlvhdr/gh-dash' -Script {
    Ensure-GhExtension -Repo 'dlvhdr/gh-dash'
}

Invoke-Safe -Label 'gh extension max-sixty/worktrunk' -Script {
    Ensure-GhExtension -Repo 'max-sixty/worktrunk'
}

Write-Ok 'GitHub extension phase complete'
