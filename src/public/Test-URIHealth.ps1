#Requires -Version 5
<#
 .Synopsis
 Test whether a web endpoint is reachable and returns HTTP 200.

 .Description
 Sends an HTTP request to the given URI using Invoke-WebRequest.  Returns 'OK'
 when the server responds with a 200 status code, or an error/status description
 when the response indicates a problem.  Exceptions (connection refused, DNS
 failure, etc.) are caught and returned as 'ERROR' results.

 .Parameter URI
 The full URI to request, e.g. 'http://server/health'.

 .Parameter SystemName
 Friendly name for the system this check belongs to (used in reporting).

 .Parameter SystemDescription
 Short description of the system (used in reporting).

 .Parameter UseBasicParsing
 Pass $true to use basic parsing (avoids IE engine dependency on servers without a GUI).

 .Parameter UseDefaultCredentials
 Pass $true to send the current user's Windows credentials with the request.

 .Example
Test-URIHealth -URI "http://server/health"
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
            Comment           = $_.Exception.Message
            ComputerName      = $ENV:COMPUTERNAME
        }
    }
}
