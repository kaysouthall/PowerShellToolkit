# Function to display inbox rules for a given user
function Get-UserInboxRules {
    param (
        [Parameter(Mandatory=$true)]
        [string]$UserEmail
    )

    try {
        # Get the inbox rules for the specified user
        $rules = Get-InboxRule -Mailbox $UserEmail

        if ($rules.Count -eq 0) {
            Write-Host "No inbox rules found for the user: $UserEmail" -ForegroundColor Yellow
            return
        }

        # Loop through each rule and display its details
        foreach ($rule in $rules) {
            Write-Host "----------------------------------------"
            Write-Host "Rule Name: " $rule.Name
            Write-Host "Enabled: " ($rule.Enabled -eq $true)
            Write-Host "Description: " $rule.Description
            Write-Host "----------------------------------------`n"
        }
    } catch {
        Write-Error "An error occurred: $_"
    }
}

# Example usage:
# Get-UserInboxRules -UserEmail "user@example.com"
