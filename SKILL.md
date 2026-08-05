---
name: project-development-governance
version: 0.3.0
description: Initialize or realign a repository with either a compact serial or full source-locked ChatGPT/local-Agent collaboration contract, generating profile-specific governance, task, evidence, handoff, and validation files without binding the workflow to one Agent product.
---

# Project Development Governance Skill

## 1. Use this skill when

Use this skill when a user asks to:

- initialize a new development repository for ChatGPT and local-Agent collaboration;
- reproduce an established development discipline in another project;
- replace chat-only instructions with versioned repository authority;
- choose a lightweight serial governance baseline for a bounded one-to-three-day project;
- define safe remote implementation, local implementation, branch ownership, worktree, parallel-Lane, handoff, or integration rules;
- realign an existing repository whose root governance no longer matches actual execution practice;
- make Codex, Claude Code, Kimi, Gemini CLI, or another authorized Agent follow one common contract.

Do not use this skill to decide product scope, architecture, business rules, technical stack, or release identity without a separate planning review. Do not turn the repository into a general project-management platform, approval service, database-backed workflow engine, or universal policy framework.

## 2. Select the governance profile first

Version `0.3.0` provides two first-class profiles in one repository and package.

### 2.1 compact_serial

Use `compact_serial` only when all material conditions hold:

1. expected completion is one to three working days;
2. one code repository contains the work;
3. only one formal writer is active at a time;
4. no parallel implementation, competitive attempt, or independent audit Lane is planned;
5. one short-lived task branch is sufficient;
6. multiple results do not need later integration;
7. no formal worktree allocation or shared-resource scheduler is needed;
8. risk is mainly L0–L2 and acceptance is observable through a small number of commands, artifacts, or human checks;
9. the project can stop and upgrade before these assumptions are violated.

Duration is necessary but not sufficient. A one-day production migration or two-Agent parallel implementation is not compact merely because it is short.

The compact profile removes coordination machinery, not safety requirements. It retains source verification, one-writer ownership, narrow task authorization, impact-matched validation, external-action budgets, fixed-SHA writer transfer, evidence, and stop rules.

### 2.2 full_collaboration

Use `full_collaboration` when any of the following is true:

- the route is longer than three working days or expected to continue across releases;
- more than one writer, branch, or workstream must be active;
- formal worktrees, parallel Lanes, read-only audits, competitive candidates, or shared resources are needed;
- multiple accepted results need controlled serial integration;
- complex L3 lifecycle, production delivery, migration, or release evidence is required;
- compact task and report structures cannot express dependencies and ownership without ambiguity.

Do not create a separate repository or permanently fork the shared rules for compact use. Shared principles must have one implementation and one release history.

## 3. Outcomes by profile

### 3.1 compact_serial output

Generate exactly the compact governed paths:

- `AGENTS.md` — serial execution discipline for any authorized Agent;
- `CHATGPT.md` — planning, authorized remote writing, and result-review discipline;
- `PLANS.md` — current serial route, limits, status, and immediate next task;
- `.project-governance/config.json` — compact identity, timebox, paths, and blocker budget;
- `docs/00_project_overview/PROJECT_CONTROL.md` — merged overview, scope, branch route, eligibility, and done definition;
- `docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md` — one serial planning or implementation task;
- `docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md` — one execution fact set.

The compact profile does not own the target repository `README.md` and does not generate a version matrix, branch-control template, parallel-group control, planning-review report, handoff report, or integration report.

### 3.2 full_collaboration output

Generate the full v0.2-compatible baseline:

- `README.md`, `AGENTS.md`, `CHATGPT.md`, `PLANS.md`, `VERSION_MATRIX.md`;
- `.project-governance/config.json`;
- project overview and durable governance decision;
- branch task control, formal task capsule, and parallel-group control;
- planning-review, execution, handoff, and integration reports.

The full result must remain source-locked, branch-owner-safe, worktree-aware, parallel-explicit, evidence-governed, and Agent-brand-neutral.

## 4. Shared first principles

Both profiles obey these principles:

1. **Verified repository state outranks remembered chat state.** Current branch, complete commit SHA, writer, and authoritative files must be checked before current-state claims or writes.
2. **One branch has one current writer.** Remote and local writers never overlap on the same branch. A model, session, or Agent switch does not create or release ownership.
3. **A task capsule is a narrow execution contract.** It cannot silently change governance, product scope, architecture, specification, branch objective, version identity, or external-action authorization.
4. **Task responsibility and risk are separate.** Neither authorizes unrelated changes.
5. **Execution facts and long-lived decisions stay separate.** Git, tests, evidence, and reports describe one execution. Governance, specifications, plans, and version matrices describe durable authority.
6. **Validation matches actual impact.** Do not mechanically run everything, and do not substitute low-value smoke checks for required behavior or artifact evidence.
7. **Retries are evidence-governed.** Rewording, changing models, changing sessions, or repeating an unchanged command does not reset a blocker.
8. **Humans provide only non-substitutable judgment or authorization.** Routine Git, state, evidence, testing, and reporting belong to the responsible Agent.
9. **External and irreversible actions are closed before execution.** Identity, integer budget, retry, fallback, evidence, redaction, and authorization must be explicit.
10. **Governance remains necessary, simple, and value-positive.** Fix a bad task or ignored rule before adding permanent machinery.

## 5. Authority order

For an existing repository, apply this order:

1. explicit user authorization and accepted planning decision;
2. current formal governance and specifications;
3. root entries according to their stated duties;
4. current project or branch control;
5. current task capsule or full-profile parallel-group control;
6. fixed Git commits, tests, artifacts, and execution reports as execution facts;
7. historical documents only for provenance, conflict resolution, or historical review.

A lower-level document cannot silently override a higher-level rule. On material conflict, stop and return to planning review. On branch, source, or writer conflict, stop immediately rather than hiding movement through pull, rebase, reset, stash, or conflict resolution.

## 6. Risk levels

- `L0`: documentation or state correction with no behavior, contract, output, or identity change;
- `L1`: narrow local correction with no shared contract, schema, business output, template, or release-identity change;
- `L2`: shared behavior, business capability, schema, output, foundation, governance, or cross-component contract change;
- `L3`: release candidate, production delivery, real lifecycle, formal artifact, real external service, device, migration, or user-environment acceptance.

Compact projects normally remain L0–L2. An L3 task requires a planning review that explicitly confirms compact still remains adequate; complex L3 defaults to full collaboration.

## 7. Initialization workflow

### Step 1 — Verify repository identity

Before writing, record at least:

```bash
git branch --show-current
git status --short
git remote -v
git fetch origin --prune
git rev-parse HEAD
```

For full local execution, also verify formal worktree occupancy and branch uniqueness. For compact, a clean ordinary checkout is sufficient; worktree is optional implementation detail and cannot authorize parallel writing.

If the worktree is dirty or contains unrelated changes, stop. Do not switch, stash, commit, delete, reset, or overwrite those changes. If operating through a remote GitHub writer, use a unique task branch created from the verified source SHA.

### Step 2 — Perform profile eligibility review

Record:

```yaml
selected_profile:
expected_duration_days:
repository_count:
active_writer_count:
planned_parallelism:
planned_independent_audit:
planned_result_integration:
worktree_or_lane_requirement:
risk_ceiling:
acceptance_path:
upgrade_triggers:
decision:
```

Choose compact only when every compact condition is satisfied. Do not choose full merely because it is more elaborate; governance value must exceed its cost.

### Step 3 — Inventory existing authority

Classify each expected profile path as:

- missing and safe to create;
- existing and already authoritative;
- existing but conflicting or unclear;
- historical and not a current entry;
- owned by the target project rather than this initializer.

Do not overwrite an authoritative file merely to match a template. Conflicting authority requires planning review. `--force` is allowed only when replacement of every named path is explicitly authorized and the replacement diff has been reviewed.

### Step 4 — Prepare configuration

Start from:

- `examples/compact/project-governance.json` for compact;
- `examples/minimal/project-governance.json` for full.

Fresh configurations must declare:

```json
"governance_profile": "compact_serial"
```

or:

```json
"governance_profile": "full_collaboration"
```

A legacy `0.2.0` config without a profile is interpreted as full collaboration. Do not treat a missing profile in a new `0.3.0` config as valid.

Compact additionally fixes:

```text
integration_branch = not_applicable
formal_worktree_root = not_applicable
auto_worktree_root = not_applicable
maximum_active_write_lanes = 1
maximum_read_only_audit_lanes = 0
```

and requires `estimated_duration_days` between 1 and 3. It uses only `same_blocker_attempt_budget`; full-only aggregate and no-progress budgets are rejected if explicitly supplied.

### Step 5 — Dry run

```bash
project-governance-init init \
  --profile <compact_serial|full_collaboration> \
  --repo-root <target-root> \
  --config <config.json> \
  --dry-run
```

Review every `created`, `skipped`, `unchanged`, or `overwritten` path. `--json` is available for machine-readable evidence.

### Step 6 — Generate missing files

Run without `--dry-run`. Default behavior creates missing files and skips existing files. It never claims skipped files comply with the selected profile.

For an existing repository, compare generated candidates in a temporary directory or task branch and convert only approved differences into repository changes.

### Step 7 — Resolve explicit unknowns

Replace project-specific `[待确认:...]` markers with verified values. Do not invent product decisions, release identities, branch history, worktree paths, owners, external authorization, or acceptance evidence.

Generic placeholders such as `[full SHA]` inside reusable task/report templates are intentional. Instantiated tasks and reports must replace every applicable value and use `not_applicable` for unused fields.

### Step 8 — Validate

```bash
project-governance-init check \
  --profile <selected-profile> \
  --repo-root <target-root>

project-governance-init check \
  --profile <selected-profile> \
  --repo-root <target-root> \
  --strict

git diff --check
git diff --stat
git diff
```

Normal check validates profile-required paths, UTF-8, unresolved template tokens, config version, profile consistency, profile-specific persisted fields, and structural restrictions. Strict mode also fails on explicit `[待确认]`, `[TODO]`, or `[TBD]` markers.

Run only project validation whose impact is actually triggered. Governance-only initialization does not automatically require unrelated product tests.

### Step 9 — Commit, push, and review

Explicitly stage only task files. Commit and push the unique task branch. Report:

- repository, selected profile, target branch, task branch, and verified source SHA;
- completed commit and remote push result;
- changed, created, skipped, and unresolved paths;
- validation commands and results;
- current writer ownership and release state;
- unresolved authority or profile conflicts;
- immediate next planning or implementation task.

Do not merge or close a higher-level branch merely because generation and checks passed.

## 8. Compact collaboration contract

### 8.1 Formal task types

Compact uses only:

- `【规划审查】`;
- `【实现执行】`.

`execution_side` is `local`, `remote`, or `not_applicable`. It does not create another task type.

### 8.2 Roles

Compact declares only roles that affect the serial task:

- `planning_owner`;
- `current_writer`;
- `validation_owner`.

The user remains the owner of non-substitutable business, visual, merge, deployment, external-account, or irreversible-action decisions.

### 8.3 Task capsule minimum

A compact task declares:

```yaml
task_id:
task_type:
risk_level:
repository:
project_target_branch:
task_branch:
source_ref:
source_head:
execution_side:
current_writer:
planning_owner:
validation_owner:
objective:
allowed_changes:
forbidden_changes:
required_context:
required_checks:
acceptance_criteria:
external_actions:
stop_rule:
handoff_if_writer_changes:
initial_state:
allowed_terminal_states:
final_report_fields:
```

It must not add `lane_id`, `parallel_group_id`, `formal_worktree_path`, competitive candidates, `integration_owner`, or `integration_order`. A real need for those fields is an upgrade trigger.

### 8.4 Branch and writer

One short-lived task branch is created from a verified full SHA. One writer owns it until commit, push, evidence, and release. Direct default-branch writes require exact user authorization.

A writer switch uses commit, push, complete SHA verification, outgoing release, incoming fetch, clean-state verification, and incoming acquisition. If no switch occurs, no separate handoff report is required.

### 8.5 States and stop rule

Compact states are:

```text
PLANNED
IN_PROGRESS
BLOCKED
READY_FOR_REVIEW
CLOSED
```

A concrete blocker may receive only the configured number of effective corrective attempts. An effective attempt requires a material corrective action, rerun of the corresponding checkpoint, new native evidence, and continued failure. Repetition or a model/session/Agent change does not reset the count.

### 8.6 Upgrade triggers

Pause compact and return to planning review when:

- duration is expected to exceed three working days;
- a second active writer is needed;
- parallel, competitive, or independent-audit work is needed;
- multiple results require integration;
- formal worktree/Lane or shared-resource scheduling is needed;
- complex production delivery, migration, or release appears;
- the compact task cannot express dependencies or acceptance unambiguously.

## 9. Full collaboration contract

The full profile retains the v0.2 model.

### 9.1 Formal task types

- `【规划审查】`;
- `【远端实现】`;
- `【本地执行】`;
- `【并行执行编排】`;
- `【并行结果集成验收】`.

### 9.2 One branch, one writer, one Lane boundary

A formal write Lane is:

```text
one task
+ one unique branch
+ one formal worktree when local
+ one current writer
+ one task capsule
+ one isolated evidence and acceptance path
```

Direct parallel writes to a shared parent or integration branch are prohibited.

### 9.3 Source lock and handoff

At allocation, record `source_ref` and full `source_head`. Unknown commits, mismatched SHA, or ambiguous ownership produce an ownership-conflict pause. Remote-to-local and local-to-remote transitions require commit, push, exact SHA verification, ownership release, receiver fetch, clean-state verification, and acquisition.

### 9.4 Parallel execution and integration

Allowed parallel types remain independent long-lived branches, child task branches, competitive attempts, read-only audits, or not applicable. A parallel group declares capacity, Lane definitions, dependencies, shared resources, pause triggers, and integration order.

Accepted write results are integrated one at a time by a unique `integration_owner`, with impact-matched checks after each step. Competitive attempts select one candidate rather than splicing unaccepted results.

### 9.5 Stop budgets

Full profile supports concrete blocker attempt, total failed recovery, and no-progress checkpoint budgets. They do not reset through Agent, model, session, label, or execution-side changes.

### 9.6 Shared resources and irreversible actions

Each shared resource declares mode, owner, acquire/release triggers, evidence, and conflict action. Real Provider calls, publication, deletion, migration, deployment, package replacement, credential changes, and other irreversible actions require exact identity, integer budget, retry/fallback policy, evidence, redaction boundary, and explicit authorization.

## 10. Migration and compatibility

### 10.1 Legacy v0.2

A config declaring `governance_contract_version: 0.2.0` without `governance_profile` is accepted only as legacy `full_collaboration`. Existing full template paths and numeric fields remain required.

Newly generated configs use `0.3.0` and must persist the selected profile.

### 10.2 compact to full

This upgrade is supported but reviewed:

1. freeze the compact source SHA and record why eligibility failed;
2. generate a full candidate in isolation;
3. create missing full-only files;
4. explicitly reconcile shared `AGENTS.md`, `CHATGPT.md`, `PLANS.md`, task capsule, and execution report;
5. replace shared files only with approved diff and explicit authorization;
6. run full normal and strict checks;
7. commit, push, and review.

Changing only the config profile is insufficient. The checker rejects a full config while compact shared authority remains.

### 10.3 full to compact

Automatic downgrade is unsupported. Do not delete full files or convert a long-lived collaboration project merely to reduce visible governance. A separate planning review must prove the full contract is retired and explicitly define archival or replacement behavior.

## 11. Definition of done

Initialization or realignment is complete only when:

- profile selection is justified by current project facts;
- required profile paths exist or are explicitly classified as existing authority;
- project-specific unknown markers are resolved or consciously left as a blocking planning item;
- source, branch, writer, task, external action, validation, and evidence rules are internally consistent;
- generated files pass normal and strict checks when declaring completion;
- no existing authority was overwritten without explicit approval;
- the task commit is pushed and its full SHA is verified;
- writer ownership is released or intentionally retained in a declared state;
- ChatGPT and a local Agent can continue from repository authority without hidden chat history;
- compact projects still satisfy compact eligibility, or an upgrade is the explicit next task.
