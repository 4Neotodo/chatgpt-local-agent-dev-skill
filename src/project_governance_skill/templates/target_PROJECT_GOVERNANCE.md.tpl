# {{PROJECT_NAME}} — Project Governance Decision v0.1

**Status:** Initialization baseline / Planning review required  
**Repository:** `{{REPOSITORY}}`  
**Created:** {{CREATED_DATE}}

## 1. Nature

This document defines the shared governance baseline for ChatGPT, local Agents, GitHub, and human review. It governs decision authority, document duties, task closure, evidence, and governance iteration. It does not decide the product architecture or business specification.

Governance addresses real, cross-task problems. Do not build complex classification, approval, audit, state-machine, or task-platform machinery because of a single difficult execution.

## 2. Decisions

### 2.1 Two-dimensional document governance

Vertically, preserve the source relationship from formal decision → repository plan → branch task control → optional task plan → single-task capsule → execution evidence.

Horizontally, separate formal decisions, specifications, plans, branch controls, formation material, and execution reports by duty.

A branch task control must originate from an approved project route or explicit user-approved branch task. It cannot change higher-level decisions by itself.

### 2.2 Context follows the task's real needs

First decide what the task needs to understand and decide, then locate authority. Do not mechanically read a fixed large list.

Use original text while context is manageable. Create a sourced temporary summary only when the material is too large, scattered, or repetitive and this materially harms quality or efficiency. A summary never replaces authority.

### 2.3 Each task forms a corresponding acceptable closure

ChatGPT/GitHub handles planning review, remote governance documents, and authorized remote edits. The local Agent handles local implementation, tests, real runs, commits, pushes, and execution reports. The user reviews only where business, visual, device, cost, risk, or irreversible authority is necessary.

A local Agent completion means implementation and evidence were submitted. Task, phase, branch, merge, version, and release closure remain planning-review decisions where those higher-level boundaries are involved.

### 2.4 Execution facts and long-lived conclusions are stored separately

Execution reports record one run's branch, commit, changes, tests, artifacts, blockers, and worktree. Product scope, architecture, business rules, route, technical-debt policy, repository discipline, and version identity belong to formal decisions, specifications, plans, `AGENTS.md`, `CHATGPT.md`, or `VERSION_MATRIX.md`.

Do not reverse-engineer long-lived rules from a convenient implementation, current test state, temporary acceptance, or an executor's suggestion.

### 2.5 Specification and acceptance are version-bound

A releasable specification version must identify its human-readable specification, executable behavior, support boundary, necessary tests, and acceptance evidence.

Behavior-changing rule, prompt, template, program, schema, or support changes create a candidate version and require impact-matched review. Historical fixtures and evidence prove only their corresponding version.

### 2.6 Governance-feedback routing

An execution report may identify blockers or rule gaps, but its recommendation does not automatically become a rule or implementation authorization.

Planning review must distinguish:

1. task-level instruction, path, command, evidence, or rule-compliance error — fix the next task and method first;
2. repeated cross-task rule missing or needing change — update formal governance and necessary root rules first;
3. local implementation of an approved rule — authorize tools, tests, scripts, or checks as local execution;
4. remote capability limitation or atomic rule/implementation need — combine only after the governance decision is fixed in the capsule.

### 2.7 Necessary, simple, value-positive governance

Prioritize correcting the wrong task instruction or authority path, reusing an existing rule or tool, and only then adding a narrow reusable capability.

Do not build universal capsule parsers, duplicate status systems, complex audit platforms, or gates for every low-probability failure unless the problem repeats across tasks and the value clearly exceeds maintenance cost.

### 2.8 Cross-task local evidence

Retain local uncommitted evidence only when an authorized downstream task explicitly depends on it. Record path, identity, provenance, downstream use, and cleanup condition. Recheck it before downstream work. Missing or provenance-broken evidence blocks the task and cannot be replaced by a new random or external run.

### 2.9 Local execution-process assessment

Every local task reports task result separately from environment or method problems. Distinguish task-result blocker, execution-process blocker, and non-blocking friction. State recurrence, sufficiency of existing rules, and recommended governance layer. The executor reports facts and advice but does not self-authorize rule changes.

## 3. Root-entry duties

- `AGENTS.md`: local Agent long-term operating entry;
- `CHATGPT.md`: remote planning and review entry;
- `PLANS.md`: current route and immediate next task;
- `VERSION_MATRIX.md`: version and artifact identity;
- `README.md`: stable project description and minimum entry list;
- branch task control: branch objective, boundary, gates, current state, and next task;
- execution reports: retained one-task evidence when Git and test output are insufficient.

## 4. Confirmation required

This initialization baseline becomes current governance only after planning review confirms it for `{{PROJECT_NAME}}` and records any project-specific exceptions.
