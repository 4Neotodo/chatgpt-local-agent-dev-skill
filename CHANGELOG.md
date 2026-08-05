# Changelog

## 0.2.0 — 2026-08-05

- Upgraded the collaboration contract from a local-execution initializer to a source-locked remote/local governance model.
- Added five formal task types: planning review, remote implementation, local execution, parallel orchestration, and serial integration acceptance.
- Added unique branch-writer ownership, fixed source SHA, formal worktree, Lane, handoff, shared-resource, and integration rules.
- Added explicit execution states, pause/error codes, stop budgets, and concrete blocker fingerprint semantics that do not reset across Agent, model, session, or execution-side changes.
- Added a narrow compare-and-set rule for planning-approved alignment of an unoccupied stale local branch reference.
- Added parallel-group control and integration-report templates.
- Expanded task-capsule, execution-report, planning-review, branch-control, handoff, `AGENTS.md`, and `CHATGPT.md` templates.
- Added configurable worktree roots, Lane limits, evidence roots, and stop budgets to generated configuration.
- Added `check --strict`, `check --json`, and `init --json`; strict mode detects explicit unconfirmed markers and validates contract configuration.
- Preserved dependency-free operation, dry-run, no-overwrite default, and explicit `--force` behavior.

## 0.1.0 — 2026-07-28

- Added the reusable Agent Skill contract.
- Added deterministic, dependency-free project governance initializer.
- Added root governance, planning, version, task-capsule, execution-report, planning-review, and handoff templates.
- Added no-overwrite default, dry-run, force, and repository check modes.
- Added focused tests for generation safety and placeholder validation.
