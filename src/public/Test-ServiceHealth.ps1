#Requires -Version 5
<# 
 .Synopsis
 Get status of a windows service.

 .Description
 Get status of a windows service.

 .Parameter

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
