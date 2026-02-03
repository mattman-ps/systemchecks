# Usage Overview

This section provides an overview of how to use the SystemChecks module.

## Available Functions

SystemChecks provides the following functions for building health checks:

- **[Get-SystemHealth](../reference/functions.md#get-systemhealth)** - Orchestrates comprehensive health checks using JSON configuration files
- **[Test-ProcessHealth](../reference/functions.md#test-processhealth)** - Check if a process is running and responding
- **[Test-ServiceHealth](../reference/functions.md#test-servicehealth)** - Verify the status of Windows services
- **[Test-FileExists](../reference/functions.md#test-fileexists)** - Check if a file path exists
- **[Test-ShareExists](../reference/functions.md#test-shareexists)** - Verify if a network share path is accessible
- **[Test-ScheduledTask](../reference/functions.md#test-scheduledtask)** - Get the status of scheduled tasks
- **[Test-URIHealth](../reference/functions.md#test-urihealth)** - Check the health of web endpoints
- **[Test-TimeSync](../reference/functions.md#test-timesync)** - Compare time synchronization between systems
- **[Get-FileCount](../reference/functions.md#get-filecount)** - Get a count of files in a directory
- **[Get-Win32Error](../reference/functions.md#get-win32error)** - Look up detailed Windows error information

## Core Concepts

SystemChecks is built around the following concepts:

### Individual Health Checks

Each Test-* function performs a specific validation and returns a standardized result object containing the check status, name, type, and any relevant details.

### Orchestrated Checks

Use Get-SystemHealth with JSON configuration files to run multiple checks across different system components in a single operation.

### Result Objects

All health check functions return consistent PowerShell objects that can be filtered, exported, or processed further.

## Workflow

A typical SystemChecks workflow:

1. **Define** your checks (either individual function calls or JSON configuration)
2. **Execute** the checks using the appropriate function
3. **Review** the results (Status, Name, Type, etc.)
4. **Export** or **Report** findings as needed

## Module Structure

```
systemchecks/
├── src/
│   ├── classes/      # PowerShell classes
│   ├── public/       # Public exported functions
│   ├── private/      # Internal helper functions
│   └── resources/    # Additional resources
├── tests/            # Pester tests
├── example/          # Usage examples and config files
└── docs/             # Documentation source
```

## Getting Help

For detailed information about specific commands:

```powershell
# Get help for a specific command
Get-Help <CommandName> -Detailed

# List all available commands
Get-Command -Module systemchecks

# View examples for a function
Get-Help Test-ServiceHealth -Examples
```
