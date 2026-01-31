# Installation

## From PowerShell Gallery

The easiest way to install SystemChecks is from the PowerShell Gallery:

```powershell
# Install for current user
Install-Module -Name systemchecks -Scope CurrentUser

# Install for all users (requires admin/sudo)
Install-Module -Name systemchecks -Scope AllUsers
```

## From Source

You can also install SystemChecks directly from the GitHub repository:

```powershell
# Clone the repository
git clone https://github.com/mattman-ps/systemchecks.git
cd systemchecks

# Import the module
Import-Module .\src\systemchecks.psd1
```

## Verify Installation

After installation, verify that the module is loaded correctly:

```powershell
# Check if module is loaded
Get-Module -Name systemchecks

# View available commands
Get-Command -Module systemchecks
```

## Update

To update to the latest version:

```powershell
Update-Module -Name systemchecks
```

## Uninstall

To remove the module:

```powershell
Uninstall-Module -Name systemchecks
```
