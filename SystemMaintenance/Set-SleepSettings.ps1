# Set the screen to turn off after 2 hours (120 minutes) when plugged in
powercfg -change -monitor-timeout-ac 120

# Set the system sleep setting to 'Never' when plugged in
powercfg -change -standby-timeout-ac 0

Write-Output "Sleep settings have been configured: Screen turns off after 2 hours, and system sleep is disabled when plugged in."