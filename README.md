# SystemChecks

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/systemchecks)](https://www.powershellgallery.com/packages/systemchecks)
[![License](https://img.shields.io/github/license/mattman-ps/systemchecks)](https://github.com/mattman-ps/systemchecks/blob/main/LICENSE)
[![Tests](https://img.shields.io/github/actions/workflow/status/mattman-ps/systemchecks/tests.yml?label=tests)](https://github.com/mattman-ps/systemchecks/actions/workflows/tests.yml)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue)](https://mattman-ps.github.io/systemchecks/)

A PowerShell module for building comprehensive system checks and health validations. SystemChecks provides a framework for creating, organizing, and executing diagnostic checks across various system components and infrastructure.

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

SystemChecks is designed to help system administrators, DevOps engineers, and IT professionals build robust validation frameworks for their infrastructure. Whether you're validating server configurations, checking application health, or monitoring system resources, SystemChecks provides the building blocks to create reliable and reusable check definitions.

## ✨ Features

- **Modular Design**: Build reusable check components that can be combined and extended
- **Flexible Framework**: Support for various types of system validations
- **PowerShell Native**: Leverages PowerShell 7.4+ features for modern scripting
- **Extensible**: Easy to extend with custom check types and validators
- **Well-Tested**: Comprehensive test coverage using Pester

## 📋 Requirements

- **PowerShell**: 7.4 or higher
- **Operating System**: Windows
- **Dependencies**: [Microsoft Error Lookup Tool](https://learn.microsoft.com/en-us/windows/win32/debug/system-error-code-lookup-tool)

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

# Create a basic system check
# (Examples will be updated as the module develops)

# Execute system checks
# Invoke-SystemCheck -Name "ServerHealthCheck"
```

## 💡 Usage Examples

### Example 1: Basic Health Check

```powershell
# Define a basic health check
# (Placeholder - will be updated with actual API)
```

### Example 2: Custom Validation

```powershell
# Create custom validation logic
# (Placeholder - will be updated with actual API)
```

### Example 3: Batch Checks

```powershell
# Run multiple checks
# (Placeholder - will be updated with actual API)
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
- Module designed using [ModuleTools](https://github.com/belibug/ModuleTools)
- Testing powered by [Pester](https://pester.dev/)
- Documentation generated with [MkDocs](https://www.mkdocs.org/)

---

**Note**: This module is currently in early development (v0.0.1). APIs and features are subject to change. Please check the [CHANGELOG](CHANGELOG.md) for the latest updates.
