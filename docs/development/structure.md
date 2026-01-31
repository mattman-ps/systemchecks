# Project Structure

Understanding the SystemChecks project layout.

## Directory Structure

```
systemchecks/
├── .github/          # GitHub Actions workflows
├── assets/           # Project assets (logos, images)
├── docs/             # MkDocs documentation source
├── example/          # Usage examples
├── src/              # Module source code
│   ├── classes/      # PowerShell classes
│   ├── private/      # Private functions
│   ├── public/       # Public/exported functions
│   └── resources/    # Additional resources
├── tests/            # Pester tests
├── CHANGELOG.md      # Version history
├── LICENSE           # License file
├── mkdocs.yml        # Documentation configuration
├── project.json      # Project metadata
└── README.md         # Project readme
```

## Source Code Organization

### Classes

PowerShell classes that define the core types and structures used throughout the module.

### Public Functions

Exported functions that form the public API of the module. These are available to users after importing the module.

### Private Functions

Internal helper functions used by public functions. Not exported to users.

### Resources

Configuration files, data files, templates, and other assets used by the module.

## Build System

This project uses a custom build system configured in `project.json`. The build process:

1. Compiles source files
2. Runs tests
3. Generates module manifest
4. Creates distribution package

## Testing

Tests are organized in the `tests/` directory, mirroring the `src/` structure:

```
tests/
├── classes/
├── private/
└── public/
```
