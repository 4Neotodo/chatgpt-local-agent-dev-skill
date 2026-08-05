# AGENTS.md

## 1. Purpose

This file governs changes to the `chatgpt-local-agent-dev-skill` repository itself. Generated target-project rules live under `src/project_governance_skill/templates/` and must remain independent of one business project, operating system, drive letter, Provider, or Agent brand.

## 2. Scope discipline

- Keep the project focused on repository governance initialization and reusable remote/local collaboration rules.
- Do not turn it into a project-management platform, approval service, database-backed workflow engine, or universal policy framework.
- Add a rule or feature only when it solves a repeated cross-project problem and its value exceeds maintenance cost.
- Abstract source-project experience into portable contracts; do not copy private business facts, local paths, branch identities, credentials, artifacts, or evidence.

## 3. Change classes

- Documentation wording only: run placeholder checks and focused tests.
- Generator or CLI behavior: run the full test suite and CLI smoke checks.
- Generated contract change: update affected templates, tests, `README.md`, `SKILL.md`, and `CHANGELOG.md` together.
- Release change: update `pyproject.toml`, package `__version__`, `SKILL.md`, README status, and changelog atomically.

## 4. Branch and writer discipline

All writes use a unique task branch created from a verified full source SHA. Do not write directly to `main` unless the user explicitly authorizes that exact operation.

One branch has one current writer. Remote and local writers must not overlap. Before local edits, verify:

```bash
git branch --show-current
git status --short
git worktree list --porcelain
git fetch origin --prune
```

Stop on a dirty worktree, unrelated changes, unknown commits, branch movement, or ambiguous ownership. Do not hide movement through automatic pull, merge, rebase, reset, stash, or conflict resolution. Remote-to-local and local-to-remote handoff requires commit, push, full-SHA verification, and explicit ownership release.

## 5. Local validation

Use the repository-controlled Python environment when present. Preferred validation:

```bash
python -m pytest -q
python -m project_governance_skill --help
python -m project_governance_skill init --help
python -m project_governance_skill check --help
```

Also generate a temporary example repository and run both normal and strict checks. A missing dependency in an unrelated system Python is command-selection friction when the controlled environment works.

## 6. Template rules

- Templates use `{{UPPER_SNAKE_CASE}}` placeholders.
- Every placeholder must be supplied by generator configuration or a deterministic default.
- Generated files use UTF-8 and LF line endings.
- Default generation never overwrites existing target files.
- `--force` remains explicit and must not become an implicit migration mechanism.
- Generated authority must separate execution facts, current plans, formal versions, specifications, and long-lived governance.
- Formal task templates must distinguish long-lived target branch, unique task branch, fixed source SHA, current writer, worktree, Lane, state, stop budget, and integration owner.
- Project-specific unused fields use `not_applicable`, not blank values.

## 7. Publishing

Stage only intended files. A generated-contract release must be one coherent commit on the task branch. Push the branch, verify the remote SHA, and open a reviewable pull request. Do not self-merge unless the user explicitly authorizes merge.

## 8. Reporting

Report source branch and SHA, task branch, completed commit, changed files, tests, CLI behavior, unresolved issues, push result, ownership release, and final worktree state. Separate product-result failure from execution-process blocker and non-blocking friction.
