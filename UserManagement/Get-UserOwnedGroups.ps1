<#
.SYNOPSIS
Gets the groups owned by a specified user.

.DESCRIPTION
The Get-UserOwnedGroups function retrieves the groups where the specified user is an owner. It connects to the Microsoft Graph API, gets the user by their UPN (email), and then retrieves the groups where the user is an owner. The function outputs the group names to the console and exports them to a specified file.

.PARAMETER UserPrincipalName
The UPN (email) of the user whose owned groups should be retrieved.

.PARAMETER OutputFile
The file path to export the group names to. The default is "OwnedGroups.txt".

.EXAMPLE
Get-UserOwnedGroups -UserPrincipalName "user@example.com"
#>
function Get-UserOwnedGroups {
    param (
        [string]$UserPrincipalName, # The UPN (email) of the user
        [string]$OutputFile = "OwnedGroups.txt" # Output file for the groups
    )
    try {
        # Connect to Microsoft Graph with an interactive session
        Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All"

        # Get the user by their UPN
        $user = Get-MgUser -UserId $UserPrincipalName
        if (-not $user) {
            Write-Error "User not found: $UserPrincipalName" -ForegroundColor Red
            return
        }
        # Get groups where the user is an owner
        $ownedGroups = Get-MgUserOwnedObject -UserId $user.Id -All | Where-Object {$_.ODataType -eq '#microsoft.graph.group}'}

        if ($ownedGroups.Count -eq 0) {
            Write-Host "The user does not own any groups." -ForegroundColor Yellow
        } else {
            Write-Host "The user owns the following groups:" -ForegroundColor Green
            $ownedGroups | ForEach-Object { Write-Host $_.DisplayName -ForegroundColor Cyan }

            # Export group names to the specifed file
            $ownedGroups.DisplayName | Out-File -FilePath $OutputFile

            Write-Host "Group names exported to $OutputFile" -ForegroundColor Green
        }
    }
    catch {
        Write-Error $_.Exception.Message -ForegroundColor Red
    }
    finally {
        # Disconnect the session
        Disconnect-MgGraph
        Write-Host "Disconnected from Microsoft Graph" -ForegroundColor Magenta
    }
}