# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Add support for remote checks (pass a ComputerName to the individual Test-* functions)
- Output formatting helper for console display

## [0.0.1]

### Added

- Initial release.
- `Get-SystemHealth` — orchestrates all checks from a JSON config file
- `Test-ProcessHealth`, `Test-ServiceHealth`, `Test-FileExists`, `Test-ShareExists` — basic system checks
- `Test-URIHealth` — HTTP endpoint check
- `Test-ScheduledTask` — scheduled task last-run status using Get-Win32Error for error code lookup
- `Get-FileCount` — file count with optional date-based sub-folder appending
- `Test-TimeSync` — cross-system time drift check using PSSessions
- `Get-Win32Error` — Windows error code lookup via err.exe

### Fixed

- `Get-SystemHealth`: URIs, ScheduledTasks, and FileCount check loops were incorrectly nested inside the SharesExist loop, causing them to run once per share entry and output the results file prematurely
- `Test-TimeSync`: status comparison was case-sensitive (`'error'` vs `'ERROR'`), causing connection failures to be silently ignored when calculating the time difference
