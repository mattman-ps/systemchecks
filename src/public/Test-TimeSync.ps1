#Requires -Version 5
<#
 .Synopsis
 Compare the current date/time on two remote systems.

 .Description
 Opens a temporary PSSession to each system, retrieves the current date/time,
 and calculates the difference as a TimeSpan.  Useful for spotting NTP drift
 between servers that need to stay in sync (e.g. domain controllers or cluster
 nodes).  If a session cannot be established, the affected system is reported
 as 'ERROR' and the difference is returned as 0.

 .Parameter System1Name
 Hostname or IP address of the first system.

 .Parameter System2Name
 Hostname or IP address of the second system.

 .Example
Test-TimeSync -System1Name "server1" -System2Name "server2" -Verbose
 #>
function Test-TimeSync {
    [CmdletBinding()]
    param (
        [string]$System1Name,
        [string]$System2Name
    )

    $HealthCheckType = 'TimeSync'

    $session1 = New-PSSession -ComputerName $System1Name -ErrorAction SilentlyContinue
    if ($session1) {
        Write-Verbose "Collecting current date/time from $System1Name"
        $timedate = Invoke-Command -Session $session1 -ScriptBlock { Get-Date }
        $System1DateTime = [PSCustomObject]@{
            SystemName     = $System1Name
            SystemDateTime = $timedate
            Status         = 'Success'
            Comment        = ''
        }
    }
    else {
        $System1DateTime = [PSCustomObject]@{
            SystemName     = $System1Name
            SystemDateTime = ''
            Status         = 'ERROR'
            Comment        = "Unable to establish a session with '$System1Name'"
        }
    }

    $session2 = New-PSSession -ComputerName $System2Name -ErrorAction SilentlyContinue
    if ($session2) {
        Write-Verbose "Collecting current date/time from $System2Name"
        $timedate = Invoke-Command -Session $session2 -ScriptBlock { Get-Date }
        $System2DateTime = [PSCustomObject]@{
            SystemName     = $System2Name
            SystemDateTime = $timedate
            Status         = 'Success'
            Comment        = ''
        }
    }
    else {
        $System2DateTime = [PSCustomObject]@{
            SystemName     = $System2Name
            SystemDateTime = ''
            Status         = 'ERROR'
            Comment        = "Unable to establish a session with '$System2Name'"
        }
    }
    if ($System1DateTime.Status -eq 'ERROR' -or $System2DateTime.Status -eq 'ERROR') {
        $DateTimeDifference = 0
        $Status = "ERROR"
    }
    else {
        $difference = New-TimeSpan -Start $System1DateTime.SystemDateTime -End $System2DateTime.SystemDateTime
        $DateTimeDifference = $difference
        $Status = 'Success'
    }
    $System1DateTime | Format-Table -AutoSize | Out-String | Write-Verbose
    $System2DateTime  | Format-Table -AutoSize | Out-String | Write-Verbose

    return [PSCustomObject]@{
        System1Name     = $System1Name
        System1DateTime = $System1DateTime.SystemDateTime
        System2Name     = $System2Name
        System2DateTime = $System2DateTime.SystemDateTime
        Type            = $HealthCheckType
        Status          = $Status
        Difference      = $DateTimeDifference
        LastUpdate      = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
        Comment         = @($System1DateTime.Comment,$System2DateTime.Comment)
    }
}
