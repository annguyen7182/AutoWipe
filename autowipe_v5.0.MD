# Fleet Web Control Plane for 15 AutoWipe Machines (v1)

## Summary
Build a central local web app on your Proxmox VM that monitors all 15 rigs and sends control commands to each rig.
Keep current AutoWipe logic intact and add a sidecar control path, not a headless rewrite.

## Final Decisions Locked
- Architecture: `Central Control Plane + Machine Agent + In-App Local Control API`.
- Rollout goal: `All 15 machines at once` after one pre-flight validation cycle.
- Control scope v1: `Everything available at machine level` (full machine controls).
- Freshness target: `5s near-realtime`.
- Auth: `Local login + roles + audit trail`.
- Destructive command guard: `Single confirmation modal` (per wipe-first preference).
- Stack defaults chosen: `Node.js + TypeScript + Postgres` on Proxmox VM.
- Integration mode: `Sidecar`, no headless core rewrite in v1.

## Why Not Headless Core in v1
- Headless core means refactoring all current WinForms/state/timer logic into a backend engine first.
- That is a separate large project and slows delivery.
- Sidecar approach ships faster and reuses stable production behavior now.

## Target Architecture
- Central VM runs:
- `control-api` (Node/TS backend).
- `control-web` (React dashboard).
- `postgres` (state, command queue, audit).
- Each rig runs:
- Existing `autowipe_v4.5.ps1` app.
- New lightweight `autowipe-agent` Windows Service.
- New local-only control endpoint inside AutoWipe process (`http://127.0.0.1:<port>`).

## Data and Command Flow
- Telemetry flow:
- AutoWipe in-process endpoint exposes snapshot of current machine and 24-port state.
- Agent polls local endpoint every 5s and posts heartbeat to central API.
- Central backend updates DB and pushes UI updates via websocket.
- Command flow:
- Operator clicks command in web UI.
- Backend writes command to queue table.
- Agent polls queue every 2s, claims command, forwards to local AutoWipe endpoint.
- AutoWipe executes command on UI thread, returns result.
- Agent reports completion/failure plus logs back to central.

## Public Interfaces and Contracts

### 1) Machine -> Central API
- `POST /api/v1/agents/heartbeat`
- Payload fields:
- `machineId`, `hostname`, `agentVersion`, `appRunning`, `hdsStatus`, `lastSeenUtc`.
- `summary`: `detectedDrives`, `passCount`, `failedCount`, `checkCount`, `missingCount`.
- `ports`: array of 24 entries with `port`, `serialNorm`, `diskIndex`, `healthPct`, `progress`, `verdict`, `reportPresent`.
- `automation`: all toggle states and countdown/batch counters.

### 2) Central -> Machine Commands
- `GET /api/v1/agents/{machineId}/commands?limit=10`
- `POST /api/v1/agents/{machineId}/commands/{commandId}/ack`
- `POST /api/v1/agents/{machineId}/commands/{commandId}/result`
- Command types:
- `app.start`, `app.stop`, `app.restart`.
- `watcher.check`, `hds.refresh`, `hds.save_reports`, `hds.wipe_batch`.
- `automation.set` with explicit fields for toggles/intervals.
- `maintenance.clear_dead_records`, `maintenance.close_pass_windows`, `maintenance.smart_cleanup`.

### 3) Local AutoWipe Control API (localhost only)
- `GET /local/v1/snapshot`
- `POST /local/v1/command`
- Command handler executes existing functions:
- `Evaluate-And-Render`, `Run-Refresh`, `Run-SaveAuthentic-BySerials`, `Run-WipeByDiskIndices`, toggle handlers.
- Enforce one-command-at-a-time lock using existing busy flags.

## Required Code Additions (Repo-Level)
- Add module `modules/remote_control.ps1`.
- Add module `modules/state_snapshot.ps1`.
- Update `autowipe_v4.5.ps1` load order to include new modules.
- Add machine agent project under `agent/`:
- `agent.ps1` polling loop.
- `install-service.ps1` and `uninstall-service.ps1`.
- Add central app under `control-plane/`:
- `backend/` Node/TS API + websocket.
- `frontend/` web dashboard.
- Add docs:
- `docs/FLEET_ARCHITECTURE.md`.
- `docs/FLEET_DEPLOYMENT.md`.
- `docs/FLEET_API.md`.

## Web UI v1 Screens
- Fleet overview:
- 15 machine cards with online/offline, HDS ready status, drive counts, PASS/FAIL totals, command status.
- Machine detail:
- 24-port grid mirroring current local color semantics and verdict/progress/report fields.
- Control panel:
- Start/stop/restart app.
- Refresh/check/save/wipe.
- Toggle automation and set intervals.
- Command history panel:
- Live queue status and per-command result logs.

## Security and Access
- Local users table with bcrypt password hash.
- Roles:
- `admin`: all commands.
- `operator`: all operational commands except app stop/restart if desired (default allow all in v1 unless restricted later).
- JWT session auth (short-lived access plus refresh token).
- Agent auth via machine API key.
- Local AutoWipe endpoint bound to `127.0.0.1` only.
- Full command audit:
- who, machine, command, payload, time, outcome, duration, error text.

## Reliability Rules
- Agent heartbeats every 5s.
- Command timeout default 90s.
- Retry policy:
- network errors retry 3 times with exponential backoff.
- destructive commands no automatic retry after start attempt.
- Offline machine handling:
- mark stale after 15s, offline after 30s.
- Queue behavior:
- keep pending commands until machine reconnect or command TTL expires.

## Test Cases and Scenarios

### Unit Tests
- Command schema validation and role checks.
- Queue claim/ack/result state transitions.
- Snapshot transform from local state to API payload.

### Integration Tests
- One mocked agent posts heartbeats and executes queued commands.
- Parallel simulation of 15 agents with 5s cadence.
- Websocket fan-out correctness under rapid updates.

### System Tests on Real Rigs
- App running plus command execution end-to-end for all command types.
- App not running -> remote `app.start` -> command success.
- HDS unavailable path -> correct surfaced error and no stuck command.
- Wipe command confirmation and audit record correctness.
- Machine reboot plus agent/service auto-reconnect.

### Acceptance Criteria
- Dashboard shows fresh state for all online machines within 5s.
- Any command result visible in UI within 10s after completion.
- No command executed twice under reconnect/retry conditions.
- Full audit trail exists for every command.
- Existing local AutoWipe behavior unchanged when web system is not used.

## Rollout Plan
1. Build central backend/frontend and DB schema.
2. Build local AutoWipe endpoint modules and verify local command execution.
3. Build/install machine agent service package.
4. Perform pre-flight validation on 1 non-production rig plus VM.
5. Deploy service plus config to all 15 rigs in one scheduled window.
6. Run post-deploy verification checklist on all machines.
7. Freeze changes for 48h and monitor command/audit/heartbeat stability.

## Explicit Assumptions and Defaults
- Use sidecar integration for v1; headless rewrite deferred to v2.
- Machine-level control is primary in v1; per-port control deferred unless requested later.
- Node/TS plus Postgres selected as default stack for fast delivery and reliable operations.
- Single confirmation on wipe commands is sufficient for current operating mode.
