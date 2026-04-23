# Changelog

All notable changes to this project will be documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/).
Versioning follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.1] - 2026-04-23

### Changed
- Refactored active directory extraction to safely resolve paths via `IOTAProject.FileName` (#2).

### Fixed
- Fixed memory leak in plugin finalization by safely releasing `IOTAProjectMenuItemCreatorNotifier` (#2).
- Resolved SonarQube code smells related to swallowed exceptions, empty methods, and interface mixing (#2).

### Removed
- Removed `ProjectsManagerPlus.Menu.pas` and unreliable `GetCurrentDir` references (#2).

---

## [0.1.0] - YYYY-MM-DD

### Added
- Initial project version.