# PROJECT_STATE

## Current goal (1-2 lines)

- Keep AutoWipe v4.5 behavior stable while standardizing cross-agent handoff through a shared context spine.

## Working assumptions

- Runtime target remains Windows 10/11 with PowerShell 5.1 and Hard Disk Sentinel Pro.
- The repository root is the canonical source of implementation and docs state.
- Agents (Claude/Codex/Gemini) read `.context/*` before implementation work.
- Agent precedence for conflict resolution is Claude -> Codex -> Gemini.
- Completed handoffs must include `Signed-By: <Claude|Codex|Gemini>`.

## Active tasks (ranked)

1. [x] Bootstrap shared `.context/` files for multi-agent continuity.
2. [x] Define agent precedence as Claude -> Codex -> Gemini.
3. [x] Enforce signed handoffs with `Signed-By` footer.
4. [ ] Keep `.context/TASKS.md` synchronized with active and completed work.
5. [ ] Record behavior/interface decisions in `.context/DECISIONS.md` before contract changes.

## Interfaces / contracts (must not break)

- Entry points: `autowipe_v4.5.ps1` and `autowipe_v4.5.bat`.
- Module boundaries: `modules/core.ps1`, `modules/hds_control.ps1`, `modules/watcher.ps1`, `modules/automation.ps1`, `modules/gui.ps1`.
- Mapping input path: `C:\HDMapping\Port_Reference.csv`.
- Hard Disk Sentinel executable path assumption: `C:\Program Files (x86)\Hard Disk Sentinel\HDSentinel.exe`.

## Recent changes (last 24h)

- (working tree) Added initial `.context/` context spine files for shared agent memory.
- (working tree) Updated multi-agent workflow docs to require `.context` startup and handoff updates.
- (working tree) Added explicit agent precedence (Claude -> Codex -> Gemini) and required handoff signatures.
