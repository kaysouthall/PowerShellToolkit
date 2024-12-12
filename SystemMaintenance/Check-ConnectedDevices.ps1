# Function to check for connected mouse
function Get-Mouse {
    $mice = Get-WmiObject -Namespace "root\CIMV2" -Class Win32_PointingDevice
    if ($mice) {
        Write-Output "Mouse detected:"
        $mice | Select-Object Name, Manufacturer
    } else {
        Write-Output "No mouse detected."
    }
}

# Function to check for connected keyboard
function Get-Keyboard {
    $keyboards = Get-WmiObject -Namespace "root\CIMV2" -Class Win32_Keyboard
    if ($keyboards) {
        Write-Output "Keyboard detected:"
        $keyboards | Select-Object Name, Manufacturer
    } else {
        Write-Output "No keyboard detected."
    }
}

# Function to check for connected monitors
function Get-Monitor {
    $monitors = Get-WmiObject -Namespace "root\CIMV2" -Class Win32_DesktopMonitor
    if ($monitors) {
        Write-Output "Monitor detected:"
        $monitors | Select-Object Name, ScreenWidth, ScreenHeight
    } else {
        Write-Output "No monitor detected."
    }
}

# Run all checks
Write-Output "Checking for connected devices..."
Get-Mouse
Get-Keyboard
Get-Monitor
