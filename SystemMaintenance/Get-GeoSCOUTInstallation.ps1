# Function to search registry for geoSCOUT installations
function Get-GeoScoutRegistryPaths {
    # Search in HKLM (Admin Version)
    $adminPath = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' `
                -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName -like '*geoSCOUT*' } |
                Select-Object -ExpandProperty InstallLocation -ErrorAction SilentlyContinue

    # Search in HKU for all user-specific registry hives (User Version)
    $userPaths = @()
    Get-ChildItem -Path 'HKU:\' -ErrorAction SilentlyContinue | ForEach-Object {
        $sid = $_.PSChildName
        $path = "HKU:\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
        $userPath = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
                    Where-Object { $_.DisplayName -like '*geoSCOUT*' } |
                    Select-Object -ExpandProperty InstallLocation -ErrorAction SilentlyContinue
        if ($userPath) { $userPaths += $userPath }
    }

    return [PSCustomObject]@{
        AdminPath = $adminPath
        UserPaths = $userPaths
    }
}

# Function to search file system for geoSCOUT installations
function Get-GeoScoutFilePaths {
    $paths = @(
        "C:\Program Files",
        "C:\Program Files (x86)",
        "C:\Users\*\AppData\Local",
        "C:\Users\*\AppData\Roaming"
    )

    $geoScoutPaths = @()
    foreach ($path in $paths) {
        Get-ChildItem -Path $path -Recurse -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like 'geoSCOUT*' } |
        ForEach-Object {
            $geoScoutPaths += $_.FullName
        }
    }
    return $geoScoutPaths
}

# Run both functions
$geoScoutRegistryPaths = Get-GeoScoutRegistryPaths
$geoScoutFilePaths = Get-GeoScoutFilePaths

# Output results
Write-Output "Registry Search Results:"
Write-Output "Admin Path: $($geoScoutRegistryPaths.AdminPath)"
if ($geoScoutRegistryPaths.UserPaths.Count -gt 0) {
    Write-Output "User Paths: $($geoScoutRegistryPaths.UserPaths -join ', ')"
} else {
    Write-Output "User Paths: None found"
}

Write-Output "`nFile System Search Results:"
if ($geoScoutFilePaths.Count -gt 0) {
    Write-Output ($geoScoutFilePaths -join "`n")
} else {
    Write-Output "No geoSCOUT installations found in file system."
}
