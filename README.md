# SystemChecks

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/systemchecks)](https://www.powershellgallery.com/packages/systemchecks)
[![License](https://img.shields.io/github/license/mattman-ps/systemchecks)](https://github.com/mattman-ps/systemchecks/blob/main/LICENSE)
[![Tests](https://img.shields.io/github/actions/workflow/status/mattman-ps/systemchecks/tests.yml?label=tests)](https://github.com/mattman-ps/systemchecks/actions/workflows/tests.yml)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue)](https://mattman-ps.github.io/systemchecks/)

A PowerShell module for running repeatable system health checks across Windows infrastructure.  I got tired of writing one-off diagnostic scripts that lived in random folders and couldn't be reused, so I packaged the patterns I kept reaching for into a proper module.

## 📑 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage Examples](#-usage-examples)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [Changelog](#-changelog)
- [License](#-license)
- [Author](#-author)

## 🔍 Overview

SystemChecks lets you describe what a healthy system looks like in a JSON file, which services should be running, which files should exist, which web endpoints should return 200 and then run all of those checks in one go.  Results come back as a flat list of objects that you can filter, export, or feed into whatever alerting pipeline you use.

## ✨ Features

- **JSON-driven checks**: Define checks in a config file rather than writing a new script every time
- **Consistent output shape**: Every check returns the same properties, so piping to `Where-Object`, `Export-Csv`, etc. always works the same way
- **PowerShell Native**: Leverages PowerShell 7.4+ features for modern scripting
- **Individual functions available**: You can also call any check function directly without a config file
- **Pester-tested**: Functions have unit tests covering both happy-path and error scenarios

## 📋 Requirements

- **PowerShell**: 7.4 or higher
- **Operating System**: Windows
- **Dependencies**: [Microsoft Error Lookup Tool](https://learn.microsoft.com/en-us/windows/win32/debug/system-error-code-lookup-tool) (required only for `Get-Win32Error` / scheduled task error code lookup)

## 📦 Installation

### From PowerShell Gallery

```powershell
# Install for current user
Install-Module -Name systemchecks -Scope CurrentUser

# Install for all users (requires admin/sudo)
Install-Module -Name systemchecks -Scope AllUsers
```

### From Source

```powershell
# Clone the repository
git clone https://github.com/mattman-ps/systemchecks.git
cd systemchecks

# Import the module
Import-Module .\src\systemchecks.psd1
```

### Verify Installation

```powershell
# Check module is loaded
Get-Module -Name systemchecks

# View available commands
Get-Command -Module systemchecks
```

## 🚀 Quick Start

```powershell
# Import the module
Import-Module systemchecks

# View available commands
Get-Command -Module systemchecks

# Run a simple health check
Test-ServiceHealth -ServiceName 'w3svc'

# Run checks from a config file and filter to anything not OK
Get-SystemHealth -ConfigFileName ".\config_files\system1.json" |
    Where-Object { $_.Status -notin @('OK','Exists','Responding') }
```

## 📋 Available Functions

SystemChecks provides the following functions for building health checks:

- **[Get-SystemHealth](#get-systemhealth)** - Orchestrates all checks defined in one or more JSON config files
- **[Test-ProcessHealth](#test-processhealth)** - Check if a process is running and responding
- **[Test-ServiceHealth](#test-servicehealth)** - Verify the running status of a Windows service
- **[Test-FileExists](#test-fileexists)** - Check if a file or directory path exists
- **[Test-ShareExists](#test-shareexists)** - Verify if a UNC share or drive path is accessible
- **[Test-ScheduledTask](#test-scheduledtask)** - Get the last-run status of a scheduled task
- **[Test-URIHealth](#test-urihealth)** - Check that a web endpoint returns HTTP 200
- **[Test-TimeSync](#test-timesync)** - Compare the date/time on two remote systems to spot NTP drift
- **[Get-FileCount](#get-filecount)** - Count files in a directory (supports date-based sub-folders)
- **[Get-Win32Error](#get-win32error)** - Look up a human-readable description for a Windows error code

## 💡 Usage Examples

### Get-SystemHealth

Run all checks defined in a config file and show anything that isn't healthy:

```powershell
Get-SystemHealth -ConfigFileName ".\config_files\system1.json" |
    Where-Object { $_.Status -notin @('OK','Exists','Responding') } |
    Format-Table SystemName, Name, Type, Status, Comment -AutoSize
```

### Test-ProcessHealth

Check if a process is running and responding:

```powershell
Test-ProcessHealth -ProcessName "explorer"
```

### Test-ServiceHealth

Verify the status of a Windows service:

```powershell
Test-ServiceHealth -ServiceName 'w3svc'
```

### Test-FileExists

Check if a file path exists:

```powershell
Test-FileExists -FilePath "c:\my\file"
```

### Test-ShareExists

Verify if a network share path is accessible:

```powershell
Test-ShareExists -SharePath "\\server\e$"
```

### Test-ScheduledTask

Get the status of a scheduled task:

```powershell
Test-ScheduledTask -TaskPath "\Tasks\Send Email"
```

### Test-URIHealth

Check the health of a web endpoint:

```powershell
Test-URIHealth -URI "http://server/health"
```

### Test-TimeSync

Compare time synchronization between two systems:

```powershell
Test-TimeSync -System1Name "server1" -System2Name "server2" -Verbose
```

### Get-FileCount

Get a count of files in a directory:

```powershell
Get-FileCount -FilePath "c:\my\folder"

# Count files in today's dated sub-folder (e.g. c:\exports\20260308)
Get-FileCount -FilePath "c:\exports" -AppendLeaf Today -LeafFormat yyyyMMdd
```

### Get-Win32Error

Look up detailed Windows error information:

```powershell
Get-Win32Error 0x80070005  # Access Denied error
```

## 📚 Documentation

Full documentation is available at the project's [documentation site](https://mattman-ps.github.io/systemchecks/) (powered by MkDocs).

### Building Documentation Locally

```powershell
# Install MkDocs
pip install mkdocs

# Serve documentation locally
mkdocs serve

# Build static documentation
mkdocs build
```

## 🛠️ Development

### Project Structure

```none
systemchecks/
├── src/              # Module source code
│   ├── classes/      # PowerShell classes
│   ├── private/      # Private functions
│   ├── public/       # Public/exported functions
│   └── resources/    # Additional resources
├── tests/            # Pester tests
├── example/          # Usage examples
├── docs/             # Documentation source
└── assets/           # Project assets
```

### Running Tests

```powershell
# Run all tests
Invoke-Pester

# Run tests with coverage
Invoke-Pester -CodeCoverage '.\src\**\*.ps1'
```

### Building the Module

This project uses a custom build system. See [project.json](project.json) for configuration details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code:

- Follows PowerShell best practices
- Includes appropriate Pester tests
- Updates documentation as needed
- Follows the existing code style

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

## 📄 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## 👤 Author

- GitHub: [@mattman-ps](https://github.com/mattman-ps)
- Project Link: [https://github.com/mattman-ps/systemchecks](https://github.com/mattman-ps/systemchecks)

## 🙏 Acknowledgments

- Built with PowerShell 7.4+
- Module scaffolded using [ModuleTools](https://github.com/belibug/ModuleTools)
- Testing powered by [Pester](https://pester.dev/)
- Documentation generated with [MkDocs](https://www.mkdocs.org/)

---

**Note**: This module is currently in early development (v0.0.1). APIs and features are subject to change. Please check the [CHANGELOG](CHANGELOG.md) for the latest updates.

