# {{PROJECT_NAME}} — Project Development Collaboration and Governance Decision v{{GOVERNANCE_CONTRACT_VERSION}}

**Status:** Generated baseline / Planning confirmation required
**Repository:** `{{REPOSITORY}}`
**Created:** {{CREATED_DATE}}

## 1. Nature and boundary

This document defines the shared governance baseline for remote ChatGPT, local Agents, GitHub, formal worktrees, parallel execution, evidence, and human acceptance. It governs who may decide, who may write, where execution occurs, how identity is fixed, how results are handed off, when work pauses, and how integration closes.

It does not decide product scope, architecture, business rules, technical stack, Provider selection, release identity, or support boundaries. Those require project-specific planning and specifications.

Governance must remain necessary, simple, and worth its maintenance cost. Correct a bad task instruction, authority path, or ignored rule before adding a new permanent rule or tool. Do not build a database, Web control plane, universal task engine, approval service, or complex lock platform unless repeated cross-project value clearly exceeds cost.

## 2. Authority and context

Apply this order:

1. explicit user authorization and approved planning decision;
2. current formal governance and specifications;
3. root entries according to their duties;
4. current long-lived branch task control;
5. current task capsule or parallel-group control;
6. fixed Git commits, tests, artifacts, and reports as execution facts;
7. historical material only for provenance, conflict resolution, or historical review.

First identify what the task actually needs to understand and decide, then read directly relevant authority. Do not mechanically load every root document, old plan, and report. Original authority is preferred while context remains manageable; a sourced summary may assist but never replaces authority.

## 3. Formal task types and risk

### 3.1 Task types

| Task type | Default execution side | Default responsibility |
|---|---|---|
| `【规划审查】` | ChatGPT / GitHub | decisions, route, specifications, governance, branch control, task drafting, and higher-level closure |
| `【远端实现】` | ChatGPT / GitHub | explicitly authorized code or document changes on one unique task branch, followed by commit, push, SHA verification, and ownership release |
| `【本地执行】` | authorized local Agent | implementation, controlled runtime, real validation/artifacts, authorized external calls, Git evidence, and execution report in one formal worktree |
| `【并行执行编排】` | ChatGPT or named orchestrator | parallel group, Lane, ownership, capacity, shared resources, pause rules, and integration order; no implicit product write right |
| `【并行结果集成验收】` | unique integration owner | fixed-target, one-at-a-time integration, post-step validation, candidate selection, and group closure |

UI, schema, migration, security, and release are labels attached to a formal task type. They do not determine writer identity by themselves.

### 3.2 Risk levels

- `L0`: document or state correction with no behavior, shared contract, output, or identity change;
- `L1`: narrow local correction with no shared contract, business, schema, output, template, or release-identity change;
- `L2`: shared behavior, business capability, schema, output, foundation, governance, or cross-component contract change;
- `L3`: release candidate, formal artifact, production lifecycle, real external service, device, or user-environment acceptance.

Task type assigns responsibility. Risk level assigns validation, evidence, documentation, and reporting intensity. Neither authorizes unrelated changes.

## 4. Roles and human boundary

Every formal capsule declares:

```yaml
planning_owner:
parallel_group_owner:
lane_owner:
remote_writer:
local_writer:
validation_owner:
integration_owner:
closure_owner:
```

Unused roles are `not_applicable`, never blank.

Any non-trivial responsibility that cannot be reduced to one deterministic assertion uses:

```yaml
owner:
trigger:
required_action:
evidence:
pass_condition:
failure_action:
```

The user is not the default Git operator, worktree manager, Lane scheduler, retry accountant, evidence clerk, integration operator, or closure owner. The user supplies only non-substitutable login/verification, business/visual/device acceptance, major product decisions, and explicit authorization for merge, release, deployment, real external calls, deletion, migration, or other irreversible operations. The responsible Agent binds the human result to the exact commit or artifact identity and performs the state transition.

## 5. One branch, one current writer

At any moment, one branch has at most one current writer.

Prohibited:

- two remote ChatGPT sessions writing one branch;
- two local Agents writing one branch;
- remote and local writers overlapping on one branch;
- multiple child tasks directly writing their shared parent branch;
- implementation Agents integrating their own results by default;
- automatic pull, merge, rebase, reset, stash, force, or conflict resolution used to absorb unknown movement.

A formal write Lane is:

```text
one task
+ one unique task branch
+ one formal worktree when local
+ one current writer
+ one complete task capsule
+ one isolated evidence and acceptance path
```

Branch ownership records at least:

```yaml
repository:
branch:
source_ref:
source_head:
parallel_group_id:
lane_id:
current_writer:
writer_type: remote | local | not_applicable
acquired_at:
expected_release_condition:
last_verified_remote_head:
state:
```

Unknown commits, mismatched source SHA, multiple writers, ambiguous ownership, or unexpected worktree occupancy immediately produce `PAUSED_BRANCH_OWNERSHIP_CONFLICT`. This does not consume ordinary retry budget.

## 6. Git and source-lock contract

Every write task fixes a `source_ref` and full `source_head` immediately before allocation. A task branch must be created from or verified against that exact source. Historical task text is not sufficient evidence of current head.

Before local writing, verify:

```bash
git branch --show-current
git status --short
git worktree list --porcelain
git fetch origin --prune
```

Then prove:

- current repository and task branch match the capsule;
- task-branch head equals the verified source or accepted handoff SHA;
- worktree is clean;
- branch is not checked out by another formal worktree;
- current writer and Lane records are consistent;
- capacity and shared-resource rules permit execution.

Do not use a generic `git pull` as the source-identity gate. A task that requires synchronization must define the exact source, expected relation, allowed operation, and failure action.

### 6.1 Narrow stale-local-reference exception

A local branch that merely lags a frozen remote SHA may be classified as `stale_unoccupied_local_ref` only when all are proven:

1. frozen remote branch and full SHA are unchanged;
2. fetch succeeds and the tracking ref equals the frozen SHA;
3. local branch has zero unique commits and is a strict ancestor of that SHA;
4. no worktree has the branch checked out;
5. no Lane worktree, state, capsule snapshot, or locks exist;
6. no unknown writer, reflog movement, or unclosed ownership record exists;
7. planning owner explicitly approves exact alignment.

The only allowed mutation is:

```bash
git update-ref refs/heads/<branch> <exact-frozen-sha> <exact-old-local-sha>
```

The old SHA is a compare-and-set precondition. Failure remains an ownership conflict. Do not fall back to pull, merge, rebase, reset, checkout, stash, `branch -f`, or force.

## 7. Formal worktrees and local execution

Configured roots:

```yaml
formal_worktree_root: {{FORMAL_WORKTREE_ROOT}}
auto_worktree_root: {{AUTO_WORKTREE_ROOT}}
evidence_root: {{EVIDENCE_ROOT}}
local_config_root: {{LOCAL_CONFIG_ROOT}}
```

A formal local write task uses an explicitly assigned worktree under the approved formal root. An automatically managed temporary worktree may be used only when the capsule permits its short-lived purpose; automatic retention count never implies formal parallel-write capacity.

Local Agents:

- write only in their assigned worktree and branch;
- do not enter sibling worktrees to modify files or reuse temporary evidence;
- use `{{EVIDENCE_ROOT}}/<task-id>/` for isolated temporary evidence unless the task specifies another approved path;
- use `{{LOCAL_CONFIG_ROOT}}/` only for explicit local configuration;
- do not self-authorize worktree creation outside approved roots;
- do not delete a formal worktree until the commit is pushed, evidence is registered, ownership is released, recovery is possible, and `closure_owner` approves cleanup.

Lifecycle:

```text
allocate
→ create/attach approved worktree
→ verify fixed source SHA and ownership
→ write/validate
→ commit/push
→ release writer ownership
→ local or human acceptance
→ serial integration when authorized
→ close
→ remove worktree and archive the minimum recovery/evidence manifest
```

## 8. Parallel types and capacity

Allowed `parallel_type` values:

- `independent_long_lived_branch`
- `child_task_branch`
- `competitive_attempt`
- `read_only_audit`
- `not_applicable`

Configured ceilings:

```yaml
maximum_active_write_lanes: {{MAXIMUM_ACTIVE_WRITE_LANES}}
maximum_read_only_audit_lanes: {{MAXIMUM_READ_ONLY_AUDIT_LANES}}
```

These are ceilings, not required concurrency. Increase them only by planning review after clean pilots demonstrate no ownership conflict, wrong source baseline, cross-Lane evidence contamination, or unsafe integration behavior.

### 8.1 Independent long-lived branches

Different long-lived routes may execute in parallel when branch objective, write scope, evidence, and acceptance are independent. Shared resources remain serialized or exclusive. Merge or release still requires separate authorization.

### 8.2 Child task branches

Parallel child tasks start from one verified parent SHA but use different task branches and worktrees. They are independently validated and then integrated one at a time by the unique integration owner. They do not directly write the parent branch.

### 8.3 Competitive attempts

Every candidate uses the same frozen baseline, evaluation data, budget, and acceptance criteria on a different branch/worktree. Exactly one accepted candidate may enter integration. Unselected candidates are closed or archived; do not splice unaccepted fragments together.

### 8.4 Read-only audit

Audit target is one full commit SHA. `remote_writer` and `local_writer` are `not_applicable`; no commit is produced. A finding that requires modification creates a new write task and branch.

## 9. States and transitions

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

Key transitions:

- `ALLOCATED → REMOTE_WRITING`: unique remote writer acquires branch ownership;
- `ALLOCATED → LOCAL_WRITING`: local writer and formal worktree pass preflight and acquire ownership;
- `REMOTE_WRITING → REMOTE_READY_FOR_LOCAL_VALIDATION`: remote commit/push, remote-head verification, report, and ownership release complete;
- `REMOTE_READY_FOR_LOCAL_VALIDATION → LOCAL_WRITING`: local fetch, exact-SHA verification, clean worktree, and ownership acquisition complete;
- `LOCAL_WRITING → WAITING_HUMAN_ACCEPTANCE`: machine validation is complete but non-substitutable human acceptance remains;
- `LOCAL_WRITING → LOCAL_ACCEPTED`: all required local/machine validation passes;
- `WAITING_HUMAN_ACCEPTANCE → LOCAL_ACCEPTED`: validation owner records human result against frozen identity;
- `LOCAL_ACCEPTED → INTEGRATION`: integration owner acquires the fixed integration target;
- `INTEGRATION → CLOSED`: serial integration, post-checks, push, ownership release, and cleanup conditions pass.

Do not jump between writers without commit, push, exact-SHA verification, and ownership release. Do not automatically resume from a pause state; the named owner must use new evidence and an allowed recovery contract.

## 10. Task capsule contract

Every formal task capsule includes:

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

Unused fields are `not_applicable`, not blank. Call budgets are explicit non-negative integers, never “as needed”. Allowed/forbidden scope is concrete. Acceptance is observable. A missing or contradictory required field returns `INVALID_TASK_CAPSULE` before writing begins.

## 11. Shared resources

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

At minimum consider:

- real external-call budget and fixed identity;
- office-suite, browser, visual, device, or user acceptance;
- formal release artifact and version number;
- upper-level governance files;
- integration target branch;
- human-acceptance object bound to a commit/artifact.

A resource conflict that affects only one independent Lane may pause that Lane. A conflict involving shared baseline, integration target, governance authority, capacity, or cross-Lane evidence pauses the whole group.

## 12. Stop budgets and blocker fingerprint

Defaults:

```yaml
same_blocker_attempt_budget: {{SAME_BLOCKER_ATTEMPT_BUDGET}}
total_failed_recovery_budget: {{TOTAL_FAILED_RECOVERY_BUDGET}}
no_progress_checkpoint_budget: {{NO_PROGRESS_CHECKPOINT_BUDGET}}
reset_on_agent_change: false
reset_on_model_change: false
reset_on_session_change: false
```

The same-blocker budget applies to a concrete blocker fingerprint, not a broad family. Record:

```yaml
blocker_family:
error_code:
normalized_error_signature:
operation:
repository_role:
canonical_repository_path:
checkpoint_id:
```

Changing Agent, model, session, wording, or an equivalent command does not create a new blocker. A new concrete blocker requires a materially different operation, repository role, canonical path, or passed checkpoint, supported by evidence.

First observation is diagnosis and does not automatically consume an attempt. An attempt is consumed only when a material corrective action is applied, the corresponding checkpoint is rerun, new native evidence is obtained, and the pass condition still fails. Total failed recoveries accumulate across all blockers and do not reset by reclassification or execution-side change.

Pause when:

- one concrete blocker exhausts its attempt budget;
- total failed recovery reaches its limit;
- the configured number of checkpoints yields no new verifiable fact, valid diff, passed gate, or blocker convergence;
- source/ownership identity fails, which pauses immediately without ordinary budget use.

## 13. Validation and controlled runtime

Validation matches actual impact:

- L0: target text, links, state, placeholders, and final diff;
- L1: deterministic reproduction/direct tests and necessary small regression;
- L2: direct tests, impact-matched regression, and applicable real sample/file/visual/integration evidence;
- L3: L2 plus release closure, artifact identity, lifecycle, real external service, device, or user acceptance.

Primary validation:

```text
{{TEST_COMMAND}}
```

Use the repository-controlled runtime or virtual environment when present. A system runtime missing test dependencies while the controlled runtime works is command-selection friction, not a product failure. Do not install globally merely to bypass the controlled environment.

For a long-running command, preserve and poll the same process to native exit. Do not start duplicate runs while the original may still be active. Visual acceptance requires actual visual evidence when the task demands it; structural checks supplement rather than silently replace it.

## 14. External and irreversible actions

Before a real Provider call, publication, deployment, deletion, migration, package replacement, credential change, or other irreversible action, fix and record:

- authoritative input paths and identities;
- output/destination identity and overwrite policy;
- Provider/model/endpoint or external target;
- explicit integer action/call budget;
- retry, fallback, concurrency, and stop policy;
- evidence and redaction boundary;
- explicit authorization.

If any identity or authorization is incomplete, stop before acting. A failed authorized run does not automatically authorize another call, changed parameters, fallback, or parallel call.

## 15. Serial integration and closure

A Lane may enter integration only when:

- it is `LOCAL_ACCEPTED` or an explicitly equivalent accepted remote terminal state;
- completed commit is pushed and its full SHA is verified;
- writer ownership is released;
- validation and evidence are complete;
- unresolved risk is declared;
- no unknown remote commit exists.

The unique `integration_owner`:

1. fixes the integration-target branch and full source SHA;
2. acquires exclusive ownership;
3. fetches and verifies every accepted Lane commit;
4. integrates one Lane at a time in frozen order;
5. runs impact-matched validation after every step;
6. pauses on target movement, candidate mismatch, conflict, or failed gate;
7. selects only one competitive candidate;
8. pushes the final result, releases ownership, and hands closure to `closure_owner`.

The implementing Agent does not self-integrate by default. The user is not the routine integration operator.

## 16. Documents and evidence

Execution facts and long-lived conclusions remain separate:

- Git, tests, artifacts, `{{EVIDENCE_ROOT}}/<task-id>/`, and reports record one execution;
- governance, specifications, `PLANS.md`, branch control, and `VERSION_MATRIX.md` record durable authority.

Code changes do not mechanically update planning documents. Update a long-lived entry only when its route, branch objective, boundary, baseline, gate, next task, specification, governance, version, or artifact identity actually changes.

Retain local evidence across tasks only when an authorized downstream task depends on it. Record exact path, identity/SHA256 when material, provenance, downstream reader and purpose, and cleanup condition. Missing or provenance-broken evidence blocks the downstream task and is not silently replaced by a new random or external run.

## 17. Governance iteration

Execution reports may recommend improvements but do not self-authorize new rules or implementation scope.

Process recommendations in this order:

1. determine whether the task capsule, path, command, evidence, or existing-rule compliance was wrong; fix the task first;
2. only when a repeated cross-task rule is missing or must change, conduct planning review and update formal governance;
3. implement approved scripts/tests/checks as an explicit execution task;
4. combine rule and implementation only when the decision is already frozen and atomic change is necessary.

## 18. Confirmation

This generated baseline becomes current only after planning review confirms project-specific branch route, worktree roots, Lane ceilings, owners, specifications, acceptance boundaries, shared resources, and first task control. Until then, implementation is not authorized merely because files were generated.
