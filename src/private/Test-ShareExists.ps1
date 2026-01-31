#Requires -Version 5
<#
 .Synopsis
 See if a share path exists.

 .Description
 See if a share path exists.

 .Parameter

 .Example
Test-FileShare -SharePath "\\tapp1\e$"
 #>
function Test-ShareExists {
    [CmdletBinding()]
    param (
        [string]$SharePath,
        [string]$SystemName,
        [string]$SystemDescription
    )

    $HealthCheckType = 'ShareExists'

    $ShareName = [System.IO.Path]::GetFileName($SharePath)

    try {
        if (Test-Path -Path $SharePath) {
            return [PSCustomObject]@{
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                Name              = $ShareName
                Type              = $HealthCheckType
                Status            = 'Exists'
                LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment           = $SharePath
                ComputerName      = $ENV:COMPUTERNAME
            }
        }
        else {
            return [PSCustomObject]@{
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                Name              = $ShareName
                Type              = $HealthCheckType
                Status            = 'Not Found'
                LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment           = $SharePath
                ComputerName      = $ENV:COMPUTERNAME
            }
        }
    }
    catch {
        return [PSCustomObject]@{
            SystemName        = $SystemName
            SystemDescription = $SystemDescription
            Name              = $ShareName
            Type              = $HealthCheckType
            Status            = 'ERROR'
            LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment           = $Error[0].Exception.Message
            ComputerName      = $ENV:COMPUTERNAME
        }
    }
}
