# Usage Overview

This section provides an overview of how to use the SystemChecks module.

## Core Concepts

SystemChecks is built around the following concepts:

### Checks

Individual validation units that test specific conditions or configurations.

### Validators

Components that evaluate check results and determine pass/fail status.

### Reporters

Output formatters that present check results in various formats.

## Workflow

A typical SystemChecks workflow:

1. **Define** your checks
2. **Execute** the checks
3. **Review** the results
4. **Report** findings

## Module Structure

```
systemchecks/
├── Classes/      # PowerShell classes for check definitions
├── Public/       # Public exported functions
├── Private/      # Internal helper functions
└── Resources/    # Configuration and data files
```

## Getting Help

For detailed information about specific commands:

```powershell
# Get help for a specific command
Get-Help <CommandName> -Detailed

# List all available commands
Get-Command -Module systemchecks
```
