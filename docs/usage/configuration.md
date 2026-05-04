# Configuration Files

SystemChecks uses JSON configuration files to define comprehensive health check suites. This approach allows you to version-control your infrastructure validation logic and execute consistent checks across environments.

## JSON Schema Support

SystemChecks provides a JSON Schema that enables IntelliSense, autocomplete, and real-time validation in VS Code and other compatible editors.

### Adding Schema Support

To enable IntelliSense and validation, add the `$schema` property to your configuration file:

```json
{
  "$schema": "https://cdn.jsdelivr.net/gh/mattman-ps/systemchecks@v0.3.0/example/schema/system_schema.json",
  "systemName": "My System",
  "description": "Production server health checks",
  "Services": [
    {
      "name": "w3svc",
      "friendlyName": "IIS Web Server"
    }
  ]
}
```

### Schema Versioning

The schema is hosted via jsDelivr CDN for reliable, fast access worldwide.

**Recommended approach - Pin to a specific version:**
```
https://cdn.jsdelivr.net/gh/mattman-ps/systemchecks@v0.3.0/example/schema/system_schema.json
```

This ensures your configuration files remain compatible with the schema version you're using, preventing unexpected validation errors when the schema is updated.

**Alternative - Use latest from main branch:**
```
https://cdn.jsdelivr.net/gh/mattman-ps/systemchecks@main/example/schema/system_schema.json
```

This always points to the latest schema but may include breaking changes. Only use this if you want to automatically pick up new features.

## Configuration Structure

A configuration file consists of:

- **systemName** (required): A unique identifier for the system being checked
- **description** (optional): A description of the system or check suite
- **Check sections**: One or more arrays defining specific check types

## Available Check Types

### Services

Check Windows service status:

```json
{
  "Services": [
    {
      "name": "w3svc",
      "friendlyName": "IIS Web Server"
    },
    {
      "name": "BITS",
      "friendlyName": "Background Intelligent Transfer Service"
    }
  ]
}
```

### Processes

Verify processes are running:

```json
{
  "Processes": [
    {
      "name": "explorer",
      "friendlyName": "Windows Explorer"
    }
  ]
}
```

### FilesExist

Check if files or directories exist:

```json
{
  "FilesExist": [
    {
      "filePath": "C:/Windows/System32/drivers/etc/hosts",
      "friendlyName": "Hosts file"
    }
  ]
}
```

### SharesExist

Verify network share accessibility:

```json
{
  "SharesExist": [
    {
      "SharePath": "\\\\server\\share",
      "friendlyName": "Application share"
    }
  ]
}
```

### URIs

Check web endpoint health:

```json
{
  "URIs": [
    {
      "uri": "https://api.example.com/health",
      "friendlyName": "API Health Endpoint",
      "useBasicParsing": true,
      "useDefaultCredentials": false
    }
  ]
}
```

### ScheduledTasks

Verify scheduled task status:

```json
{
  "ScheduledTasks": [
    {
      "TaskPath": "\\Microsoft\\Windows\\Backup\\BackupTask",
      "friendlyName": "Daily Backup Task"
    }
  ]
}
```

### TimeSync

Compare time synchronization between systems:

```json
{
  "TimeSync": [
    {
      "System1Name": "dc01",
      "System2Name": "dc02",
      "friendlyName": "Domain Controller Time Sync"
    }
  ]
}
```

### FileCount

Count files in a directory with optional date-based subfolder support:

```json
{
  "FileCount": [
    {
      "FilePath": "C:/exports",
      "friendlyName": "Export file count",
      "appendLeaf": "Today",
      "leafFormat": "yyyyMMdd"
    }
  ]
}
```

## Complete Example

Here's a comprehensive configuration file:

```json
{
  "$schema": "https://cdn.jsdelivr.net/gh/mattman-ps/systemchecks@v0.3.0/example/schema/system_schema.json",
  "systemName": "Production Web Server",
  "description": "Health checks for web server infrastructure",
  "Services": [
    {
      "name": "w3svc",
      "friendlyName": "IIS Web Server"
    },
    {
      "name": "MSSQLSERVER",
      "friendlyName": "SQL Server"
    }
  ],
  "Processes": [
    {
      "name": "w3wp",
      "friendlyName": "IIS Worker Process"
    }
  ],
  "FilesExist": [
    {
      "filePath": "C:/inetpub/wwwroot/web.config",
      "friendlyName": "Web.config"
    }
  ],
  "URIs": [
    {
      "uri": "https://localhost/health",
      "friendlyName": "Application Health Check",
      "useBasicParsing": true,
      "useDefaultCredentials": false
    }
  ],
  "ScheduledTasks": [
    {
      "TaskPath": "\\Maintenance\\DatabaseBackup",
      "friendlyName": "Database Backup Task"
    }
  ]
}
```

## Running Configuration Files

Execute checks from a configuration file using `Get-SystemHealth`:

```powershell
# Run checks from a single file
Get-SystemHealth -ConfigFileName ".\configs\webserver.json"

# Run checks from multiple files
Get-SystemHealth -ConfigFileName ".\configs\webserver.json",".\configs\database.json"

# Filter to failed checks only
Get-SystemHealth -ConfigFileName ".\configs\webserver.json" |
    Where-Object { $_.Status -notin @('OK','Exists','Responding') }
```

## Best Practices

1. **Use version control**: Store configuration files in Git alongside your infrastructure code
2. **Pin schema versions**: Use version-pinned schema URLs in production configurations
3. **Add friendly names**: Always include descriptive `friendlyName` properties for clarity in reports
4. **Organize by environment**: Create separate configuration files for dev, staging, and production
5. **Document expectations**: Use the `description` field to explain what the checks validate
6. **Test configurations**: Validate your JSON files before deployment to catch syntax errors early

## See Also

- [Usage Examples](examples.md)
- [Function Reference](../reference/functions.md)
- [Example Configuration](https://github.com/mattman-ps/systemchecks/blob/main/example/example-1.json)
