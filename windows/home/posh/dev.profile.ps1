# dotfiles Windows dev profile

function Add-PathEntry {
    param([Parameter(Mandatory = $true)][string]$Entry)

    if (-not (Test-Path -Path $Entry)) {
        return
    }

    $parts = @($env:PATH -split ';' | Where-Object { $_ -and $_.Trim() })
    if ($parts -notcontains $Entry) {
        $env:PATH = "$Entry;$env:PATH"
    }
}

Add-PathEntry -Entry (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links')
Add-PathEntry -Entry (Join-Path $env:USERPROFILE '.local\bin')
Add-PathEntry -Entry (Join-Path $env:USERPROFILE 'go\bin')
Add-PathEntry -Entry (Join-Path $env:USERPROFILE 'tools')
Add-PathEntry -Entry (Join-Path $env:APPDATA 'nvm')
Add-PathEntry -Entry (Join-Path $env:ProgramFiles 'nodejs')

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { zoxide init powershell | Out-String })
}

if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf -ErrorAction SilentlyContinue
}
