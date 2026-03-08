#Requires -Version 5
<#
 .Synopsis
 Check whether a network share or local path is accessible.

 .Description
 Uses Test-Path to verify access to a UNC share, drive letter, or local path.
 Handles UNC paths (\\server\share), drive letters (C:), and plain paths, and
 extracts a meaningful share name for reporting in each case.
 Returns 'Exists' when the path is reachable, 'Not Found' when it is not, or
 'ERROR' if an exception is raised.

 .Parameter SharePath
 The path to test, e.g. '\\server\e$' or 'D:\Data'.

 .Parameter SystemName
 Friendly name for the system this check belongs to (used in reporting).

 .Parameter SystemDescription
 Short description of the system (used in reporting).

 .Example
Test-ShareExists -SharePath "\\server\e$"
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
