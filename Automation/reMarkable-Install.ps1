# reMarkable-Install.ps1
#
# Author: Kayla Southall
# Created: 2024-10-07
# Last Modified: 2024-10-07
#
# Description:
#   This script automates the download and installation of the reMarkable application.
#   It handles downloading the installer, executing the installation with specified arguments,
#   creating a shortcut in the Public Start Menu, and cleaning up temporary files post-installation.
#
# Parameters:
#   -Verbose: Switch to enable verbose output.  Provides detailed execution information.
#
#   -TempDir <string>
#       Specifies the directory for temporary files.
#       Default: "C:\Temp"
#
#   -AppName <string>
#       Name of the application to install and pin.
#       Default: "reMarkable"
#
#   -AppExecutablePath <string>
#       Path to the executable file of the application.
#       Default: "C:\Program Files\reMarkable\reMarkable.exe"
#
#   -InstallArgs <string>
#       Arguments to pass to the installer for silent installation.
#       Default: "--accept-messages --accept-licenses --confirm-command install com.remarkable.xochitl"
#
#   -DownloadUrl <string>
#       URL to download the installer from.
#       Default: "https://downloads.remarkable.com/desktop/production/win/reMarkable-3.15.1.895-win64.exe"
#
# Usage:
#   .\reMarkable-Install.ps1
#   .\reMarkable-Install.ps1 -Verbose
#   .\reMarkable-Install.ps1 -TempDir "D:\CustomTemp"

  [CmdletBinding()]
  param (
      [string]$TempDir = "C:\Temp",
      [string]$AppName = "reMarkable",
      [string]$AppExecutablePath = "C:\Program Files\reMarkable\reMarkable.exe",
      [string]$InstallArgs = "--accept-messages --accept-licenses --confirm-command install com.remarkable.xochitl",
      [string]$DownloadUrl = "https://downloads.remarkable.com/desktop/production/win/reMarkable-3.15.1.895-win64.exe"
  )
# Function: Get-Installer
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
# Function: Install-ReMarkable
#
# Description:
#   Executes the downloaded installer with specified arguments to perform a sillent installation.
#
# Parameters:
#   - InstallerPath <string>
#       The full path to the installer file to be executed.

function Install-ReMarkable {
    param (
        [string]$InstallerPath
    )
    
    try {
        Start-Process -FilePath $InstallerPath -ArgumentList $InstallArgs -Wait -WindowStyle Hidden
        Write-Verbose "Installation completed successfully"
    } catch {
        Write-Verbose "Error during installation: $_"
        Exit 1
    }
}
# Function: New-Shortcut
#
# Description:
#   Creates a shortcut to the installed application in the Public Start Menu.
#
# Parameters:
#   - AppName <string>
#       Name of the application to create the shortcut for.
#
#   - AppExecutablePath <string>
#       Path to the executable file of the application.
#
#   - ShortcutPath <string>
#       Path where the shortcut will be created.

function New-Shortcut {
    param (
        [string]$AppName,
        [string]$AppExecutablePath,
        [string]$ShortcutPath
    )

    try {
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
        $Shortcut.TargetPath = $AppExecutablePath
        $Shortcut.WorkingDirectory = Split-Path $AppExecutablePath
        $Shortcut.WindowStyle = 1
        $Shortcut.IconLocation = $AppExecutablePath
        $Shortcut.Save()
        Write-Verbose "Shortcut created at: $ShortcutPath"
    } catch {
        Write-Verbose "Error creating shortcut: $_"
        Exit 1
    }
}
# Function: Remove-Installer
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
# 1. Sets the download URL and installer path
# 2. Downloads the installer
# 3. Installs reMarkable
# 4. Creates a shortcut to the installed application in the Public Start Menu
# 5. Cleans up the installer file

# Note: The script includes error handling and optional verbose output

$InstallerPath = Join-Path $TempDir "installer.exe"

Write-Verbose "Starting installation process"
Write-Verbose "Using download URL: $DownloadUrl"

try {
    Get-Installer -DownloadUrl $DownloadUrl -OutputPath $InstallerPath
    Install-ReMarkable -InstallerPath $InstallerPath
    
    # Define the Public Start Menu Programs path
    $PublicStartMenuPrograms = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"

    # Define the shortcut path
    $ShortcutPath = Join-Path $PublicStartMenuPrograms "$AppName.lnk"

    # Create the shortcut
    Create-Shortcut -AppName $AppName -AppExecutablePath $AppExecutablePath -ShortcutPath $ShortcutPath
}
catch {
    Write-Verbose "An error occurred during the installation process: $_"
    Exit 1
}
finally {
    if (Test-Path -Path $InstallerPath) {
        Remove-Installer -InstallerPath $InstallerPath
    } else {
        Write-Verbose "Installer file not found.  No cleanup necessary."
    }
    Write-Verbose "Cleanup Completed"
}

Write-Verbose "Installation process completed"
