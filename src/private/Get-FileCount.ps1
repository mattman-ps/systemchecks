#Requires -Version 5
<#
 .Synopsis
 Get a file count from a given path.

 .Description
 Get a file count from a given path.  Can handle network shares as well.

 .Parameter

 .Example
Get-FileCount FilePath "c:\my\file"
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
            }
            else {
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
