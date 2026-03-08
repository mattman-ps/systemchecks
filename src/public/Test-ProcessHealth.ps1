#Requires -Version 5
<#
 .Synopsis
 Check if a process is running and responding.

 .Description
 Uses Get-Process to find the named process and checks the Responding flag.
 Returns 'Responding' if the process is found and not hung, or 'ERROR' if the
 process is not running or is unresponsive.

 .Parameter ProcessName
 The name of the process to check (without the .exe extension).

 .Parameter SystemName
 Friendly name for the system this check belongs to (used in reporting).

 .Parameter SystemDescription
 Short description of the system (used in reporting).

 .Example
Test-ProcessHealth -ProcessName "explorer"
 #>
 function Test-ProcessHealth {
    [CmdletBinding()]
    param (
        [string]$ProcessName,
        [string]$SystemName,
        [string]$SystemDescription
    )
    $HealthCheckType = 'Process'
    try {
        $process = Get-Process -Name $ProcessName -ErrorAction Stop
        if ($process.Responding -eq $true) {
            return [PSCustomObject]@{
                SystemName          = $SystemName
                SystemDescription   = $SystemDescription
                Name                = $ProcessName
                Type                = $HealthCheckType
                Status              = 'Responding'
                LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment             = ""
                ComputerName        = $ENV:COMPUTERNAME
            }
        } else {
            return [PSCustomObject]@{
                SystemName          = $SystemName
                SystemDescription   = $SystemDescription
                Name                = $ProcessName
                Type                = $HealthCheckType
                Status              = 'ERROR'
                LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment             = "Process not responding.  Status: $($process.Responding)"
                ComputerName        = $ENV:COMPUTERNAME
            }
        }
    } catch {
        return [PSCustomObject]@{
            SystemName                  = $SystemName
            SystemDescription           = $SystemDescription
            Name                        = $ProcessName
            Type                        = $HealthCheckType
            Status                      = 'ERROR'
            LastUpdate                  = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment                     = $_.Exception.Message
            ComputerName                = $ENV:COMPUTERNAME
        }
    }
}
