# ARCHITECTURE

## System shape

- AutoWipe is a Windows PowerShell automation application for high-volume drive testing and wipe workflows via Hard Disk Sentinel (HDS).
- Entry script `autowipe_v4.5.ps1` coordinates module loading and runtime orchestration.
- Launcher `autowipe_v4.5.bat` provides elevated startup flow for operators.

## Module responsibilities

- `modules/core.ps1`: shared state, constants, common helpers, startup wiring support.
- `modules/hds_control.ps1`: HDS process/window integration and command dispatch.
- `modules/watcher.ps1`: disk/port observation and verdict computation logic.
- `modules/automation.ps1`: timer-driven batch actions (refresh/report/wipe/popup cleanup).
- `modules/gui.ps1`: dashboard rendering and operator-facing interactions.

## Data and control contracts

- Port identity depends on `C:\HDMapping\Port_Reference.csv` and must remain backward compatible.
- Verdict states and grid color semantics are operational contracts for rig operators.
- Popup cleanup must remain guard-railed to avoid closing critical HDS windows.
- Module boundaries should remain explicit; avoid cross-module coupling that bypasses existing interfaces.

## Change guidance

- If behavior changes affect operator workflow, log a decision in `.context/DECISIONS.md` before implementation.
- Keep changes small and verifiable; update `.context/PROJECT_STATE.md` and `.context/TASKS.md` after completion.
