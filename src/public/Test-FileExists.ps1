#Requires -Version 5
<#
 .Synopsis
 Check whether a file or directory path exists.

 .Description
 Uses Test-Path to determine whether the supplied path is present on disk.
 Returns 'Exists' when the path is found, 'Not Found' when it is absent, or
 'ERROR' if an unexpected exception occurs (e.g. access denied, invalid path).

 .Parameter FilePath
 Full path to the file or directory to check.

 .Parameter SystemName
 Friendly name for the system this check belongs to (used in reporting).

 .Parameter SystemDescription
 Short description of the system (used in reporting).

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
