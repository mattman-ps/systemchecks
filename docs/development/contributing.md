# Contributing

Thank you for considering contributing to SystemChecks!

## How to Contribute

1. **Fork the repository** on GitHub
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Make your changes** with clear, descriptive commits
4. **Add tests** for new functionality
5. **Update documentation** as needed
6. **Push to your fork** (`git push origin feature/AmazingFeature`)
7. **Open a Pull Request**

## Development Setup

```powershell
# Clone your fork
git clone https://github.com/YOUR-USERNAME/systemchecks.git
cd systemchecks

# Import the module for development
Import-Module .\src\systemchecks.psd1
```

## Code Standards

- Follow [PowerShell best practices](https://poshcode.gitbook.io/powershell-practice-and-style/)
- Write clear, self-documenting code
- Include comment-based help for all public functions
- Use approved PowerShell verbs for function names

## Testing

All code must include appropriate Pester tests:

```powershell
# Run all tests
Invoke-Pester

# Run tests with coverage
Invoke-Pester -CodeCoverage '.\src\**\*.ps1'
```

## Documentation

- Update README.md for user-facing changes
- Add/update function documentation
- Include usage examples where appropriate

## Code Review Process

1. All submissions require review
2. Automated tests must pass
3. Code must follow style guidelines
4. Documentation must be updated

## Reporting Issues

- Use GitHub Issues
- Include clear reproduction steps
- Provide environment details (OS, PowerShell version)
- Include relevant error messages

## Questions?

Feel free to open an issue for questions or discussion!
