#Requires -Version 5
<#
 .Synopsis
 This function calls the error lookup tool to get detailed information about an error.

 .Description
 This function is intended to be used with Get-SystemHealth and relies on $ScriptDirectory for proper function.

 Requires the Microsoft Error Lookup Tool (err.exe), included in the project.  For details
 on error lookup tool see article:
 https://www.microsoft.com/en-us/download/details.aspx?id=100432&msockid=2fd802363d216c82121f16d63c406d64

 The tool can also be installed by using winget (winget install Microsoft.err).  This function expects
 the tool is NOT installed and runs it from the project folder.

 NOTE:  By default, this function checks errors against the winerror.h file.

 .Parameter

 .Example
 Get-Win32Error 0x80070005 # Access Denied error
 #>
function Get-Win32Error {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int]$ErrorCode
    )

    # Path to the Error Lookup Tool executable
    $errExe = Join-Path -Path $ScriptDirectory -ChildPath "Includes\err.exe"

    Write-Verbose "Error Tool Path: {$errExe}"

    # Check if the executable exists
    if (!(Test-Path $errExe)) {
        Write-Error "Error Lookup Tool not found at $errExe"
        return
    }

    # Run the tool and capture output
    $output = & $errExe "/winerror.h" $ErrorCode

    # Parse the output and return the message
    # this is a rough parse
    if ($output -match "winerror.h") {
        $returnvalue = $output -join " "
        $returnvalue = $returnvalue -replace "#", '`r`n'
        return $returnvalue
    }
    else {
        return "Error code not found"
    }
}
