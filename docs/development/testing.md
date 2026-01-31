# Testing

SystemChecks uses Pester for comprehensive testing.

## Running Tests

### Run All Tests

```powershell
Invoke-Pester
```

### Run Specific Test File

```powershell
Invoke-Pester -Path .\tests\public\Get-SystemCheck.Tests.ps1
```

### Run with Coverage

```powershell
Invoke-Pester -CodeCoverage '.\src\**\*.ps1'
```

## Writing Tests

Tests should follow Pester best practices:

```powershell
Describe "Get-SystemCheck" {
    Context "When checking system health" {
        It "Returns expected results" {
            # Arrange
            $params = @{ Name = "TestCheck" }
            
            # Act
            $result = Get-SystemCheck @params
            
            # Assert
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
```

## Test Organization

- One test file per source file
- Use descriptive `Describe` and `Context` blocks
- Clear, focused `It` blocks
- Follow Arrange-Act-Assert pattern

## Coverage Goals

- Aim for 80%+ code coverage
- All public functions must have tests
- Test both success and failure paths
- Include edge cases

## Continuous Integration

Tests run automatically on:

- Every pull request
- Every commit to main branch
- Nightly builds

## Test Configuration

Test configuration is in `project.json`:

```json
"Pester": {
  "TestResult": {
    "Enabled": true,
    "OutputFormat": "NUnitXml"
  },
  "Output": {
    "Verbosity": "Detailed"
  }
}
```
