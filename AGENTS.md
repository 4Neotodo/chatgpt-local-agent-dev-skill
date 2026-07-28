# AGENTS.md

## Purpose

This file governs changes to the `chatgpt-local-agent-dev-skill` repository itself. The generated target-project rules live under `src/project_governance_skill/templates/` and must remain Agent-brand-neutral.

## Scope discipline

- Keep the project focused on repository governance initialization and reusable collaboration rules.
- Do not turn it into a project-management platform, workflow engine, approval service, or universal policy framework.
- Add a rule or feature only when it solves a repeated cross-project problem and its value exceeds maintenance cost.
- Do not hard-code facts from the source business project into generated templates.

## Change classes

- Documentation or wording only: run template placeholder checks and focused tests.
- Generator or CLI behavior: run the full test suite.
- Generated document contract changes: update templates, tests, README, and changelog together.
- Release changes: update package version and changelog; verify build metadata.

## Local execution

Before editing:

```bash
git branch --show-current
git status --short
git fetch origin
git pull --ff-only
```

Stop on a dirty worktree or unrelated changes. Explicitly stage task files; do not use unreviewed `git add .`.

Use the repository-controlled Python environment when present. Preferred validation:

```bash
python -m pytest -q
python -m project_governance_skill --help
python -m project_governance_skill init --help
python -m project_governance_skill check --help
```

## Template rules

- Templates use `{{UPPER_SNAKE_CASE}}` placeholders.
- All placeholders must be defined in `generator.py` defaults or supplied configuration.
- Generated files must use UTF-8 and LF line endings.
- Default generation must never overwrite existing target files.
- `--force` must remain explicit.
- The generated hierarchy must keep execution facts, current plans, version identity, and long-term governance separate.

## Reporting

Report modified files, tests, package behavior, unresolved issues, commit/push state, and final worktree status. Distinguish product-result failures from environment or process friction.
