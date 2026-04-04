Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[ OK ] $Message" -ForegroundColor Green
}

function Write-WarnMsg {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-ErrMsg {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[ERR ] $Message" -ForegroundColor Red
}

function Test-CommandExists {
    param([Parameter(Mandatory = $true)][string]$Name)
    return [bool](Get-Command -Name $Name -ErrorAction SilentlyContinue)
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-CommandExists {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$Hint = ''
    )

    if (-not (Test-CommandExists -Name $Name)) {
        $message = "Required command '$Name' was not found."
        if ($Hint) {
            $message = "$message $Hint"
        }
        throw $message
    }
}

function Invoke-Safe {
    param(
        [Parameter(Mandatory = $true)][string]$Label,
        [Parameter(Mandatory = $true)][scriptblock]$Script
    )

    try {
        & $Script
        Write-Ok "$Label completed"
    }
    catch {
        Write-ErrMsg "$Label failed: $($_.Exception.Message)"
        throw
    }
}

function Ensure-WingetPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Id,
        [switch]$AllowUpgrade
    )

    Assert-CommandExists -Name 'winget' -Hint 'Install App Installer from Microsoft Store first.'

    $listOutput = winget list --exact --id $Id --accept-source-agreements 2>&1
    if ($LASTEXITCODE -eq 0 -and ($listOutput -join "`n") -match [Regex]::Escape($Id)) {
        Write-Info "Package already installed: $Id"
        if ($AllowUpgrade) {
            Write-Info "Upgrading package when updates are available: $Id"
            winget upgrade --exact --id $Id --accept-package-agreements --accept-source-agreements | Out-Host
        }
        return
    }

    Write-Info "Installing package: $Id"
    winget install --exact --id $Id --accept-package-agreements --accept-source-agreements | Out-Host
}

function Ensure-GhExtension {
    param([Parameter(Mandatory = $true)][string]$Repo)

    Assert-CommandExists -Name 'gh' -Hint 'Install GitHub CLI first.'

    $extensions = gh extension list 2>$null
    if ($LASTEXITCODE -eq 0 -and ($extensions -join "`n") -match [Regex]::Escape($Repo)) {
        Write-Info "GitHub CLI extension already installed: $Repo"
        return
    }

    Write-Info "Installing GitHub CLI extension: $Repo"
    gh extension install $Repo | Out-Host
}

function Get-RepoRoot {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    return (Resolve-Path (Join-Path $scriptPath '..')).Path
}

function Install-FromZipRelease {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$DownloadUrl,
        [Parameter(Mandatory = $true)][string]$ExecutableRelativePath,
        [Parameter(Mandatory = $true)][string]$DestinationDirectory
    )

    if (-not (Test-Path -Path $DestinationDirectory)) {
        New-Item -ItemType Directory -Path $DestinationDirectory -Force | Out-Null
    }

    $tempZip = Join-Path $env:TEMP "$Name.zip"
    $tempExtract = Join-Path $env:TEMP "$Name-extract"

    if (Test-Path -Path $tempExtract) {
        Remove-Item -Path $tempExtract -Recurse -Force
    }

    Write-Info "Downloading $Name from $DownloadUrl"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $tempZip
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    $sourceExecutable = Join-Path $tempExtract $ExecutableRelativePath
    if (-not (Test-Path -Path $sourceExecutable)) {
        throw "Expected executable was not found after extraction: $sourceExecutable"
    }

    Copy-Item -Path $sourceExecutable -Destination (Join-Path $DestinationDirectory ([IO.Path]::GetFileName($sourceExecutable))) -Force
    Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

    Write-Ok "$Name installed to $DestinationDirectory"
}
