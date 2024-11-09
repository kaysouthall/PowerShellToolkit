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
# SIG # Begin signature block
# MIIFYQYJKoZIhvcNAQcCoIIFUjCCBU4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBqjVJ7GvQzA9rSNCDZ2aB4jL
# B5SgggMGMIIDAjCCAeqgAwIBAgIQX/7e2okZDoJCDX96YU54ujANBgkqhkiG9w0B
# AQsFADAQMQ4wDAYDVQQDDAVLYXlsYTAeFw0yNDEwMjUxNzAyMThaFw0yNTEwMjUx
# NzIyMThaMBAxDjAMBgNVBAMMBUtheWxhMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
# MIIBCgKCAQEAvKi+EqsmKoGBrx94roJfarB/tp2PZjuHRDKnP4EybDrhpDHLBQXv
# tIvxI3b8v6Ov6OTnYATVRCfewlU/Q4Mh28ZcHfluoQKvEnqAj94mXiPYc8V5buq4
# 4CUe9dxKKB8l5AuPIwkqQaA9Ad6Ume/YjHjehcjbnKfeA/ysdx51XcMXwTmynUlO
# 7WY1CkzoQXOWl0PLZETSSST49XYiTwt505Z15mJCiRMkZvW3a2e3b3FgvWmWkNDP
# i+iE6CMQ8fTZPd82ICQSxxDNU2TYWAuLCao15JoAWV3zSEHyObCEAJ2O0MIAl4zj
# o6Rm0DDSlY9iysrwDTKWC4JPdbza7Y53kQIDAQABo1gwVjAOBgNVHQ8BAf8EBAMC
# B4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwEAYDVR0RBAkwB4IFS2F5bGEwHQYDVR0O
# BBYEFKEb2UIWeoMhiD7EAk0297k23VSTMA0GCSqGSIb3DQEBCwUAA4IBAQCkifHc
# lCaZZju3nWxlk26xjekjmjcnvInvtK981azD2yxJlrrMAVeFRq/xMo+oAOWzGiym
# IJ1O3ZjBAatGj5s966acJWxt+GHUbNogEEGGZYKmIk5N05OKfoJz/d2jNalygvEN
# LgpfNBEBriQ+a+b3cQJRzCo1haTAPDhoyJheCDDK0sPTl8JbF+36xLeGQZ2hZIld
# yGnKDSEXBcLGiBQn9AX3q3Krx8dY5NsQWUQW6CUCL+Oa8xBsH2WA5/LDyCOthnlL
# zllLPNtq/aAfeEroDotNz4h+n2WCT10t1r+5kWG0OworW1xa/8JfCY9ahbfRj029
# nDietbHBRBvFgfZYMYIBxTCCAcECAQEwJDAQMQ4wDAYDVQQDDAVLYXlsYQIQX/7e
# 2okZDoJCDX96YU54ujAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAA
# oQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUrMc7IoMsLnI5VjAAUpxorXlC
# 6mkwDQYJKoZIhvcNAQEBBQAEggEAVDapOZrA4UNeS+iG2ezjO1/GQoPXpAhy9rGF
# zctvEncyZonvCirDSuC5g9kS47A2VSEti5iCHTOIty/ObaqHSQ2Til5pZjprqj1Q
# zI80Hnn2oUT61OEzLAxDYYCtLX2t9F5LpbQJk4oWwXM+T6tnkLDAwAEjN3WnbkVy
# 38Xh8QTNZay0shSPCHmXq+ulCv1o7J+ghRZbnKpzdif9cVm+xXmozVJj3U8u0vJo
# CsZy7QLD2EVaFVy+uViLz+eZ0UyrkVp/GCOkiN7KT/JlKnoxzypm0i/c9OX4/TrC
# aSkxUPxws9gdISihe2luMCo6FusaKZelPaPEI2c2XNmn++Q34Q==
# SIG # End signature block
