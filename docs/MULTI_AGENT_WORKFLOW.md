# Multi-Agent Workflow (Claude + Codex + Gemini)

This workflow is designed for your setup:

- Use **Claude** as final authority for architecture direction and conflict resolution.
- Use **Codex** for planning, repository analysis, risk checks, and review.
- Use **Gemini** for implementation-heavy changes and local validation.

The key is a strict handoff contract so both agents behave like one engineering loop.

## Shared Context Spine (Required)

Treat the repository context files as the persistent memory layer:

- `.context/PROJECT_STATE.md`
- `.context/TASKS.md`
- `.context/DECISIONS.md`
- `.context/ARCHITECTURE.md`

## Agent Precedence (Required)

Use this order when agents disagree and there is no newer approved decision:

1. Claude
2. Codex
3. Gemini

Startup protocol for every agent session:

1. Read `PROJECT_STATE.md`, `TASKS.md`, `DECISIONS.md`.
2. Read `ARCHITECTURE.md` before behavior/interface changes.
3. Follow authority order: pinned artifact/spec -> `.context/*` -> branch code/docs.

Handoff protocol for every completed work unit:

- Update project state assumptions/recent changes.
- Update task status.
- Record decisions and rationale when contracts or behavior change.
- Link commit hashes, PR links, or issue references when available.
- End every completed handoff/report with: `Signed-By: <Claude|Codex|Gemini>`.

## High-Level Roles

- `Authority (Claude)`: final decision maker for architecture and conflict arbitration.
- `Planner/Reviewer (Codex)`: scope, task breakdown, acceptance criteria, regression review.
- `Implementer (Gemini)`: code changes, local validation, patch prep, doc updates.

## Branch Strategy

- One branch per feature: `feat/<short-name>`
- Optional sub-branches for large work:
  - `feat/<short-name>-plan`
  - `feat/<short-name>-impl`
- Merge back to one feature branch before PR.

## Required Handoff Package

Every handoff should include the same compact payload.

### 1) Objective

- One sentence: what should be true when done.

### 2) Constraints

- Compatibility targets (PowerShell version, HDS assumptions, Windows-only behavior).
- Safety constraints (no destructive window kill without guard, no path regression).

### 3) Task List

- Numbered steps with clear file targets.

### 4) Acceptance Criteria

- Observable checks (for example: startup still loads all 5 modules, no doc version mismatch).

### 5) Verification Commands

- Exact commands to run and expected pass conditions.

### 6) Output Contract

- Expected deliverables: file list changed, why changed, test output summary, remaining risks.

## Suggested Loop

1. **Claude scopes and sets guardrails**
   - Confirm contracts and decision boundaries.
   - Resolve ambiguity before implementation.

2. **Codex plans**
   - Analyze current state.
   - Produce implementation plan and acceptance criteria.
   - Produce a copy-paste prompt for Gemini.

3. **Gemini implements**
   - Apply targeted edits.
   - Run validation commands.
   - Return changed files + rationale + command outputs.

4. **Codex reviews**
   - Compare implementation to plan.
   - Spot gaps or regressions.
   - Produce follow-up patch request if needed.

5. **Claude closes**
   - Resolve remaining conflicts.
   - Approve final handoff and next actions.

## Prompt Templates

### A) Codex -> Gemini (Implementation)

```text
You are implementing a scoped change in an existing PowerShell project.

Objective:
<one sentence>

Constraints:
- Keep compatibility with PowerShell 5.1
- Do not change unrelated behavior
- Preserve existing module boundaries

Tasks:
1) <task>
2) <task>
3) <task>

Acceptance Criteria:
- <criterion>
- <criterion>

Verify with:
- <command>
- <command>

Return:
1) Files changed
2) Why each file changed
3) Command outputs summarized
4) Any remaining risks
5) Signature line: Signed-By: Gemini
```

### B) Gemini -> Codex/Claude (Review Handoff)

```text
Implementation complete.

Changed files:
- <file>
- <file>

Behavior changes:
- <change>

Validation results:
- <command>: <result>

Known risks / assumptions:
- <risk>

Signed-By: Gemini
```

## Practical Rules That Reduce Drift

- Always reference exact file paths in tasks.
- Keep tasks small (ideally 3-7 files per cycle).
- Require explicit acceptance criteria before coding starts.
- Do not allow implementation without a verification section.
- Keep one canonical version label across README + docs + script banner.

## Recommended Cadence for This Repo

- Claude owns final architecture decisions and conflict resolution.
- Codex handles planning and docs consistency passes.
- Gemini handles implementation-heavy edits inside `modules/*.ps1`.
- Codex performs regression review for:
   - startup/module load flow
   - watcher verdict behavior
   - automation timer priority order
   - documentation/version consistency
