# Define the download URL and file path
$downloadUrl = "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/9b7b8746971ed51a1770ae4293618187/ndp48-web.exe"
$installerPath = "C:\Temp\ndp48-web.exe"

# Create the Temp directory if it doesn't exist
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Download the installer
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

# Run the installer silently
Start-Process -FilePath $installerPath -ArgumentList "/q /norestart" -Wait

# Check the installation status
$installSuccess = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release -ErrorAction SilentlyContinue

if ($installSuccess) {
    Write-Output ".NET Framework installation completed."

    # Verify the installed version of .NET Framework
    $netVersion = $installSuccess.Release

    switch ($netVersion) {
        { $_ -ge 528040 } { $version = ".NET Framework 4.8"; break }
        { $_ -ge 461808 } { $version = ".NET Framework 4.7.2"; break }
        { $_ -ge 461308 } { $version = ".NET Framework 4.7.1"; break }
        { $_ -ge 460798 } { $version = ".NET Framework 4.7"; break }
        { $_ -ge 394802 } { $version = ".NET Framework 4.6.2"; break }
        { $_ -ge 394254 } { $version = ".NET Framework 4.6.1"; break }
        { $_ -ge 393295 } { $version = ".NET Framework 4.6"; break }
        { $_ -ge 379893 } { $version = ".NET Framework 4.5.2"; break }
        { $_ -ge 378675 } { $version = ".NET Framework 4.5.1"; break }
        { $_ -ge 378389 } { $version = ".NET Framework 4.5"; break }
        default { $version = "Version not detected or below .NET Framework 4.5" }
    }

    Write-Output "Installed .NET Framework version: $version"
} else {
    Write-Output "Installation failed or .NET Framework not detected."
}

# Cleanup: Optionally delete the installer after installation
Remove-Item $installerPath -Force
