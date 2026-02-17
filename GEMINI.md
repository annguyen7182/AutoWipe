## Agent Operating Rules (Gemini)

Use this repository as the single source of truth for cross-agent context.

### Startup checklist (do this first)

1. Read `.context/PROJECT_STATE.md`.
2. Read `.context/TASKS.md`.
3. Read `.context/DECISIONS.md`.
4. Read `.context/ARCHITECTURE.md` when changing behavior or interfaces.

### Source authority order

1. Pinned Artifact or approved spec (if using Antigravity).
2. `.context/*` files.
3. Current branch code and docs.

### Agent precedence order

Use this order when agent guidance conflicts and there is no newer approved decision:

1. Claude
2. Codex
3. Gemini

### Handoff protocol (required)

- Do not keep final decisions only in chat.
- When work completes, update:
  - `.context/PROJECT_STATE.md` (goal, assumptions, recent changes)
  - `.context/TASKS.md` (status changes)
  - `.context/DECISIONS.md` (decision + rationale)
- Add commit hashes, PR links, or issue references when available.
- Keep updates short and factual (bullet points only).
- End every completed handoff/report with: `Signed-By: <Claude|Codex|Gemini>`

### Safety rules

- Respect contracts listed in `.context/PROJECT_STATE.md` and `.context/ARCHITECTURE.md`.
- If a contract must change, add a decision entry before implementation.
- Prefer small, reviewable changes and explicit verification notes.
