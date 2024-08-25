<#
.SYNOPSIS
    Simple check to ensure that a URI is available
.DESCRIPTION
    Opinionated call to Invoke-WebRequest to ensure that a URI is responsive.
.EXAMPLE
    C:\PS>
    Example of how to use this cmdlet
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    systemchecks
#>
function Test-Uri {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Helpful Message')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Uri
    )
    $response = TestURI -TestUri $Uri
    return $response
}
