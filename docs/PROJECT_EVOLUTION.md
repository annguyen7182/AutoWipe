# AutoWipe Project Evolution

## Goal

AutoWipe was built to reduce manual effort and mistakes in high-volume HDD test/erase operations by turning repetitive GUI work in Hard Disk Sentinel into deterministic automation.

## Phase 1 - Port Mapping

- Problem: Operators could not quickly identify which physical slot matched Windows disk indices.
- Solution: Map `PNPDeviceID` strings to known rig port numbers.
- Outcome: Physical drive location became instant and repeatable.

## Phase 2 - Surface Test Tracking

- Problem: Operators still had to manually find the right Surface Test window among many open windows.
- Solution: Detect and bind active Surface Test windows to mapped ports.
- Outcome: One dashboard view for port, disk, progress, and active window state.

## Phase 3 - Automated Verdicts

- Problem: Human review of every window was too slow and error-prone.
- Solution: Use progress + log-length heuristics to assign PASS, FAILED, or CHECK.
- Outcome: Faster decisions with consistent criteria.

## Phase 4 - Batch Automation

- Problem: Click-heavy workflows (refresh, save, start wipe, close dialogs) still consumed operator time.
- Solution: Add scheduler-driven automation with batch windows and safe popup handling.
- Outcome: Reduced manual intervention during high-throughput runs.

## Phase 5 - Modular Refactor

- Problem: Monolithic scripts were hard to debug and risky to change.
- Solution: Split into focused modules with clear ownership and interfaces.
- Outcome: Better maintainability and safer future upgrades.

## Current Architecture (v4.5)

```text
autowipe_v4.5.ps1
|-- modules/core.ps1        # config, logging, CSV state, Win32 types
|-- modules/hds_control.ps1 # HDS process/window/control automation
|-- modules/watcher.ps1     # mapping, window binding, verdict engine
|-- modules/automation.ps1  # scheduler, batch timing, trigger logic
`-- modules/gui.ps1         # WinForms dashboard and control surface
```

## Operational Impact

- Faster setup and execution in multi-drive rigs.
- More consistent PASS/FAILED handling under load.
- Lower operator attention requirement per rig.
