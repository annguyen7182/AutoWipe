# TASKS

## In Progress

- [ ] Maintain `.context/*` updates as part of every completed handoff.
- [ ] Enforce `Signed-By: <Claude|Codex|Gemini>` on completed handoff reports.

## Pending

- [ ] Add first real feature/bug task entry when implementation work begins.
- [ ] Link commits/PRs to completed tasks once Git history exists for this workflow.
- [ ] Add machine-folder path resolution in code (`machines/<COMPUTERNAME>`) while keeping HDS XML local (deferred for now).

## Completed

- [x] Add persistent troubleshooting log output to `Start-AutoWipe-NAS.bat` (`Start-AutoWipe-NAS.log`) for launch/elevation diagnostics.
- [x] Improve launcher visibility by showing elevation request/failure messages in `Start-AutoWipe-NAS.bat`.
- [x] Improve `Start-AutoWipe-NAS.bat` reliability with hostname/IP fallback and explicit launch/auth error output.
- [x] Keep settings files local on C:\HDMapping and set HDS XML path to C:\Program Files (x86)\Hard Disk Sentinel\HDSentinel.xml in modules/core.ps1.
- [x] Create shared context spine files (`PROJECT_STATE.md`, `TASKS.md`, `DECISIONS.md`, `ARCHITECTURE.md`).
- [x] Verify `CLAUDE.md` and `GEMINI.md` share the same startup checklist and authority order.
- [x] Set agent precedence to Claude -> Codex -> Gemini across workflow docs.
- [x] Add NAS launcher script `Start-AutoWipe-NAS.bat` for credentialed startup from share.

