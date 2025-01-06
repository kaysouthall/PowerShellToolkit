# Define the output directory for the RDP files
$outputDir = "C:\Temp"

# Ensure the output directory exists
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Prompt for machine name
$machineName = Read-Host "Enter the machine name (e.g., Server-Room-04)"

# Prompt for domain name to append to the machine name
$machineDomain = Read-Host "Enter the domain name to append to the machine name (e.g., reynholm.local)"

# Prompt for username
$username = Read-Host "Enter the username (e.g., moss)"

# Prompt for domain name to prepend to the username
$userDomain = Read-Host "Enter the user domain (e.g., REYNHOLM)"

# Construct the full connection address and username
$fullAddress = "$machineName.$machineDomain"
$fullUsername = "$userDomain\$username"

# Construct the RDP file name
$rdpFileName = "$username" + "RemoteTo" + "$userDomain.rdp"
$rdpFilePath = Join-Path -Path $outputDir -ChildPath $rdpFileName

# Create the content of the RDP file
$rdpContent = @"
screen mode id:i:2
use multimon:i:1
desktopwidth:i:0
desktopheight:i:0
session bpp:i:32
winposstr:s:0,3,0,0,800,600
full address:s:$fullAddress
prompt for credentials on client:i:1
username:s:$fullUsername
authentication level:i:2
enablecredsspsupport:i:1
redirectclipboard:i:1
redirectprinters:i:1
redirectcomports:i:0
redirectsmartcards:i:1
redirectdrives:i:0
redirectposdevices:i:0
autoreconnection enabled:i:1
bitmapcachepersistenable:i:1
audiomode:i:0
audioqualitymode:i:0
allow desktop composition:i:0
allow font smoothing:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
disable cursor setting:i:0
connect to console:i:0
drivestoredirect:s:
"@

# Write the RDP file to the specified output directory
Set-Content -Path $rdpFilePath -Value $rdpContent

# Output a success message
Write-Host "RDP shortcut created successfully at: $rdpFilePath" -ForegroundColor Green
