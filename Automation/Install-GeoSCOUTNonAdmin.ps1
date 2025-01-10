# Define the username to check
$userId = "REYNHOLM\moss"

# Extract the username from $userId (value after the backslash)
$username = $userId.Split('\')[-1]

# Function to check if the user is currently signed in
function Is-UserLoggedIn {
    $loggedInUsers = (Get-WmiObject -Class Win32_ComputerSystem).UserName
    return $loggedInUsers -eq $userId
}

# Proceed only if the user is signed in
if (Is-UserLoggedIn) {
    Write-Output "User $userId is currently signed in. Proceeding with task creation."

    # Create the action to run the installer
    $action = New-ScheduledTaskAction -Execute "\\RYN-SRV1\geoLOGIC\geoSCOUT\Desktop_Build_NonAdmin_v9.exe" `
        -Argument "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART"

    # Create a one-time trigger to run immediately
    $trigger = New-ScheduledTaskTrigger -Once -At ((Get-Date).AddMinutes(1))

    # Specify the principal to run the task interactively as the user
    $principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType Interactive

    # Register the scheduled task
    Register-ScheduledTask -TaskName "Install_GeoScout_NonAdmin" -Action $action -Trigger $trigger -Principal $principal
    Write-Output "Scheduled task 'Install_GeoScout_NonAdmin' created and started."

    # Start the task immediately
    Start-ScheduledTask -TaskName "Install_GeoScout_NonAdmin"

    # Wait 10 seconds to allow the installer to create the necessary files
    Start-Sleep -Seconds 30

    # Dynamically construct the AppData path based on the extracted username
    $appDataPath = "C:\Users\$username\AppData\Local\geoLOGIC systems\geoSCOUT"
    
    if (Test-Path -Path $appDataPath) {
        Write-Output "geoSCOUT files found in '$appDataPath'. Installation appears successful."
    } else {
        Write-Output "geoSCOUT files not found in '$appDataPath'. Installation may have failed."
    }

    # Unregister the scheduled task to clean up
    Unregister-ScheduledTask -TaskName "Install_GeoScout_NonAdmin" -Confirm:$false
    Write-Output "Scheduled task 'Install_GeoScout_NonAdmin' unregistered."
} else {
    Write-Output "User $userId is not currently signed in. Task will not be created."
}
