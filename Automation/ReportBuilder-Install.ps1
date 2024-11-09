# ReportBuilder-Install.ps1
#
# Author: Kayla Southall   
# Created: 2024-10-29
# Last Modified: 2024-10-29
# Version: 1.0.0
# 
# Description:
#   This script automates the download and installation of the Microsoft Report Builder application.
#   It handles downloading the installer, executing the installation with specified arguments,
#   and cleaning up temporary files post-installation.
#
# Parameters:
#   -Verbose: Switch to enable verbose output.  Provides detailed execution information.
#
#   -TempDir <string>
#       Specifies the directory for temporary files.
#       Default: "C:\Temp"
#
#   -InstallArgs <string>
#       Arguments to pass to the installer for silent installation.
#       Default: "/norestart /qn"
#
#   -DownloadUrl <string>
#       URL to download the installer from.
#       Default: "https://dxt.dev/ReportBuilder"
#
# Usage:
#   .\LGN-ReportBuilder-Install.ps1
#   .\LGN-ReportBuilder-Install.ps1 -Verbose
#   .\LGN-ReportBuilder-Install.ps1 -TempDir "D:\CustomTemp"

# Set the defaults
[CmdletBinding()]
param (
    [string]$TempDir = "C:\Temp",
    [string]$InstallArgs = "/norestart /qn",
    [string]$DownloadUrl = "https://dxt.dev/ReportBuilder"
)

# Get and store the current ProgressPreference setting
$OGProgressPreference = $ProgressPreference

# Make downloads go fast by supressing progress bars
$ProgressPreference = 'SilentlyContinue'

#DK Debug Option
#$VerbosePreference = "continue"

# Function: Get-Installer
# Author: Kayla Southall
# Created: 2024-10-07
# Last Modified: 2024-10-07
# Version 2.0
#
# Description:
#   Downloads the installer from the specified URL and saves it to the specified output path.
#   Ensures that the temporary directory exists before downloading.
#
# Parameters:
#   - DownloadUrl <string>
#       URL to download the installer from.
#
#   - OutputPath <string>
#       The full path (including filename) to save the downloaded installer.

function Get-Installer {
    param (
        [string]$DownloadUrl,
        [string]$OutputPath
    )

    if (-Not (Test-Path -Path $TempDir)) {
        New-Item -ItemType Directory -Path $TempDir | Out-Null
        Write-Verbose "Created temporary directory: $TempDir"
    }

    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputPath -ErrorAction Stop
        Write-Verbose "Downloaded installer to: $OutputPath"
    } catch {
        Write-Verbose "Error downloading installer: $_"
        Exit 1
    }
}

# Function: Install-ReportBuilder-msi 
#
# Modified by Kayla Southall
#
# Original Author: Kayla Southall
# Created: 2024-10-07
# Last Modified: 2024-10-29
# Version 3.0
# Description:
#   Executes the downloaded installer with specified arguments to perform a silent installation.
#
# Parameters:
#   - InstallerPath <string>
#       The full path to the installer file to be executed.

function Install-ReportBuilder-msi {
    param (
        [string]$InstallerPath
    )
    
    try {
        Write-Verbose "Installation is starting"
        Start-Process msiexec.exe -ArgumentList "/i", $InstallerPath, $InstallArgs -Wait -WindowStyle Hidden

        Write-Verbose "Installation completed successfully"
    } catch {
        Write-Verbose "Error during installation: $_"
        Exit 1
    }
}

# Function: Remove-Installer
#
# Author: Kayla Southall
# Created: 2024-10-07
# Last Modified: 2024-10-07
# Version 2.0
#
# Description:
#   Removes the downloaded installer file after installation.
#
# Parameters:
#   - InstallerPath <string>
#       The full path to the installer file to be removed.

function Remove-Installer {
    param (
        [string]$InstallerPath
    )

    try {
        Remove-Item -Path $InstallerPath -ErrorAction Stop
        Write-Verbose "Cleaned up installer file: $InstallerPath"
    } catch {
        Write-Verbose "Error cleaning up installer file: $_"
        Exit 1
    }
}

# Main script execution:
#
# Modified by Daniel Keer
#
# Original Author: Kayla Southall
# Created: 2024-10-07
# Last Modified: 2024-10-29
# Version 2.0
#
# 1. Sets the download URL and installer path
# 2. Downloads the installer
# 3. Installs Microsoft Report Builder
# 4. Cleans up the installer file

# Note: The script includes error handling and optional verbose output

$InstallerPath = Join-Path $TempDir "ReportBuilder.msi"

Write-Verbose "Starting installation process"
Write-Verbose "Using download URL: $DownloadUrl"

try {
    Get-Installer -DownloadUrl $DownloadUrl -OutputPath $InstallerPath
    Install-ReportBuilder-msi -InstallerPath $InstallerPath
    
}
catch {
    Write-Verbose "An error occurred during the installation process: $_"
    Exit 1
}
finally {
    if (Test-Path -Path $InstallerPath) {
        Remove-Installer -InstallerPath $InstallerPath
    } else {
        Write-Verbose "Installer file not found. No cleanup necessary."
    }
    Write-Verbose "Cleanup Completed"
}

Write-Verbose "Installation process completed"

# Restore the original ProgressPreference setting
$ProgressPreference = $OGProgressPreference