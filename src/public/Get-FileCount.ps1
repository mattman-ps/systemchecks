#Requires -Version 5
<#
 .Synopsis
 Count the number of files in a directory.

 .Description
 Returns the count of files (not sub-directories) in the specified path.
 Optionally appends a date-based sub-folder to the base path using the
 AppendLeaf and LeafFormat parameters — handy for checking whether today's
 or yesterday's output files were created by a batch process.

 .Parameter FilePath
 Base directory path to check.

 .Parameter SystemName
 Friendly name for the system this check belongs to (used in reporting).

 .Parameter SystemDescription
 Short description of the system (used in reporting).

 .Parameter AppendLeaf
 When set, a date sub-folder is appended to FilePath.  Accepted values:
 'Today' (current date) or 'Yesterday' (previous day).

 .Parameter LeafFormat
 The date format string passed to Get-Date when building the sub-folder name,
 e.g. 'yyyyMMdd'.

 .Example
Get-FileCount -FilePath "c:\my\folder"
 #>
function Get-FileCount {
    [CmdletBinding()]
    param (
        [string]$FilePath,
        [string]$SystemName,
        [string]$SystemDescription,
        [string]$AppendLeaf,
        [string]$LeafFormat
    )

    $HealthCheckType = 'FileCount'

    try {
        if (Test-Path -Path $FilePath) {

            $FolderName = Split-Path -Path $FilePath -Leaf

            if (-not [string]::IsNullOrEmpty($AppendLeaf)) {
                switch ($AppendLeaf) {
                    'Today' {
                        $ChildPath = Get-Date -Format $LeafFormat
                        $CheckPath = Join-Path -Path $FilePath -ChildPath $ChildPath
                        $FolderName += "\$ChildPath."
                    }
                    'Yesterday' {
                        $ChildPath = Get-Date -Date ((Get-Date).AddDays(-1)) -Format $LeafFormat
                        $CheckPath = Join-Path -Path $FilePath -ChildPath $ChildPath
                        $FolderName += "\$ChildPath."
                    }
                }
                Write-Verbose "AppendLeaf: $AppendLeaf"
                Write-Verbose "CheckPath: $CheckPath"
                Write-Verbose "FolderName: $FolderName"
            }
            else {
                $CheckPath = $FilePath
                Write-Verbose "Skipping - AppendLeaf"
            }

            if (Test-Path -Path $CheckPath) {
                $FileCount = Get-ChildItem -Path $CheckPath -File | Measure-Object | Select-Object -ExpandProperty Count
                $Comment = $CheckPath
                Write-Verbose "Good test path - value: $CheckPath"
            } else{
                $Exception = $Error[0].Exception.Message
                if ([string]::IsNullOrEmpty($Exception)) {
                    $Exception = "Path not found: $CheckPath"
                }
                Write-Verbose $Exception
                $FileCount = 0
                $Comment = $Exception
            }

            Write-Verbose "Comment: $Comment"

            return [PSCustomObject]@{
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                Name              = $FolderName
                Type              = $HealthCheckType
                Status            = $FileCount
                LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment           = $Comment
                ComputerName      = $ENV:COMPUTERNAME
            }
        }
        else {
            $Exception = $Error[0].Exception.Message
            if ([string]::IsNullOrEmpty($Exception)) {
                $Exception = "Path not found: $FilePath"
            }
            Write-Verbose $Exception

            return [PSCustomObject]@{
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                Name              = $FilePath
                Type              = $HealthCheckType
                Status            = 'ERROR'
                LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment           = $Exception
                ComputerName      = $ENV:COMPUTERNAME
            }
        }
    }
    catch {
        $Exception = $Error[0].Exception.Message
        if ([string]::IsNullOrEmpty($Exception)) {
            $Exception = "Path not found: $FilePath"
        }
        Write-Verbose $Exception

        return [PSCustomObject]@{
            SystemName        = $SystemName
            SystemDescription = $SystemDescription
            Name              = $FilePath
            Type              = $HealthCheckType
            Status            = 'ERROR'
            LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment           = $Exception
            ComputerName      = $ENV:COMPUTERNAME
        }
    }
}
