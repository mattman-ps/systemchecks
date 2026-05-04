# Quick Start

Get started with SystemChecks in minutes.

## Import the Module

```powershell
Import-Module systemchecks
```

## View Available Commands

```powershell
Get-Command -Module systemchecks
```

## Run Your First Check

```powershell
# Check if a Windows service is running
Test-ServiceHealth -ServiceName 'w3svc'

# Verify a file exists
Test-FileExists -FilePath "c:\my\file"

# Check a web endpoint
Test-URIHealth -URI "http://server/health"
```

## Run Comprehensive Health Checks

Use a JSON configuration file to orchestrate multiple checks:

```powershell
Get-SystemHealth -ConfigFileName ".\config_files\system1.json"
```

### Using JSON Schema for IntelliSense

Add the `$schema` property to your configuration files for autocomplete and validation in VS Code:

```json
{
  "$schema": "https://cdn.jsdelivr.net/gh/mattman-ps/systemchecks@v0.3.0/example/schema/system_schema.json",
  "systemName": "My System",
  "Services": [
    {
      "name": "w3svc"
    }
  ]
}
```

Learn more about [configuration files](../usage/configuration.md).

## Available Functions

SystemChecks provides these core functions:

- **Get-SystemHealth** - Orchestrate comprehensive health checks
- **Test-ProcessHealth** - Check process status
- **Test-ServiceHealth** - Verify Windows services
- **Test-FileExists** - Check file existence
- **Test-ShareExists** - Verify network shares
- **Test-ScheduledTask** - Check scheduled tasks
- **Test-URIHealth** - Test web endpoints
- **Test-TimeSync** - Compare time sync between systems
- **Get-FileCount** - Count files in directories
- **Get-Win32Error** - Look up Windows errors

## Next Steps

- Explore [Usage Examples](../usage/examples.md)
- Review the [API Reference](../reference/functions.md)
- Learn about [Contributing](../development/contributing.md)
