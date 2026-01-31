#Requires -Version 5
<#
 .Synopsis
 See if a file path exists.

 .Description
 See if a file path exists.

 .Parameter

 .Example
Test-FileExists -FilePath "c:\my\file"
 #>
function Test-FileExists {
    [CmdletBinding()]
    param (
        [string]$FilePath,
        [string]$SystemName,
        [string]$SystemDescription
    )

    $HealthCheckType = 'FileExists'

    $filename = Split-Path -Path $FilePath -Leaf

    try {
        if (Test-Path -Path $FilePath) {
            return [PSCustomObject]@{
                SystemName          = $SystemName
                SystemDescription   = $SystemDescription
                Name                = $filename
                Type                = $HealthCheckType
                Status              = 'Exists'
                LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment             = $FilePath
                ComputerName        = $ENV:COMPUTERNAME
            }
        } else {
            return [PSCustomObject]@{
                SystemName          = $SystemName
                SystemDescription   = $SystemDescription
                Name                = $filename
                Type                = $HealthCheckType
                Status              = 'Not Found'
                LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment             = $FilePath
                ComputerName        = $ENV:COMPUTERNAME
            }
        }
    } catch {
        return [PSCustomObject]@{
            SystemName          = $SystemName
            SystemDescription   = $SystemDescription
            Name                = $FilePath
            Type                = $HealthCheckType
            Status              = 'ERROR'
            LastUpdate          = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment             = $Error[0].Exception.Message
            ComputerName        = $ENV:COMPUTERNAME
        }
    }
}
