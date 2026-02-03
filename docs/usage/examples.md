# Usage Examples

Practical examples for using SystemChecks.

## Get-SystemHealth

Run comprehensive health checks using a JSON configuration file:

```powershell
Get-SystemHealth -ConfigFileName ".\config_files\system1.json", ".\config_files\system2.json"
```

## Test-ProcessHealth

Check if a process is running and responding:

```powershell
Test-ProcessHealth -ProcessName "explorer"
```

## Test-ServiceHealth

Verify the status of a Windows service:

```powershell
Test-ServiceHealth -ServiceName 'w3svc'
```

## Test-FileExists

Check if a file path exists:

```powershell
Test-FileExists -FilePath "c:\my\file"
```

## Test-ShareExists

Verify if a network share path is accessible:

```powershell
Test-ShareExists -SharePath "\\server\e$"
```

## Test-ScheduledTask

Get the status of a scheduled task:

```powershell
Test-ScheduledTask -TaskPath "\Tasks\Send Email"
```

## Test-URIHealth

Check the health of a web endpoint:

```powershell
Test-URIHealth -URI "http://server/health"
```

## Test-TimeSync

Compare time synchronization between two systems:

```powershell
Test-TimeSync -System1Name "server1" -System2Name "server2" -Verbose
```

## Get-FileCount

Get a count of files in a directory:

```powershell
Get-FileCount -FilePath "c:\my\folder"
```

## Get-Win32Error

Look up detailed Windows error information:

```powershell
Get-Win32Error 0x80070005  # Access Denied error
```

## More Examples

Check the [examples directory](https://github.com/mattman-ps/systemchecks/tree/main/example) in the repository for working code samples and configuration files.
