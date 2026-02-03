# Function Reference

Complete API reference for SystemChecks functions.

## Available Functions

SystemChecks provides the following functions for building health checks:

- **Get-SystemHealth** - Orchestrates comprehensive health checks using JSON configuration files
- **Test-ProcessHealth** - Check if a process is running and responding
- **Test-ServiceHealth** - Verify the status of Windows services
- **Test-FileExists** - Check if a file path exists
- **Test-ShareExists** - Verify if a network share path is accessible
- **Test-ScheduledTask** - Get the status of scheduled tasks
- **Test-URIHealth** - Check the health of web endpoints
- **Test-TimeSync** - Compare time synchronization between systems
- **Get-FileCount** - Get a count of files in a directory
- **Get-Win32Error** - Look up detailed Windows error information

## Get-SystemHealth

Run comprehensive health checks using a JSON configuration file.

**Syntax:**

```powershell
Get-SystemHealth -ConfigFileName <String[]>
```

**Example:**

```powershell
Get-SystemHealth -ConfigFileName ".\config_files\system1.json", ".\config_files\system2.json"
```

## Test-ProcessHealth

Check if a process is running and responding.

**Syntax:**

```powershell
Test-ProcessHealth -ProcessName <String> [-SystemName <String>] [-SystemDescription <String>]
```

**Example:**

```powershell
Test-ProcessHealth -ProcessName "explorer"
```

## Test-ServiceHealth

Verify the status of a Windows service.

**Syntax:**

```powershell
Test-ServiceHealth -ServiceName <String> [-SystemName <String>] [-SystemDescription <String>]
```

**Example:**

```powershell
Test-ServiceHealth -ServiceName 'w3svc'
```

## Test-FileExists

Check if a file path exists.

**Syntax:**

```powershell
Test-FileExists -FilePath <String> [-SystemName <String>] [-SystemDescription <String>]
```

**Example:**

```powershell
Test-FileExists -FilePath "c:\my\file"
```

## Test-ShareExists

Verify if a network share path is accessible.

**Syntax:**

```powershell
Test-ShareExists -SharePath <String> [-SystemName <String>] [-SystemDescription <String>]
```

**Example:**

```powershell
Test-ShareExists -SharePath "\\server\e$"
```

## Test-ScheduledTask

Get the status of a scheduled task.

**Syntax:**

```powershell
Test-ScheduledTask -TaskPath <String> [-SystemName <String>] [-SystemDescription <String>]
```

**Example:**

```powershell
Test-ScheduledTask -TaskPath "\Tasks\Send Email"
```

## Test-URIHealth

Check the health of a web endpoint.

**Syntax:**

```powershell
Test-URIHealth -URI <String> [-SystemName <String>] [-SystemDescription <String>] [-UseBasicParsing <Boolean>] [-UseDefaultCredentials <Boolean>]
```

**Example:**

```powershell
Test-URIHealth -URI "http://server/health"
```

## Test-TimeSync

Compare time synchronization between two systems.

**Syntax:**

```powershell
Test-TimeSync -System1Name <String> -System2Name <String>
```

**Example:**

```powershell
Test-TimeSync -System1Name "server1" -System2Name "server2" -Verbose
```

## Get-FileCount

Get a count of files in a directory.

**Syntax:**

```powershell
Get-FileCount -FilePath <String> [-SystemName <String>] [-SystemDescription <String>] [-AppendLeaf <String>] [-LeafFormat <String>]
```

**Example:**

```powershell
Get-FileCount -FilePath "c:\my\folder"
```

## Get-Win32Error

Look up detailed Windows error information.

**Syntax:**

```powershell
Get-Win32Error -ErrorCode <Int32>
```

**Example:**

```powershell
Get-Win32Error 0x80070005  # Access Denied error
```

## Get-Help

For detailed help on any function:

```powershell
Get-Help <FunctionName> -Detailed
Get-Help <FunctionName> -Examples
Get-Help <FunctionName> -Full
```

## List All Functions

```powershell
Get-Command -Module systemchecks
```
