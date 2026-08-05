---
name: project-development-governance
version: 0.2.0
description: Initialize or realign a repository for source-locked ChatGPT and local-Agent collaboration by generating long-lived governance, branch ownership, task-capsule, parallel-lane, evidence, handoff, integration, and reporting contracts without binding the workflow to one Agent product.
---

# Project Development Governance Skill

## 1. Use this skill when

Use this skill when a user asks to:

- initialize a new development repository for remote ChatGPT and local-Agent collaboration;
- reproduce an established development discipline in another project;
- replace chat-only instructions with versioned repository authority;
- define safe remote implementation, local implementation, worktree, parallel-lane, and serial-integration rules;
- realign an existing repository whose root governance no longer matches actual execution practice;
- make Codex, Claude Code, Kimi, Gemini CLI, or another authorized Agent follow one common contract.

Do not use this skill to decide product scope, architecture, business rules, technical stack, or release identity without a separate planning review. Do not turn the repository into a general project-management platform, approval service, database-backed workflow engine, or universal policy framework.

## 2. Outcome

Generate or reconcile a compact governance baseline:

- `README.md`: stable project description and minimum authority entry list;
- `AGENTS.md`: repository-wide execution rules for any authorized Agent;
- `CHATGPT.md`: remote planning, remote implementation, orchestration, and review rules;
- `PLANS.md`: repository route, active long-lived branches, governance limits, and immediate next task;
- `VERSION_MATRIX.md`: version, formal artifact, and historical identity only;
- project overview and governance decision;
- branch task-control, formal task-capsule, and parallel-group templates;
- planning-review, execution-report, handoff, and integration-report templates;
- `.project-governance/config.json`: the generated baseline identity and operational limits.

The result must be project-specific enough to execute and Agent-brand-neutral enough to reuse. It must not hard-code the source project's business facts, local drive letters, Provider identities, or branch names.

## 3. First principles

1. **Verified repository state outranks remembered chat state.** Current branch, full commit SHA, worktree, ownership, and authoritative files must be checked before current-state claims or writes.
2. **One branch has one current writer.** Remote and local writers never overlap on the same branch. A model, session, or Agent switch does not create new ownership.
3. **A task capsule is a narrow execution contract.** It cannot silently change governance, product scope, architecture, specification, branch objective, version identity, or external-call authorization.
4. **Task type sets responsibility; risk sets proof intensity.** Neither authorizes unrelated changes.
5. **Execution facts and long-lived decisions stay separate.** Git, tests, task evidence, and reports record one execution. Governance, specifications, plans, and version matrices record durable authority.
6. **Validation matches actual impact.** Do not mechanically run everything, and do not substitute low-value checks for required real evidence.
7. **Parallel work is explicit, bounded, and isolated.** Each write Lane has one task, branch, worktree, writer, capsule, and evidence boundary. Integration is serial.
8. **Retries are evidence-governed.** Rewording, changing models, changing sessions, or repeating an unchanged command does not reset a blocker or budget.
9. **Human work is limited to genuinely non-substitutable judgment or authorization.** Routine Git, worktree, state, budget, evidence, and integration work belongs to the responsible Agent.
10. **Governance must remain necessary, simple, and value-positive.** Fix a bad task or ignored rule before adding another permanent rule or tool.

## 4. Authority order

For an existing repository, apply this order:

1. explicit user authorization and approved planning decision;
2. current formal governance and specifications;
3. root entries according to their stated duties;
4. current long-lived branch task control;
5. current task capsule or parallel-group control;
6. fixed Git commits, tests, artifacts, and execution reports as execution facts;
7. historical documents only for provenance, conflict resolution, or historical review.

A lower-level document cannot silently override a higher-level rule. On material conflict, stop and return to planning review. On branch or source identity conflict, stop immediately under the ownership-conflict state.

## 5. Collaboration model

### 5.1 Formal task types

Every formal task uses one execution type:

- `【规划审查】`: decisions, route, specifications, governance, branch control, task drafting, and closure decisions;
- `【远端实现】`: explicitly authorized code or document changes by ChatGPT/GitHub on a unique task branch;
- `【本地执行】`: implementation, deterministic validation, real artifacts, controlled external calls, Git commit/push, and evidence capture in a unique formal worktree;
- `【并行执行编排】`: Lane allocation, ownership, capacity, shared resources, dependencies, stop rules, and integration order; this type does not itself grant product write permission;
- `【并行结果集成验收】`: fixed-target, one-at-a-time integration, post-integration validation, competitive-candidate selection, and group closure.

UI, schema, migration, security, and release are scope or risk labels. They do not replace the formal execution type.

### 5.2 Roles

A formal capsule declares all roles and uses `not_applicable` rather than blank values:

- `planning_owner`
- `parallel_group_owner`
- `lane_owner`
- `remote_writer`
- `local_writer`
- `validation_owner`
- `integration_owner`
- `closure_owner`

Any responsibility that cannot be expressed as one deterministic command must state:

```yaml
owner:
trigger:
required_action:
evidence:
pass_condition:
failure_action:
```

### 5.3 Human boundary

The user supplies only non-substitutable input such as:

- login, verification code, or external-account authorization;
- business, visual, device, or real-use acceptance;
- major product decisions;
- explicit authorization for merge, deployment, publication, real Provider calls, destructive operations, or other irreversible actions.

The responsible Agent records the human result, binds it to the exact commit or artifact identity, and performs the state transition. Do not assign routine Git, worktree, ownership, retry accounting, integration, or closure work to the user.

## 6. Risk levels

- `L0`: documentation or state correction with no behavior, contract, output, or identity change;
- `L1`: narrow local correction with no shared contract, schema, business, output, template, or release-identity change;
- `L2`: shared behavior, business capability, schema, output, foundation, governance, or cross-component contract change;
- `L3`: release candidate, production delivery, real lifecycle, formal artifact, real external service, device, or user-environment acceptance.

When impact expands, stop scope expansion and obtain an upgraded capsule or planning decision. Do not downgrade shared-contract, business-output, release, or external-service work merely to reduce validation cost.

## 7. Initialization or realignment workflow

### Step 1 — Verify repository identity

Before writing, record:

```bash
git branch --show-current
git status --short
git worktree list --porcelain
git remote -v
git fetch origin --prune
```

Also verify the relevant remote branch and full source SHA. Do not infer the current head from an old task description.

If the worktree is dirty or contains unrelated changes, stop. Do not switch, stash, commit, delete, reset, or overwrite those changes. If operating through a remote GitHub writer, use a unique task branch created from the verified source SHA.

### Step 2 — Inventory existing authority

Classify each expected path as:

- missing and safe to create;
- existing and already authoritative;
- existing but conflicting or unclear;
- historical and not a current entry.

Do not overwrite an authoritative file merely to make it match a template. Conflicting authority requires planning review. `--force` is allowed only when replacement of every named path is explicitly authorized and the replacement diff has been reviewed.

### Step 3 — Prepare verified configuration

Start from `examples/minimal/project-governance.json`. Confirm at least:

- repository and branch route;
- project purpose and code root;
- controlled validation command;
- formal worktree root, or an explicit `not_applicable` decision;
- maximum write and read-only audit Lane counts;
- evidence and local-configuration roots;
- stop budgets.

Fresh projects default to one active write Lane and one read-only audit Lane. Increase write concurrency only through planning review after ownership, isolation, and serial-integration behavior have been demonstrated.

### Step 4 — Dry run

```bash
project-governance-init init \
  --repo-root <target-root> \
  --config <config.json> \
  --dry-run
```

Or from a source checkout without installation:

```bash
python scripts/project_governance_init.py init \
  --repo-root <target-root> \
  --config <config.json> \
  --dry-run
```

Review every `created`, `skipped`, `unchanged`, or `overwritten` path. Use `--json` when another Agent needs machine-readable output.

### Step 5 — Generate missing files

Run the same command without `--dry-run`. Default behavior creates missing files and skips existing files. It does not claim that skipped files comply with the new contract.

For an existing repository, compare current authority with the generated v0.2 contract in a separate temporary directory or branch. Convert only approved differences into a reviewed repository change.

### Step 6 — Replace explicit unknowns

Replace project-specific `[待确认:...]` markers with verified values. Do not invent product decisions, release identities, branch history, worktree paths, owners, or acceptance evidence.

Template placeholders such as `[full SHA]` remain intentionally inside task/report templates. Instantiated task capsules and reports must replace every applicable placeholder and use `not_applicable` for unused fields.

### Step 7 — Validate

```bash
project-governance-init check --repo-root <target-root>
project-governance-init check --repo-root <target-root> --strict
git diff --check
git diff --stat
git diff
```

`check` verifies required paths, UTF-8-readable generated files, contract version, numeric configuration, and unresolved `{{TEMPLATE_TOKEN}}` values. `--strict` also fails on explicit `[待确认]`, `[TODO]`, or `[TBD]` markers. Use `--json` for machine-readable evidence.

Run only project validation whose impact is actually triggered. A governance-only initialization does not automatically require unrelated product tests.

### Step 8 — Commit, push, and review

Explicitly stage only task files. Commit and push the unique task branch. Report:

- repository, long-lived target, task branch, and verified source SHA;
- completed commit and remote push result;
- changed, created, skipped, and unresolved paths;
- validation commands and results;
- current writer ownership and release state;
- unresolved authority conflicts;
- immediate next planning or implementation task.

Do not merge or close a higher-level branch merely because generation and tests passed.

## 8. Formal task-capsule minimum contract

A formal task capsule must include:

```yaml
task_id:
task_type:
risk_level:
repository:
long_lived_target_branch:
task_branch:
source_ref:
source_head:
parallel_type:
parallel_group_id:
lane_id:
formal_worktree_path:
external_call_budgets:
planning_owner:
parallel_group_owner:
lane_owner:
remote_writer:
local_writer:
validation_owner:
integration_owner:
closure_owner:
allowed_changes:
forbidden_changes:
required_context:
required_checks:
acceptance_criteria:
evidence_paths:
shared_resources:
initial_state:
allowed_terminal_states:
stop_budgets:
handoff_contract:
integration_order:
final_report_fields:
```

Rules:

- `source_head` is a full SHA verified immediately before allocation;
- a write task has one unique task branch and one current writer;
- a formal local write task has one assigned formal worktree;
- all call budgets are explicit non-negative integers, never “as needed”;
- allowed and forbidden changes are concrete;
- acceptance is observable;
- unused fields are `not_applicable`, not blank;
- missing or conflicting required fields produce `INVALID_TASK_CAPSULE` before writing begins.

## 9. Branch, worktree, and ownership contract

### 9.1 One branch, one current writer

Prohibited:

- two remote sessions writing one branch;
- two local Agents writing one branch;
- remote and local writers overlapping on one branch;
- direct parallel writes to a shared parent or integration branch;
- automatic pull, merge, rebase, reset, or conflict resolution used to absorb unknown movement.

A formal write Lane is:

```text
one task
+ one unique branch
+ one formal worktree when local
+ one current writer
+ one task capsule
+ one isolated evidence and acceptance path
```

### 9.2 Source lock

At allocation, record `source_ref` and full `source_head`. Before writing, verify that the expected branch, local head, remote head, worktree occupancy, and ownership record match the capsule. Unknown commits, mismatched SHA, or ambiguous ownership immediately produce:

```text
PAUSED_BRANCH_OWNERSHIP_CONFLICT
```

This state does not consume ordinary retry budget.

### 9.3 Narrow stale-local-ref exception

A stale local branch may be aligned only after planning approval and only when all of the following are proven:

- the frozen remote SHA is unchanged;
- fetch succeeds and the tracking ref equals that SHA;
- the local branch has no unique commits and is a strict ancestor of the frozen SHA;
- no worktree has the branch checked out;
- no Lane state, capsule snapshot, or locks have been created;
- no unknown writer or unclosed ownership record exists.

The only allowed mutation is compare-and-set:

```bash
git update-ref refs/heads/<branch> <exact-new-sha> <exact-old-sha>
```

Do not use pull, merge, rebase, reset, checkout, stash, `branch -f`, or force. Compare-and-set failure remains an ownership conflict and does not authorize another mutation.

## 10. States and handoff

Supported states include:

```text
ALLOCATED
REMOTE_WRITING
REMOTE_READY_FOR_LOCAL_VALIDATION
LOCAL_WRITING
WAITING_HUMAN_ACCEPTANCE
LOCAL_ACCEPTED
INTEGRATION
CLOSED
PAUSED_FOR_PLANNING_REVIEW
PAUSED_PARALLEL_LANE
PAUSED_PARALLEL_GROUP
PAUSED_BRANCH_OWNERSHIP_CONFLICT
```

Remote-to-local handoff requires:

1. remote writer commits and pushes;
2. remote branch head is verified against the completed full SHA;
3. changed files and remote validation are reported;
4. remote writer ownership is explicitly released;
5. local receiver fetches and verifies the exact SHA, clean worktree, branch uniqueness, and ownership record;
6. local writer then acquires ownership.

The same fixed-SHA release/acquire pattern applies from local execution to remote review or integration. Never transition directly between writers without commit, push, SHA verification, and ownership release.

## 11. Parallel execution and serial integration

Allowed parallel types:

- `independent_long_lived_branch`
- `child_task_branch`
- `competitive_attempt`
- `read_only_audit`
- `not_applicable`

A parallel group declares capacity, Lane definitions, dependencies, shared resources, group pause triggers, and integration order. Each Lane still has a complete task capsule.

Write results are integrated only after the Lane reaches an accepted state, its commit is pushed and fixed, evidence is complete, and writer ownership is released. A unique `integration_owner` writes the integration target one result at a time and runs impact-matched checks after every step. Competitive attempts select one candidate; do not splice unaccepted candidates together.

A local Lane blocker may pause only that Lane when independent baselines remain trustworthy. Shared-baseline movement, integration-target movement, capacity breach, governance conflict, shared-resource conflict, or cross-Lane evidence contamination pauses the entire group.

## 12. Stop budgets and blocker identity

Default budgets are configurable and begin with:

```yaml
same_blocker_attempt_budget: 2
total_failed_recovery_budget: 4
no_progress_checkpoint_budget: 2
reset_on_agent_change: false
reset_on_model_change: false
reset_on_session_change: false
```

The retry unit is a concrete blocker fingerprint, not a broad error family. Record at least:

```yaml
blocker_family:
error_code:
normalized_error_signature:
operation:
repository_role:
canonical_repository_path:
checkpoint_id:
```

First observation and diagnosis do not automatically consume an attempt. An attempt is consumed only after a material corrective action, rerun of the corresponding checkpoint, new native evidence, and continued failure. Total failed recoveries accumulate across all blockers and do not reset through relabeling, Agent changes, model changes, session changes, or execution-side changes.

Pause when a concrete blocker reaches its attempt limit, total failed recovery reaches its limit, or the configured number of checkpoints produces no new verifiable fact, valid diff, passed gate, or converging blocker.

## 13. Shared resources and irreversible actions

Each shared resource declares:

```yaml
resource:
mode: exclusive | serialized | not_applicable
owner:
acquire_trigger:
release_trigger:
evidence:
conflict_action:
```

Typical resources include external-call identity and budget, visual or office-suite validation, formal release artifacts and version numbers, upper-level governance files, the integration target, and the human-acceptance object bound to a commit/artifact.

Before a real Provider call, publication, deletion, migration, deployment, package replacement, credential change, or other irreversible action, close:

- exact input and output identity;
- external target, model, endpoint, or destination;
- integer call/action budget;
- retry, fallback, concurrency, and stop policy;
- evidence and redaction boundary;
- explicit authorization.

A failed authorized call does not automatically authorize another call, a parameter change, or fallback.

## 14. Document duties and update triggers

- `README.md`: stable project purpose and navigation;
- `AGENTS.md`: long-lived execution discipline;
- `CHATGPT.md`: remote planning, implementation, orchestration, and review discipline;
- `PLANS.md`: current repository route, active branches, governance limits, and immediate next task;
- `VERSION_MATRIX.md`: version and formal artifact identity;
- project governance: durable collaboration contract;
- branch task control: one long-lived branch objective, boundary, baselines, gates, and next task;
- task capsule: one execution authorization;
- parallel-group control: Lane allocation, dependencies, resources, pause rules, and integration order;
- reports: one review, execution, handoff, or integration fact set.

Do not update plans mechanically because code changed. Update long-lived documents only when their actual route, boundary, status, next-task, specification, governance, version, or identity duty is triggered.

## 15. Definition of done

Initialization or realignment is complete only when:

- required governance entries exist or are explicitly classified as existing authority;
- project-specific unknown markers are resolved or consciously left as a blocking planning item;
- task types, roles, source lock, ownership, states, budgets, shared resources, handoff, and integration rules are internally consistent;
- generated files pass normal and strict checks when declaring completion;
- no existing authority was overwritten without explicit approval;
- the task commit is pushed and its full SHA is verified;
- writer ownership is released or intentionally retained in a declared state;
- remote ChatGPT and a local Agent can continue from repository authority without hidden chat history.
