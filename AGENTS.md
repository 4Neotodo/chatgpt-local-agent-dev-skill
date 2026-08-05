# AGENTS.md

## 1. Purpose

This file governs changes to the `chatgpt-local-agent-dev-skill` repository itself. Generated target-project rules live under `src/project_governance_skill/templates/` and must remain independent of one business project, operating system, drive letter, Provider, or Agent brand.

The package now supports two first-class profiles:

- `compact_serial`: a short, single-writer, non-parallel contract for projects expected to finish in 1–3 working days;
- `full_collaboration`: the source-locked worktree, Lane, parallel, handoff, stop-budget, and serial-integration contract.

The profiles share core safety rules but must not be collapsed into one oversized template or maintained as duplicated repositories.

## 2. Scope discipline

- Keep the project focused on repository governance initialization and reusable remote/local collaboration rules.
- Do not turn it into a project-management platform, approval service, database-backed workflow engine, or universal policy framework.
- Add a rule or feature only when it solves a repeated cross-project problem and its value exceeds maintenance cost.
- Abstract source-project experience into portable contracts; do not copy private business facts, local paths, branch identities, credentials, artifacts, or evidence.
- A profile difference must represent a real coordination-model difference, not a lower standard of correctness or safety.

## 3. Profile invariants

Shared invariants for both profiles:

- verified repository state outranks remembered chat state;
- one branch has one current writer;
- a task capsule is a narrow execution contract;
- scope, specifications, version identity, external actions, and acceptance cannot expand silently;
- validation must match real impact;
- external and irreversible actions require explicit identity, integer budget, evidence, and authorization;
- a model, Agent, session, or execution-side change does not reset a concrete blocker.

`compact_serial` invariants:

- expected duration is 1–3 working days but duration alone is not sufficient;
- one repository, one active writer, no planned parallel execution, no competitive candidates, and no multi-result integration;
- no formal worktree, Lane, parallel-group, or integration-report requirement;
- compact generation creates exactly its seven governed paths and does not own the target repository README;
- compact-to-full upgrade requires reviewed reconciliation of shared governance files;
- full-to-compact automatic downgrade is unsupported.

`full_collaboration` invariants remain the v0.2 source-locked model, including formal worktrees, Lane ownership, shared resources, fixed-SHA handoff, explicit stop budgets, and serial integration.

## 4. Change classes

- Documentation wording only: run placeholder checks and focused tests.
- Generator or CLI behavior: run the full test suite and CLI smoke checks.
- Generated contract change: update affected templates, tests, `README.md`, `SKILL.md`, and `CHANGELOG.md` together.
- Profile schema change: update profile maps, persisted keys, compatibility behavior, examples, CLI, checks, and migration tests atomically.
- Release change: update `pyproject.toml`, package `__version__`, `SKILL.md`, README status, and changelog atomically.

## 5. Branch and writer discipline

All writes use a unique task branch created from a verified full source SHA. Do not write directly to `main` unless the user explicitly authorizes that exact operation.

One branch has one current writer. Remote and local writers must not overlap. Before local edits, verify:

```bash
git branch --show-current
git status --short
git worktree list --porcelain
git fetch origin --prune
```

Stop on a dirty worktree, unrelated changes, unknown commits, branch movement, or ambiguous ownership. Do not hide movement through automatic pull, merge, rebase, reset, stash, or conflict resolution. Remote-to-local and local-to-remote handoff requires commit, push, full-SHA verification, and explicit ownership release.

## 6. Local validation

Use the repository-controlled Python environment when present. Required validation for generator, CLI, profile, or release changes:

```bash
python -m pytest -q
python -m project_governance_skill --help
python -m project_governance_skill init --help
python -m project_governance_skill check --help
python -m compileall -q src tests scripts
```

Also generate temporary repositories for both profiles and run normal and strict checks. Verify package build/install when release metadata or package data changes.

## 7. Template rules

- Templates use `{{UPPER_SNAKE_CASE}}` placeholders.
- Every placeholder must be supplied by generator configuration or a deterministic default.
- Generated files use UTF-8 and LF line endings.
- Default generation never overwrites existing target files.
- `--force` remains explicit and must not become an implicit migration mechanism.
- Generated authority must separate execution facts, current plans, formal versions, specifications, and long-lived governance according to the selected profile.
- Compact templates must not require formal worktrees, Lane allocation, parallel groups, competitive candidates, or integration reports.
- Full templates must retain long-lived target branch, unique task branch, fixed source SHA, current writer, worktree, Lane, state, stop budget, handoff, and integration owner.
- Project-specific unused fields use `not_applicable`, not blank values.
- A v0.3 compact `AGENTS.md` must contain the exact profile marker checked by the validator.

## 8. Compatibility

- A v0.2 configuration without `governance_profile` is interpreted as legacy `full_collaboration`.
- A v0.3 configuration must declare `governance_profile`.
- `TEMPLATE_MAP`, `DEFAULTS`, and `PERSISTED_KEYS` remain backward-compatible aliases for the full profile where practical.
- Compact configuration rejects full-only stop-budget keys and structural values that imply worktree, Lane, audit-lane, or integration usage.
- Do not claim migration completion merely because missing files were generated; shared authority must match the selected profile.

## 9. Publishing

Stage only intended files. A generated-contract release must be one coherent commit on the task branch. Push the branch, verify the remote SHA, and open a reviewable pull request. Do not self-merge unless the user explicitly authorizes merge.

## 10. Reporting

Report source branch and SHA, task branch, completed commit, changed files, tests for both profiles, CLI behavior, compatibility results, unresolved issues, push result, ownership release, and final worktree state. Separate product-result failure from execution-process blocker and non-blocking friction.
