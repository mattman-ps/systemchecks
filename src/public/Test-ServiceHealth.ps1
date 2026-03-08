#Requires -Version 5
<# 
 .Synopsis
 Check the running status of a Windows service.

 .Description
 Retrieves the named service using Get-Service and checks whether it is in the
 Running state.  Returns 'OK' if running, or 'ERROR' with the current status in
 the Comment field if stopped, paused, or not found.

 .Parameter ServiceName
 The short service name (not the display name) to check, e.g. 'w3svc'.

 .Parameter SystemName
 Friendly name for the system this check belongs to (used in reporting).

 .Parameter SystemDescription
 Short description of the system (used in reporting).

 .Example
Test-ServiceHealth -ServiceName 'w3svc'
 #>
function Test-ServiceHealth {
    [CmdletBinding()]
    param (
        [string]$ServiceName,
        [string]$SystemName,
        [string]$SystemDescription
    )

    $HealthCheckType = 'Service'

    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop
        if ($service.Status -eq 'Running') {
            return [PSCustomObject]@{
                SystemName          = $SystemName
                SystemDescription   = $SystemDescription
                Name                = $ServiceName
                Type                = $HealthCheckType
                Status              = 'OK'
                LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment             = ""
                ComputerName        = $ENV:COMPUTERNAME
            }
        } else {
            return [PSCustomObject]@{
                SystemName          = $SystemName
                SystemDescription   = $SystemDescription
                Name                = $ServiceName
                Type                = $HealthCheckType
                Status              = 'ERROR'
                LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment             = $service.Status
                ComputerName        = $ENV:COMPUTERNAME
            }
        }
    } catch {
        return [PSCustomObject]@{
            SystemName              = $SystemName
            SystemDescription       = $SystemDescription
            Name                    = $ServiceName
            Type                    = $HealthCheckType
            Status                  = 'ERROR'
            LastUpdate              = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment                 = $_.Exception.Message
            ComputerName        = $ENV:COMPUTERNAME
        }
    }
}
