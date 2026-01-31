#Requires -Version 5
<#
 .Synopsis
 Analyze different components of a system.

 .Description
 Analyze different components of a system. A system can be any collection of items to check.

 .Parameter

 .Example

 #>
function Get-SystemHealth {
    [CmdletBinding()]
    param (
        [System.Object[]]$ConfigFileName
    )

    $ScriptDirectory = Split-Path $Script:MyInvocation.MyCommand.Path -Parent
    $IncludesPath = Join-Path -Path $ScriptDirectory -ChildPath "Includes"

    . (Join-Path -Path $IncludesPath -ChildPath "Get-Win32Error.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-FileExists.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-ShareExists.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-ProcessHealth.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-ScheduledTask.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-ServiceHealth.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-TimeSync.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Test-URIHealth.ps1")
    . (Join-Path -Path $IncludesPath -ChildPath "Get-FileCount.ps1")

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
            $SystemHealthData += Test-ProcessHealth @procSplat
        }

        $file.Services | ForEach-Object {
            $serviceSplat = @{
                ServiceName       = $_.name
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData += Test-ServiceHealth @serviceSplat
        }

        $file.FilesExist | ForEach-Object {
            $checkfileSplat = @{
                FilePath          = $_.FilePath
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData += Test-FileExists @checkfileSplat
        }

        $file.SharesExist | ForEach-Object {
            $checkshareSplat = @{
                SharePath         = $_.SharePath
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
            }
            $SystemHealthData += Test-ShareExists @checkshareSplat

            $File.URIs | ForEach-Object {
                $checkURISplat = @{
                    URI               = $_.URI
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                    UseBasicParsing = $_.useBasicParsing
                    UseDefaultCredentials = $_.useDefaultCredentials
                }
                $SystemHealthData += Test-URIHealth @checkURISplat
            }

            $file.ScheduledTasks | ForEach-Object {
                $schedtaskSplat = @{
                    TaskPath          = $_.TaskPath
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                }
                $SystemHealthData += Test-ScheduledTask @schedtaskSplat
            }

            $file.FileCount | ForEach-Object {
                $filecountSplat = @{
                    FilePath          = $_.FilePath
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                    AppendLeaf        = $_.appendLeaf
                    LeafFormat        = $_.leafFormat
                }
                $SystemHealthData += Get-FileCount @filecountSplat
            }

            $OutFileName = ".\output_files\healthcheck_$($ENV:COMPUTERNAME)_$($ConfigFile.Name)"
            $SystemHealthData | ConvertTo-Json | Out-File (New-Item -Path $OutFileName -Force)
        }
        $SystemHealthData
    }
}