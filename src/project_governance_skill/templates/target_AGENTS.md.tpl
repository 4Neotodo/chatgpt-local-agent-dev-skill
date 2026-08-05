# AGENTS.md

## 1. Purpose

This is the repository-level long-term operating entry for every authorized Agent working in `{{PROJECT_NAME}}`, including remote ChatGPT, Codex, Claude Code, Kimi, Gemini CLI, or another local/remote Agent.

Do not rely on chat history alone. Do not treat a historical branch, sample, implementation, test, artifact, or report as the repository's permanent current state.

Current collaboration authority:

- `docs/00_project_overview/PROJECT_GOVERNANCE.md`;
- `docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md`;
- `docs/02_dev_plans/PARALLEL_GROUP_CONTROL_TEMPLATE.md`.

## 2. Context selection and authority

Before execution:

1. verify repository, remote, actual branch, full HEAD, worktree, and ownership state;
2. read the explicit user authorization and current task capsule;
3. locate the long-lived target branch task control or directly corresponding plan;
4. determine what the task actually needs to understand and decide;
5. read directly relevant formal decisions, specifications, code, tests, and assets;
6. read history only to resolve conflict, provenance, or an explicitly historical question.

Do not mechanically require every task to read `README.md`, `PLANS.md`, `VERSION_MATRIX.md`, every specification, and every prior report. Prefer original authority while context is manageable. A sourced summary may assist when volume or duplication materially harms execution, but it does not replace authority.

Entry duties:

- `README.md`: stable project description and minimum navigation;
- `CHATGPT.md`: remote planning, implementation, orchestration, and review discipline;
- `PLANS.md`: current repository route, active long-lived branches, governance limits, and immediate next task;
- `VERSION_MATRIX.md`: formal version, artifact, and historical identity;
- project governance: collaboration, ownership, worktree, Lane, state, budget, and integration contract;
- branch task control: one long-lived branch objective, boundary, baselines, gates, and next task;
- task capsule: one execution authorization;
- Git, tests, artifacts, evidence, and reports: one execution's facts.

A lower-level capsule cannot silently change a higher-level decision. Material conflict requires planning review. Source or branch ownership conflict requires immediate pause.

## 3. Formal task types

| Task type | Default execution side | Writable scope |
|---|---|---|
| `【规划审查】` | ChatGPT / GitHub | decisions, plans, specifications, governance, branch control, task drafting, and necessary indexes; remote writes only when authorized |
| `【远端实现】` | ChatGPT / GitHub | one unique task branch and explicitly listed code or document paths |
| `【本地执行】` | authorized local Agent | one assigned formal worktree and capsule-authorized code, tests, assets, evidence, and triggered documents |
| `【并行执行编排】` | ChatGPT or named orchestrator | group/Lane allocation, ownership, capacity, shared resources, pause rules, and integration order; no implicit product write scope |
| `【并行结果集成验收】` | unique integration owner | one fixed integration target, accepted Lane commits, post-step validation, and closure |

UI, schema, migration, security, and release are labels, not substitutes for a formal execution type.

The formal capsule must include all required roles. Unused roles and fields are `not_applicable`, not blank. Missing or contradictory required fields return:

```text
INVALID_TASK_CAPSULE
```

## 4. Risk levels

### L0 — Documentation or state correction

No product behavior, shared contract, output semantics, schema, template, or version identity change.

- modify only target documents;
- verify anchors, links, states, markers, and final diff;
- do not run unrelated product tests;
- update other entries only when their duty is genuinely triggered.

### L1 — Narrow local correction

No shared contract, business rule, output semantics, schema, template, or release identity change.

- deterministic reproduction/direct tests;
- necessary small regression only;
- no release packaging, full lifecycle, or device acceptance;
- no ceremonial closure task after acceptance and push.

### L2 — Shared behavior, capability, or foundation change

Shared module, business behavior, schema, validation, output, template, foundation, governance, or cross-component contract.

- direct tests and impact-matched regression;
- applicable real sample, file, visual, or integration evidence;
- update durable documents only when their trigger occurs;
- do not perform L3 work unless explicitly upgraded.

### L3 — Release candidate or formal delivery

Formal artifact, release, production lifecycle, real Provider/external service, device, or user-environment acceptance.

Apply the task-required combination of packaging closure, artifact size/SHA256/source commit, install/update/uninstall lifecycle, production path, real external call, device/user acceptance, release note, and version-matrix update.

If impact expands, stop scope expansion and request an upgraded capsule or planning review. Do not downgrade shared-contract, business-output, or release work to reduce validation cost.

## 5. Required execution order

Every task must:

1. verify repository, target route, remote source ref and full SHA;
2. verify task branch, worktree, current writer, Lane, and clean state;
3. confirm task type, risk, owners, allowed scope, forbidden scope, call budgets, shared resources, acceptance, and stop budgets;
4. read and modify only directly required files;
5. preserve formal specification and schema semantics unless change is authorized;
6. run the smallest validation set that fully proves actual impact;
7. update plans/specifications/governance/version only when a real trigger occurs;
8. commit and push only the task branch, verify full remote SHA, and release or hand off writer ownership;
9. report according to task type and risk;
10. do not continue into the next task or phase unless the capsule explicitly combines that exact closure.

Changing product scope, architecture, formal specification, support boundary, governance, long-lived branch objective, stop budget, Lane ceiling, or version identity requires `【规划审查】`.

## 6. Git, branch, and worktree safety

### 6.1 Start gate

Before local edits:

```bash
git branch --show-current
git status --short
git worktree list --porcelain
git fetch origin --prune
```

Required facts:

- current repository and task branch match the capsule;
- task-branch HEAD equals the capsule's fixed `source_head` or accepted handoff SHA;
- worktree is clean;
- branch is not checked out by another worktree;
- writer ownership is unique and consistent;
- capacity and shared-resource rules permit execution.

Do not use generic `git pull` as the identity gate. The capsule must define exact source relation and allowed synchronization. Stop on unrelated changes; do not switch, stash, reset, commit, delete, merge, rebase, or rewrite another writer's state.

### 6.2 One branch, one writer

Prohibited:

- two remote sessions writing one branch;
- two local Agents writing one branch;
- remote and local writers overlapping;
- parallel child tasks writing the shared parent/integration branch;
- automatic pull/merge/rebase/conflict resolution used to absorb unknown movement;
- an implementation Agent integrating its own result by default.

A formal write Lane is one task + one unique task branch + one formal worktree when local + one current writer + one complete capsule + one isolated evidence/acceptance path.

Unknown commits, mismatched SHA, ambiguous ownership, or unexpected worktree occupancy immediately return:

```text
PAUSED_BRANCH_OWNERSHIP_CONFLICT
```

Do not spend ordinary retry budget on identity conflicts.

### 6.3 Formal worktree rules

```yaml
formal_worktree_root: {{FORMAL_WORKTREE_ROOT}}
auto_worktree_root: {{AUTO_WORKTREE_ROOT}}
maximum_active_write_lanes: {{MAXIMUM_ACTIVE_WRITE_LANES}}
maximum_read_only_audit_lanes: {{MAXIMUM_READ_ONLY_AUDIT_LANES}}
```

- formal local writes use the assigned path under the approved formal root;
- automatically managed worktree retention does not grant formal write concurrency;
- do not create clone/worktree paths outside approved roots;
- do not modify or reuse evidence from sibling worktrees;
- temporary evidence goes to `{{EVIDENCE_ROOT}}/<task-id>/` unless explicitly overridden;
- local configuration goes to `{{LOCAL_CONFIG_ROOT}}/`;
- cleanup requires pushed commit, registered evidence, released ownership, recoverability, and `closure_owner` approval.

### 6.4 Narrow stale-reference recovery

A stale, unoccupied local branch may be aligned only after planning approval and proof that the frozen remote SHA is unchanged, the local branch has no unique commits and is its strict ancestor, no worktree/state/locks exist, and ownership is closed.

Only this compare-and-set is allowed:

```bash
git update-ref refs/heads/<branch> <exact-new-sha> <exact-old-sha>
```

Failure remains `PAUSED_BRANCH_OWNERSHIP_CONFLICT`. Do not fall back to pull, merge, rebase, reset, checkout, stash, force, or `branch -f`.

## 7. Parallel execution and integration

Allowed parallel types:

```text
independent_long_lived_branch
child_task_branch
competitive_attempt
read_only_audit
not_applicable
```

Each Lane independently declares full capsule fields. A parallel group declares capacity, dependencies, shared resources, group pause triggers, and serial integration order.

A Lane can enter integration only after accepted validation, pushed fixed commit, complete evidence, declared risk, and writer ownership release. A unique `integration_owner` owns the target branch, integrates one result at a time, validates after every step, and pauses on target movement, SHA mismatch, conflict, or failed gate. A competitive group selects one candidate and does not splice unaccepted candidates.

## 8. States and handoff

Supported states:

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

Remote-to-local handoff requires remote commit/push, remote-head verification, complete changed-file and validation report, and ownership release. Local receiver then fetches, verifies the exact SHA, clean worktree, unique branch occupancy, and ownership record before acquiring ownership.

The same release/acquire sequence applies from local execution to remote review or integration. Do not skip commit, push, full-SHA verification, or ownership release.

## 9. Stop budgets and blocker identity

Defaults:

```yaml
same_blocker_attempt_budget: {{SAME_BLOCKER_ATTEMPT_BUDGET}}
total_failed_recovery_budget: {{TOTAL_FAILED_RECOVERY_BUDGET}}
no_progress_checkpoint_budget: {{NO_PROGRESS_CHECKPOINT_BUDGET}}
reset_on_agent_change: false
reset_on_model_change: false
reset_on_session_change: false
```

The retry unit is a concrete blocker fingerprint:

```yaml
blocker_family:
error_code:
normalized_error_signature:
operation:
repository_role:
canonical_repository_path:
checkpoint_id:
```

First observation is diagnostic and does not automatically consume an attempt. An attempt requires a material corrective action, rerun of the corresponding checkpoint, new native evidence, and continued failure. Changing Agent, model, session, wording, or equivalent command does not reset or create a new blocker. Total failed recovery accumulates across blockers and execution sides.

Pause when one blocker exhausts its budget, total failed recovery reaches its limit, or no-progress checkpoints reach the limit. Identity conflicts pause immediately outside ordinary retry accounting.

## 10. Validation discipline

Validation matches real impact:

- L0: target content, links, status, markers, and final diff;
- L1: deterministic reproduction/direct tests and necessary small regression;
- L2: direct tests, necessary regression, and applicable real sample/file/visual/integration evidence;
- L3: L2 plus release closure, artifact identity, lifecycle, real external service, device, or user acceptance.

Primary validation:

```text
{{TEST_COMMAND}}
```

Primary code root:

```text
{{CODE_ROOT}}
```

Use the repository-controlled runtime when present. A system runtime missing dependencies while the controlled runtime works is command-selection friction, not product failure. Do not install globally merely to bypass the controlled environment.

For long-running commands, preserve and poll the original process to native exit. Do not start duplicate runs while it may still be active. If visual proof is required, use actual visual evidence; structural checks supplement rather than silently replace it.

## 11. External calls and irreversible actions

Before any real Provider/external call, publication, deployment, deletion, migration, artifact replacement, credential change, or other irreversible action, close:

- authoritative input/output identities;
- exact target/model/endpoint;
- explicit integer call/action budget;
- retry, fallback, concurrency, and stop policy;
- evidence and redaction boundary;
- explicit authorization.

If identity or authorization is incomplete, stop before acting. A failed authorized run does not authorize another call, changed parameters, fallback, or parallel call.

Shared resources declare mode, owner, acquire/release trigger, evidence, and conflict action. Provider identity/budget, visual or office-suite validation, formal release artifacts, governance files, integration target, and human-acceptance object commonly require exclusive or serialized access.

## 12. Document and evidence discipline

Code changes do not mechanically update plans. Update long-lived documents only when task/branch/phase state, route, next task, product boundary, formal specification, governance, version, or artifact identity changes.

One-time commands, tests, Provider calls, artifacts, and run facts belong in Git, test output, `{{EVIDENCE_ROOT}}/<task-id>/`, and execution reports.

Retain local evidence across tasks only when an authorized downstream task explicitly depends on it. Record path, identity, provenance, downstream reader/purpose, and cleanup condition. Missing or provenance-broken evidence blocks the downstream task and is not silently replaced.

## 13. Reporting and governance feedback

Every write task reports full source SHA, task branch, completed commit, push, current state, writer ownership release, final remote head, and final worktree status.

Every local task separately reports:

- task-result blocker;
- execution-process blocker;
- non-blocking friction;
- whether the issue repeats;
- whether current rules are sufficient;
- whether the recommendation is a capsule fix, governance review, or approved tool task.

An executor reports facts and recommendations only. It does not self-authorize governance, scope, architecture, specification, version, budget, or Lane-limit changes.

## 14. Data and security

- Primary documentation language: `{{PRIMARY_LANGUAGE}}`.
- Code identifiers, schema keys, and CLI parameters may use English.
- Do not commit secrets, credentials, unredacted private material, raw sensitive Provider requests/responses, or sensitive logs.
- Historical tests and artifacts prove only their corresponding version and path.
- Do not modify expected artifacts to hide unapproved behavior changes.
