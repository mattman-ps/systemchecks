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

    # Extract share name - handle UNC paths, drive letters, and regular paths
    if ($SharePath -match '^\\\\[^\\]+\\([^\\]+)') {
        # UNC path like \\server\share
        $ShareName = $matches[1]
    }
    elseif ($SharePath -match '^([A-Z]:)') {
        # Drive letter like C:
        $ShareName = $matches[1]
    }
    else {
        # Fall back to GetFileName for other paths
        $ShareName = [System.IO.Path]::GetFileName($SharePath)
        if ([string]::IsNullOrEmpty($ShareName)) {
            $ShareName = $SharePath
        }
    }

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
