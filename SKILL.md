---
name: project-development-governance
version: 0.1.0
description: Initialize or realign a repository for disciplined ChatGPT and local-Agent collaboration by generating top-level governance, planning, version, task-capsule, execution-report, and handoff documents without binding the workflow to a specific local Agent.
---

# Project Development Governance Skill

## 1. Use this skill when

Use this skill when a user asks to:

- initialize a new development repository for ChatGPT and local Agent collaboration;
- reproduce an established development discipline in another project;
- generate top-level repository control documents and execution rules;
- make Codex, Claude Code, Kimi, Gemini CLI, or another local Agent follow the same workflow;
- replace chat-only conventions with versioned repository rules.

Do not use it to decide the project's product scope, architecture, business rules, release plan, or technical stack without a separate planning review.

## 2. Outcome

Create a small, explicit governance baseline in the target repository:

- `README.md`: stable project description and authoritative entry list;
- `AGENTS.md`: long-lived operating rules for local Agents;
- `CHATGPT.md`: remote ChatGPT planning and review rules;
- `PLANS.md`: current route, active branches, and immediate next task;
- `VERSION_MATRIX.md`: version and artifact identity only;
- project governance decision;
- branch task-control template;
- task-capsule template;
- planning-review, execution-report, and handoff templates.

The result must remain project-specific enough to be useful and generic enough to avoid hard-coding one business project or one Agent product.

## 3. Required inputs

Resolve before writing:

1. target repository root;
2. repository identity, such as `owner/name`;
3. default branch;
4. active integration or development branch, if one exists;
5. project name and stable one-paragraph purpose;
6. primary code root and primary validation command;
7. whether this is a new repository or an existing repository with authoritative documents.

Use visible placeholders only for minor unknowns. Do not invent product decisions, release identities, branch history, or acceptance evidence.

## 4. Authority order

When operating in an existing repository, apply this order:

1. explicit user instruction and approved planning decision;
2. current formal governance and specifications;
3. root `AGENTS.md`, `CHATGPT.md`, `PLANS.md`, and `VERSION_MATRIX.md` according to their stated duties;
4. current branch task control;
5. current task capsule;
6. implementation, tests, Git history, and execution reports as execution facts;
7. historical documents only when needed to resolve conflict or provenance.

A task capsule is a single-task execution contract. It cannot silently change higher-level rules.

## 5. Initialization workflow

### Step 1 — Repository safety gate

Run in the target repository:

```bash
git branch --show-current
git status --short
git remote -v
```

If the worktree is not clean, stop. Do not switch, stash, commit, delete, or overwrite files unless the task explicitly authorizes handling those exact changes.

If a target branch is specified and the worktree is clean:

```bash
git fetch origin
git switch <target-branch>   # only when switching is authorized
git pull --ff-only
```

Recheck branch and worktree after switching or pulling.

### Step 2 — Existing-document inventory

Check whether the target already has:

```text
README.md
AGENTS.md
CHATGPT.md
PLANS.md
VERSION_MATRIX.md
docs/00_project_overview/
docs/02_dev_plans/
docs/03_execution_reports/
```

Do not overwrite existing authoritative documents merely to make them match templates. Classify each path as:

- missing and safe to create;
- existing and already authoritative;
- existing but conflicting or unclear;
- historical and not a current entry.

Conflicting authority requires planning review before replacement.

### Step 3 — Prepare configuration

Create a JSON file based on `examples/minimal/project-governance.json`. Use verified values. The required field is `project_name`; other unknown values may remain `[待确认]` for the first controlled draft.

### Step 4 — Dry run

Run the installed CLI, or use the zero-install source-checkout entry:

```bash
project-governance-init init \
  --repo-root <target-root> \
  --config <config.json> \
  --dry-run

# Equivalent without installation:
python scripts/project_governance_init.py init \
  --repo-root <target-root> \
  --config <config.json> \
  --dry-run
```

Review every planned `created`, `skipped`, or `overwritten` path. `--force` is prohibited unless replacement of the named files is explicitly authorized.

### Step 5 — Generate the baseline

Run the same command without `--dry-run`. The default mode creates missing files and skips existing files.

Then replace project-specific placeholders and write only verified current facts. Keep the document responsibilities separate:

- do not put per-run test logs in `PLANS.md`;
- do not put current task status in `VERSION_MATRIX.md`;
- do not turn `README.md` into a live task journal;
- do not duplicate the full governance decision into every file.

### Step 6 — Validate

Run:

```bash
project-governance-init check --repo-root <target-root>
git diff --check
git diff --stat
git diff
```

Also run any project-specific validation required by the task. A document-only initialization does not automatically require unrelated product tests.

### Step 7 — Commit and report

Explicitly stage only task files. Do not use unreviewed `git add .`.

The completion report must include:

- repository and target branch;
- starting and completion commit;
- created, skipped, and modified files;
- validation commands and results;
- whether any existing authority conflict remains;
- push result and final worktree state;
- the immediate next planning-review or implementation task.

## 6. Shared collaboration model

### ChatGPT / remote planning side

Default responsibilities:

- project and branch planning review;
- scope, architecture, specification, and acceptance decisions;
- task sequencing and task-capsule drafting;
- remote governance and plan edits when authorized;
- review of local Agent execution reports;
- phase, branch, release, merge, and closure decisions.

ChatGPT must not claim local commands, tests, artifacts, or worktree state that it did not verify.

### Local Agent side

Default responsibilities:

- local code and document edits authorized by the task capsule;
- environment, dependency, path, and command handling;
- deterministic tests and real artifact validation;
- authorized real Provider or external-service calls;
- Git status, commit, push, and evidence capture;
- concise execution report and process-blockage assessment.

The local Agent may identify governance problems but cannot convert its suggestion into a new repository rule without planning review.

### User side

The user is required only where human authority or judgment is necessary, such as:

- product and business decisions;
- visual or device acceptance;
- acceptance of constraints, risks, cost, or irreversible operations;
- approval of scope or governance changes.

## 7. Task types and risk levels

Use task type to assign responsibility; use risk level to set validation and reporting intensity.

### Task types

- `【规划审查】`: decisions, route, specifications, branch control, governance, closure;
- `【本地执行】`: implementation, local validation, artifacts, Git operations;
- `【UI修改】`: authorized UI edits plus local visual validation;
- `【版本/发布控制】`: version identity, packaging, lifecycle, and delivery.

### Risk levels

- `L0`: documentation or status correction with no behavior or identity change;
- `L1`: local, low-risk code correction without shared contract or output change;
- `L2`: shared behavior, business capability, schema, output, or foundation change;
- `L3`: release candidate, production delivery, real lifecycle, or device acceptance.

When impact expands during execution, stop scope expansion and return to planning review or an explicitly upgraded task.

## 8. Non-negotiable disciplines

1. Read context from the task's real needs, not from a mechanical full-repository checklist.
2. Prefer original authoritative text while context remains manageable; summarize only when volume or duplication materially harms execution.
3. Separate one-time execution facts from long-lived decisions.
4. Match validation to real impact; neither mechanically run everything nor substitute low-value checks for required evidence.
5. Keep temporary task evidence under `.tmp/<task-id>/` and local configuration under `.local/` unless the project explicitly defines another boundary.
6. Never commit secrets, unredacted private data, raw sensitive provider responses, or credentials.
7. Before real Provider, publication, deletion, migration, or another irreversible action, close the input identity, output path, authorization, retry policy, and stop conditions.
8. One local-Agent session should complete one independently acceptable task. Do not silently continue into the next phase.
9. Governance investment must be necessary, simple, and worth its maintenance cost.

## 9. Stop conditions

Stop and report instead of improvising when:

- the worktree is dirty or contains unrelated changes;
- the branch, source commit, or repository identity does not match the task;
- authoritative documents conflict;
- required evidence is missing or its provenance cannot be closed;
- the task requires changing scope, architecture, specification, governance, version identity, or branch objective without approval;
- a real external call is not explicitly authorized;
- an existing file would need replacement but `--force` was not approved;
- the controlled runtime or required dependency is unavailable.

## 10. Definition of done

Initialization is complete only when:

- required governance entries exist or are explicitly classified as pre-existing authority;
- roles and document duties do not overlap materially;
- current route and next task have a single authoritative location;
- the task-capsule and report templates are usable without reference to this source project;
- validation passes;
- the commit and push state are reported;
- remote ChatGPT can review the repository without relying on hidden chat history.
