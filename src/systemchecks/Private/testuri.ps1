<#
.SYNOPSIS
    Perform a simple true/false check on a given URI.
.DESCRIPTION
    Use .NET to check for a given URI.
.EXAMPLE
    C:\PS>
    Example of how to use this cmdlet
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (true/false)
.NOTES
    TODO required .NET framework.  Need to find a different way to make this cross platform.
.COMPONENT
    systemchecks
#>
function TestUri {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Helpful Message')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$TestURI
    )

    [System.Uri]::IsWellFormedUriString($TestURI, [System.UriKind]::Absolute)
}
