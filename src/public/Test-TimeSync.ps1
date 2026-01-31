#Requires -Version 5
<#
 .Synopsis
 Analyze different components of a system.

 .Description
 Analyze different components of a system. A system can be any collection of items to check.

 .Parameter

 .Example
Test-TimeSync -System1Name "netviewer1" -System2Name "cad1" -Verbose
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
    if ($System1DateTime.Status -eq 'error' -or $System2DateTime.Status -eq 'error') {
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
