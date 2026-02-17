# Changelog

All notable changes to this project are documented here.

## [4.5.0] - 2025-12-28

### Added

- Stable modular architecture across `core`, `hds_control`, `watcher`, `automation`, and `gui`.
- Snapshot-based popup cleanup in HDS control logic to avoid closing protected windows.
- Batch timing logic for Auto-Wipe and Auto-Save using newest-drive reset behavior.
- Lost-drive handling for interrupted wipe sessions.

### Changed

- GUI automation panel layout adjusted to separate timer and batch counters.
- Verdict logic tightened with explicit pass/fail text-length thresholds and failure streak confirmation.
- Logging and state tracing improved for operations debugging.

## [4.4.0] - 2025-12-20

### Added

- Auto-Clean periodic popup dismissal.

### Fixed

- Countdown format consistency for hour-level timers.
- Module existence checks during startup.

## [4.0.0] - 2025-11-15

### Added

- Initial modular refactor from monolith script.
- CSV persistence with `Port_Serial_Progress.csv`.

## [3.5.0] - 2025-10-01

### Added

- Report indexing cache for fast report presence checks.
- Reliable center-click behavior for Delphi controls.

## [2.0.0] - 2025-06-01

### Added

- Surface Test window tracking and binding.
- Initial traffic-light WinForms grid.

## [1.0.0] - 2025-02-01

### Added

- Physical port mapping using `PNPDeviceID` references.
