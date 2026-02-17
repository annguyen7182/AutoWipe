# DECISIONS

## 2026-02-17 - D-001: Use repository context spine as shared memory

- Decision: Use `.context/PROJECT_STATE.md`, `.context/TASKS.md`, `.context/DECISIONS.md`, and `.context/ARCHITECTURE.md` as the persistent cross-agent source of truth.
- Rationale: Chat history is agent-local; file-based context is branch-local and visible to all agents working in the same repo.

## 2026-02-17 - D-002: Enforce authority order for conflict resolution

- Decision: Resolve guidance conflicts by this order: pinned artifact/spec, `.context/*`, then current code/docs.
- Rationale: Prevents drift from long chat threads and keeps implementation grounded in explicit project contracts.

## 2026-02-17 - D-003: Require handoff write-back

- Decision: Every completed task must update project state, task status, and decisions (when applicable) in `.context/*`.
- Rationale: Ensures no critical rationale remains only in transient chat logs.

## 2026-02-17 - D-004: Set agent precedence order

- Decision: When agents conflict and no newer approved decision exists, precedence is Claude -> Codex -> Gemini.
- Rationale: Establishes deterministic conflict resolution while preserving the existing context-first source authority model.

## 2026-02-17 - D-005: Require signed handoff reports

- Decision: Every completed handoff/report must end with `Signed-By: <Claude|Codex|Gemini>`.
- Rationale: Adds lightweight accountability and clear authorship across multi-agent sessions.
