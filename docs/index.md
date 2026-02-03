# SystemChecks

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/systemchecks)](https://www.powershellgallery.com/packages/systemchecks)
[![License](https://img.shields.io/github/license/mattman-ps/systemchecks)](https://github.com/mattman-ps/systemchecks/blob/main/LICENSE)
[![Tests](https://img.shields.io/github/actions/workflow/status/mattman-ps/systemchecks/tests.yml?label=tests)](https://github.com/mattman-ps/systemchecks/actions/workflows/tests.yml)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue)](https://mattman-ps.github.io/systemchecks/)

A PowerShell module for building comprehensive system checks and health validations. SystemChecks provides a framework for creating, organizing, and executing diagnostic checks across various system components and infrastructure.

## Overview

SystemChecks is designed to help system administrators, DevOps engineers, and IT professionals build robust validation frameworks for their infrastructure. Whether you're validating server configurations, checking application health, or monitoring system resources, SystemChecks provides the building blocks to create reliable and reusable check definitions.

## Features

- **Modular Design**: Build reusable check components that can be combined and extended
- **Flexible Framework**: Support for various types of system validations
- **PowerShell Native**: Leverages PowerShell 7.4+ features for modern scripting
- **Extensible**: Easy to extend with custom check types and validators
- **Well-Tested**: Comprehensive test coverage using Pester

## Requirements

- **PowerShell**: 7.4 or higher
- **Operating System**: Windows
- **Dependencies**: [Microsoft Error Lookup Tool](https://learn.microsoft.com/en-us/windows/win32/debug/system-error-code-lookup-tool)

## Available Functions

SystemChecks provides the following functions for building health checks:

- **[Get-SystemHealth](reference/functions.md#get-systemhealth)** - Orchestrates comprehensive health checks using JSON configuration files
- **[Test-ProcessHealth](reference/functions.md#test-processhealth)** - Check if a process is running and responding
- **[Test-ServiceHealth](reference/functions.md#test-servicehealth)** - Verify the status of Windows services
- **[Test-FileExists](reference/functions.md#test-fileexists)** - Check if a file path exists
- **[Test-ShareExists](reference/functions.md#test-shareexists)** - Verify if a network share path is accessible
- **[Test-ScheduledTask](reference/functions.md#test-scheduledtask)** - Get the status of scheduled tasks
- **[Test-URIHealth](reference/functions.md#test-urihealth)** - Check the health of web endpoints
- **[Test-TimeSync](reference/functions.md#test-timesync)** - Compare time synchronization between systems
- **[Get-FileCount](reference/functions.md#get-filecount)** - Get a count of files in a directory
- **[Get-Win32Error](reference/functions.md#get-win32error)** - Look up detailed Windows error information

## Quick Links

- [Installation](getting-started/installation.md)
- [Quick Start](getting-started/quickstart.md)
- [Usage Examples](usage/examples.md)
- [API Reference](reference/functions.md)
- [Contributing](development/contributing.md)
- [Changelog](CHANGELOG.md)

## Project Status

This module is currently in early development (v0.0.1). APIs and features are subject to change. Please check the [CHANGELOG](CHANGELOG.md) for the latest updates.

## Support

- [GitHub Issues](https://github.com/mattman-ps/systemchecks/issues)
- [Project Repository](https://github.com/mattman-ps/systemchecks)

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE.md) file.
