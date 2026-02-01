#Requires -Version 5
<#
 .Synopsis
 Get status of a scheduled task.

 .Description
 Get status of a scheduled task.

 .Parameter

 .Example
Test-ScheduledTask -TaskPath "\SLMPD\Send OnCallSchedule"
 #>
function Test-ScheduledTask {
    [CmdletBinding()]
    param (
        [string]$TaskPath,
        [string]$SystemName,
        [string]$SystemDescription
    )

    $HealthCheckType = 'ScheduledTask'

    $task = Split-Path -Path $TaskPath -Leaf
    $path = Split-Path -Path $TaskPath -Parent

    try {
        $taskdetail = Get-ScheduledTaskInfo -TaskName $task -TaskPath $path
        if ($taskdetail -and $taskdetail.LastTaskResult -eq '0') {
            return [PSCustomObject]@{
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                Name              = $TaskPath
                Type              = $HealthCheckType
                Status            = 'OK'
                LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment           = "LastRunTime: $($taskdetail.LastRunTime)  NextRunTime: $($taskdetail.NextRunTime)  MissedRuns: $($taskdetail.NumberOfMissedRuns)"
                ComputerName      = $ENV:COMPUTERNAME
            }
        }
        else {
            if (!$null -eq $taskdetail) {
                $errorResult = Get-Win32Error -ErrorCode $taskdetail.LastTaskResult
                $parsedErrorMessage = $errorResult -split '`r`n'
    
                Write-Verbose "Parsed Error: {$parsedErrorMessage}"
    
                if (-not [string]::IsNullOrEmpty($parsedErrorMessage)) {
                    $errMessage = $parsedErrorMessage[2].Trim()
                    $errCodeConverted = $parsedErrorMessage[1].Trim() -replace '\s{2,}', ', '
                }
                else {
                    $errMessage = ""
                    $errCodeConverted = 0
                }
    
                return [PSCustomObject]@{
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                    Name              = $TaskPath
                    Type              = $HealthCheckType
                    Status            = ("{0} - {1}" -f $taskdetail.LastTaskResult, $errCodeConverted)
                    LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                    Comment           = $errMessage
                    ComputerName      = $ENV:COMPUTERNAME
                }
            }
            else {
                return [PSCustomObject]@{
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                    Name              = $TaskPath
                    Type              = $HealthCheckType
                    Status            = 'ERROR'
                    LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                    Comment           = "Task not found."
                    ComputerName      = $ENV:COMPUTERNAME
                }
            }
        }
    }
    catch {
        return [PSCustomObject]@{
            SystemName        = $SystemName
            SystemDescription = $SystemDescription
            Name              = $TaskPath
            Type              = $HealthCheckType
            Status            = 'ERROR'
            LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment           = $error[0].Exception.Message
            ComputerName      = $ENV:COMPUTERNAME
        }
    }
}
