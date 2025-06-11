<#
.SYNOPSIS
  Install mkcert CA on an offline Windows client by fetching from your mkcert server.

.DESCRIPTION
  • Requires mkcert.exe (amd64) placed in the same folder as this script.
  • Requires OpenSSH client (scp) enabled in Windows Features.
  • Must be run as Administrator.

.PARAMETER Server
  The mkcert server to fetch from, e.g. 192.168.188.100

.PARAMETER User
  SSH username on that server, e.g. lv

.PARAMETER Hostname
  A local host name that points to local server

#>
param(
  [string] $Server = "192.168.188.100",
  [string] $User = "lv",
  [string] $Hostname = "live.longanvision.com"
)

function Assert-Admin {
  if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
  }
}

Assert-Admin

# Locate mkcert.exe next to this script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$mkcert    = Join-Path $scriptDir 'mkcert-v1.4.4-windows-amd64.exe'
if (-not (Test-Path $mkcert)) {
  Write-Error "mkcert.exe not found in ${scriptDir}. Please drop the binary here."
  exit 1
}

# Discover the CAROOT
$caroot = & $mkcert -CAROOT
Write-Host "mkcert CAROOT is: ${caroot}"

# Clear existing CA files
if (Test-Path $caroot) {
  Write-Host "Removing any existing CA files from $caroot..." -ForegroundColor Yellow
  Get-ChildItem $caroot | Remove-Item -Force
}

# Fetch the server's CA files
$remotePath = "${User}@${Server}:/home/$User/.local/share/mkcert/*"
Write-Host "Fetching CA files from $remotePath..." -ForegroundColor Cyan
# scp will prompt for password or use existing key
& scp -q $remotePath "$caroot\"
if ($LASTEXITCODE -ne 0) {
  Write-Error "scp failed (exit $LASTEXITCODE). Make sure OpenSSH client is enabled and server is reachable."
  exit 1
}

# Install (trust) the fetched CA
Write-Host "Registering the CA in Windows certificate store..." -ForegroundColor Cyan
& $mkcert -install

# add hosts file entry
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$entry     = "$Server`t$Hostname"
if (-not (Select-String -Path $hostsPath -Pattern "^\s*${Server}\s+${Hostname}(\s|$)")) {
  Write-Host "Adding host entry to $hostsPath -> $entry" -ForegroundColor Cyan
  Add-Content -Path $hostsPath -Value $entry
}

Write-Host "All done! You can now visit https://$Hostname"
