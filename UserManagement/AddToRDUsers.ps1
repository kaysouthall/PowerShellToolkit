param (
    [string]$username,
    [string]$computerName = $env:COMPUTERNAME # Defaults to the local computer if not specified
)

# Check if the username parameter is provided
if (-not $username) {
    Write-Host "Please provide a username."
    exit
}

# Define the Remote Desktop Users group on the specified computer
$group = [ADSI]"WinNT://$computerName/Remote Desktop Users,group"

try {
    # Add the user to the Remote Desktop Users group on the specified computer
    $group.Add("WinNT://$username")
    Write-Host "$username has been added to the Remote Desktop Users group on $computerName successfully."
} catch {
    Write-Host "Failed to add $username to the Remote Desktop Users group on $computerName. Error: $_"
}