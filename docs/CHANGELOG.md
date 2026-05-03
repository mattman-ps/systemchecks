# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- TBD

## [0.2.0] - 2026-05-03

### Added

- `Get-SystemHealth`: added support for `TimeSync` config entries to run `Test-TimeSync` checks from JSON definitions
- Pester coverage for `Get-SystemHealth` to verify `TimeSync` entries call `Test-TimeSync` with expected parameters

### Changed

- Module version bumped to `0.2.0` across project metadata, manifest, tests, and documentation

## [0.0.1]

### Added

- Initial release.
