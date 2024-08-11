# Define the log file path
$logFile = "C:\Projects\Powershell\System Health Check\SystemHealthLog.txt"

# Get the current date and time
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Get CPU usage
$cpuUsage = Get-WmiObject -Query "SELECT * FROM Win32_Processor" | Select-Object -ExpandProperty LoadPercentage
Write-Output "CPU Usage: $cpuUsage%"

# Get memory usage
$mem = Get-WmiObject -Class Win32_OperatingSystem
$memUsage = "{0:N2}" -f (($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize * 100)
Write-Output "Memory Usage: $memUsage%"

# Get disk usage
$diskUsage= Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Used(%)";Expression={"{0:N2}" -f (($_.Used/($_.Used + $_.Free)) * 100)}}

foreach ($disk in $diskUsage) {
    Write-Output "Disk $($disk.Name) Usage: $($disk.'Used(%)')%"
}

# Log the results
Add-Content -Path $logFile -Value "System Health Check on $timestamp"
Add-Content -Path $logFile -Value "CPU Usage: $cpuUsage%"
Add-Content -Path $logFile -Value "Memory Usage: $memUsage%"
foreach ($disk in $diskUsage) {
    Add-Content -Path $logFile -Value "Disk $($disk.Name) Usage: $($disk.'Used(%)')%"
}
Add-Content -Path $logFile -Value "`n"  # Add a newline for better readability

# Display completion message in console
Write-Output "System health check completed on $timestamp"
