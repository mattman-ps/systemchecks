#Requires -Version 5
<#
 .Synopsis
 See if a process is running.

 .Description
 See if a process is running.

 .Parameter

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
        $process = Get-Process -Name $ProcessName
        if (!$null -eq $process) {
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
        } else {
            return [PSCustomObject]@{
                SystemName              = $SystemName
                SystemDescription       = $SystemDescription
                Name                    = $ProcessName
                Type                    = $HealthCheckType
                Status                  = 'ERROR'
                LastUpdate              = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment                 = $Error[0].Exception.Message
                ComputerName            = $ENV:COMPUTERNAME
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
            Comment                     = $Error[0].Exception.Message
            ComputerName                = $ENV:COMPUTERNAME
        }
    }
}
