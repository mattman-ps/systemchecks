#Requires -Version 5
<#
 .Synopsis
 Get status of a given URI.

 .Description
 Get status of a given URI.

 .Parameter

 .Example
Test-URIHealth -URI "\SLMPD\Send OnCallSchedule"
 #>
function Test-URIHealth {
    [CmdletBinding()]
    param (
        [string]$URI,
        [string]$SystemName,
        [string]$SystemDescription,
        [bool]$UseBasicParsing,
        [bool]$UseDefaultCredentials
    )

    $HealthCheckType = 'URI'

    try {
        $WebRequestSplat = @{
            URI                   = $URI
            UseBasicParsing       = $UseBasicParsing
            UseDefaultCredentials = $UseDefaultCredentials
        }
        $response = Invoke-WebRequest @WebRequestSplat
        if (!$null -eq $response) {
            if ($response.StatusCode -eq '200') {
                return [PSCustomObject]@{
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                    Name              = $URI
                    Type              = $HealthCheckType
                    Status            = 'OK'
                    LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                    Comment           = ""
                    ComputerName      = $ENV:COMPUTERNAME
                }
            }
            else {
                return [PSCustomObject]@{
                    SystemName        = $SystemName
                    SystemDescription = $SystemDescription
                    Name              = $URI
                    Type              = $HealthCheckType
                    Status            = $response.StatusDescription
                    LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                    Comment           = $response.StatusCode
                    ComputerName      = $ENV:COMPUTERNAME
                }
            }
        }
        else {
            return [PSCustomObject]@{
                SystemName        = $SystemName
                SystemDescription = $SystemDescription
                Name              = $URI
                Type              = $HealthCheckType
                Status            = 'ERROR'
                LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Comment           = $Error[0].Exception.Message
                ComputerName      = $ENV:COMPUTERNAME
            }
        }
    }
    catch {
        return [PSCustomObject]@{
            SystemName        = $SystemName
            SystemDescription = $SystemDescription
            Name              = $URI
            Type              = $HealthCheckType
            Status            = 'ERROR'
            LastUpdate        = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Comment           = $Error[0].Exception.Message
            ComputerName      = $ENV:COMPUTERNAME
        }
    }
}
