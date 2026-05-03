#Requires -Version 5
<#
 .Synopsis
 Run health checks against one or more systems defined in JSON config files.

 .Description
 Reads one or more JSON configuration files and runs the appropriate health checks
 (processes, services, files, shares, URIs, scheduled tasks, time sync, file counts)
 for each system defined.  Results are collected into a flat list and written to an
 output JSON file under .\output_files\.

 .Parameter ConfigFileName
 One or more FileInfo or path objects pointing to the JSON configuration files to process.

 .Example
Get-SystemHealth -ConfigFileName ".\config_files\system1.json",".\config_files\system2.json"

 #>
function Get-SystemHealth {
    [CmdletBinding()]
    param (
        [System.Object[]]$ConfigFileName
    )

    $ConfigFileName | ForEach-Object {
        
        $ConfigFile = $_
        $SystemHealthData = @()

        $file = Get-Content -Path $ConfigFile.FullName | ConvertFrom-Json
        $SystemName = $file.systemName
        $SystemDescription = $file.description
        
        $file.Processes | ForEach-Object {
            $procSplat = @{
                ProcessName       = $_.name
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-ProcessHealth @procSplat))
        }

        $file.Services | ForEach-Object {
            $serviceSplat = @{
                ServiceName       = $_.name
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-ServiceHealth @serviceSplat))
        }

        $file.FilesExist | ForEach-Object {
            $checkfileSplat = @{
                FilePath          = $_.FilePath
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-FileExists @checkfileSplat))
        }

        $file.SharesExist | ForEach-Object {
            $checkshareSplat = @{
                SharePath         = $_.SharePath
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-ShareExists @checkshareSplat))
        }

        $File.URIs | ForEach-Object {
            $checkURISplat = @{
                URI                   = $_.URI
                SystemName            = $SystemName
                SystemDescription     = $SystemDescription
                UseBasicParsing       = $_.useBasicParsing
                UseDefaultCredentials = $_.useDefaultCredentials
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-URIHealth @checkURISplat))
        }

        $file.ScheduledTasks | ForEach-Object {
            $schedtaskSplat = @{
                TaskPath          = $_.TaskPath
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-ScheduledTask @schedtaskSplat))
        }

        $file.TimeSync | ForEach-Object {
            $timesyncSplat = @{
                System1Name = $_.System1Name
                System2Name = $_.System2Name
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Test-TimeSync @timesyncSplat))
        }

        $file.FileCount | ForEach-Object {
            $filecountSplat = @{
                FilePath          = $_.FilePath
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                AppendLeaf        = $_.appendLeaf
                LeafFormat        = $_.leafFormat
            }
            $SystemHealthData = [System.Collections.ArrayList]$SystemHealthData; $null = $SystemHealthData.Add((Get-FileCount @filecountSplat))
        }

        $OutFileName = ".\output_files\healthcheck_$($ENV:COMPUTERNAME)_$($ConfigFile.Name)"
        $SystemHealthData | ConvertTo-Json | Out-File (New-Item -Path $OutFileName -Force)
        $SystemHealthData
    }
}