# Formal Task Capsule — [Task ID]

A formal task must replace every applicable bracketed placeholder. Use `not_applicable` for unused fields; do not leave required values blank. A missing or contradictory required field returns `INVALID_TASK_CAPSULE` before writing begins.

## 1. Complete contract

```yaml
task_id: [stable task id]
task_type: [【规划审查】 | 【远端实现】 | 【本地执行】 | 【并行执行编排】 | 【并行结果集成验收】]
risk_level: [L0 | L1 | L2 | L3]
repository: [owner/name]
long_lived_target_branch: [branch]
task_branch: [unique branch or not_applicable for a fixed-SHA read-only audit]
source_ref: [refs/heads/... or another exact ref]
source_head: [full commit SHA verified immediately before allocation]
parallel_type: [independent_long_lived_branch | child_task_branch | competitive_attempt | read_only_audit | not_applicable]
parallel_group_id: [id or not_applicable]
lane_id: [id or not_applicable]
formal_worktree_path: [approved path or not_applicable]

external_call_budgets:
  provider_calls: 0
  network_tokenization_calls: 0
  other_external_actions: 0

planning_owner: [named owner]
parallel_group_owner: [named owner or not_applicable]
lane_owner: [named owner]
remote_writer: [one remote writer or not_applicable]
local_writer: [one local writer or not_applicable]
validation_owner: [named owner]
integration_owner: [named owner or not_applicable]
closure_owner: [named owner]

one_task_objective: [one independently acceptable closure]
allowed_changes:
  - [exact path, behavior, or contract]
forbidden_changes:
  - [exact path, behavior, contract, or operation]
required_context:
  - [minimum authoritative path/ref]
required_checks:
  - [preflight or validation command/check]
acceptance_criteria:
  - [observable pass condition]
evidence_paths:
  - [approved task-isolated path]
shared_resources:
  - resource: [name or not_applicable]
    mode: [exclusive | serialized | not_applicable]
    owner: [owner or not_applicable]
    acquire_trigger: [trigger or not_applicable]
    release_trigger: [trigger or not_applicable]
    evidence: [evidence or not_applicable]
    conflict_action: [pause state or not_applicable]

initial_state: [ALLOCATED or another allowed state]
allowed_terminal_states:
  - [CLOSED or accepted/pause state]
stop_budgets:
  same_blocker_attempt_budget: {{SAME_BLOCKER_ATTEMPT_BUDGET}}
  total_failed_recovery_budget: {{TOTAL_FAILED_RECOVERY_BUDGET}}
  no_progress_checkpoint_budget: {{NO_PROGRESS_CHECKPOINT_BUDGET}}
  reset_on_agent_change: false
  reset_on_model_change: false
  reset_on_session_change: false

handoff_contract:
  producer_release_condition: [commit/push/full-SHA verification/report/ownership release]
  receiver_acquire_condition: [fetch/exact-SHA/worktree/ownership verification]
  mismatch_action: PAUSED_BRANCH_OWNERSHIP_CONFLICT
integration_order: [integer/list or not_applicable]
final_report_fields:
  - repository
  - long_lived_target_branch
  - verified_source_head
  - task_branch
  - completed_commit_sha
  - push_result
  - changed_files
  - validation
  - external_calls_used
  - current_state
  - writer_ownership_released
  - unresolved_conflicts_or_risks
  - next_task
  - final_branch_head
  - final_worktree_status
```

## 2. Required executable responsibility blocks

For every non-trivial responsibility not reducible to one deterministic assertion, add:

```yaml
owner: [role]
trigger: [exact state/event]
required_action: [bounded action]
evidence: [native output/path/hash/decision]
pass_condition: [observable condition]
failure_action: [specific pause or return state]
```

Do not use “the user will decide later”, “handle as needed”, “someone checks it”, or “manual closure” as formal execution rules.

## 3. Task-type addenda

### 3.1 `【规划审查】`

```yaml
review_questions:
  - [decision question]
decision_scope:
  - [included decision]
upstream_documents:
  - [authority]
downstream_documents:
  - [triggered document]
remote_write_authorized: [true | false]
```

Allowed terminal states normally include `CLOSED`, `PAUSED_FOR_PLANNING_REVIEW`, and `PAUSED_BRANCH_OWNERSHIP_CONFLICT`. If remote writing occurs, commit, push, full-SHA verification, and ownership release are required before closure.

### 3.2 `【远端实现】`

```yaml
remote_edit_files:
  - [path]
remote_validation:
  - [check]
local_validation_required: [true | false]
remote_release_condition: [condition]
```

The remote writer uses one unique task branch. Completion transitions to `REMOTE_READY_FOR_LOCAL_VALIDATION` unless all acceptance is explicitly remote and closure is authorized.

### 3.3 `【本地执行】`

```yaml
preflight_commands:
  - git branch --show-current
  - git status --short
  - git worktree list --porcelain
  - git fetch origin --prune
implementation_scope:
  - [scope]
validation_commands:
  - [command]
human_acceptance_required: [true | false]
cleanup_policy: [condition]
```

Local writing begins only after exact branch/SHA/worktree/ownership/capacity/resource verification. Do not bypass a failed gate with stash, automatic pull, merge, rebase, reset, or force.

### 3.4 `【并行执行编排】`

```yaml
parallel_group_id: [id]
lanes:
  - [complete Lane capsule reference]
maximum_active_write_lanes: [integer]
maximum_read_only_audit_lanes: [integer]
shared_resource_schedule:
  - [resource plan]
group_pause_triggers:
  - [trigger]
integration_order:
  - [lane id]
```

Every Lane still requires a complete task contract. Orchestration does not grant product write authority.

### 3.5 `【并行结果集成验收】`

```yaml
integration_target_branch: [branch]
integration_source_head: [full SHA]
accepted_lane_commits:
  - lane_id: [id]
    commit: [full SHA]
    ownership_released: true
integration_order:
  - [lane id]
post_integration_checks:
  - [check]
competitive_selection_rule: [rule or not_applicable]
rollback_or_pause_rule: [rule]
```

The integration owner writes the target alone and integrates one candidate at a time. Target movement, candidate mismatch, unresolved conflict, or failed gate pauses integration.

## 4. Git and source-identity gate

Before any write, prove:

- repository and remotes match the capsule;
- remote `source_ref` resolves to exact `source_head`;
- task branch is unique and its current head is expected;
- formal local worktree is approved, clean, and not reused;
- current writer is unique and ownership record is closed;
- active Lane count and shared resources permit execution.

Any unknown commit, source mismatch, duplicate writer, or unexpected worktree occupancy returns:

```text
PAUSED_BRANCH_OWNERSHIP_CONFLICT
```

Do not consume ordinary retry budget and do not auto-pull/merge/rebase to continue.

## 5. States

Allowed state vocabulary:

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

For every non-obvious state transition, identify owner, trigger, action, evidence, pass condition, and failure action. A paused task never resumes automatically.

## 6. Stop-budget record

When a blocker appears, record:

```yaml
blocker_id: [stable id]
blocker_family: [broad category]
error_code: [stable code/category]
normalized_error_signature: [dynamic values removed]
operation: [failed operation]
repository_role: [control repository/formal worktree/remote/etc.]
canonical_repository_path: [normalized exact path]
checkpoint_id: [stable checkpoint]
first_observed_at: [timestamp]
attempts_used: [integer]
total_failed_recoveries: [integer]
no_progress_checkpoints: [integer]
current_commit_sha: [full SHA]
worktree_status: [status]
affected_lanes:
  - [lane]
recommended_pause_state: [state]
evidence:
  - [path/native output]
```

First observation is diagnosis, not automatically an attempt. An attempt requires a material correction, rerun, new native evidence, and continued failure. Agent/model/session/execution-side changes do not reset budgets.

## 7. External or irreversible action policy

For every budget above zero, fix:

```yaml
external_target_identity: [provider/model/endpoint/destination]
input_identity: [path/hash/version]
output_identity_and_overwrite_policy: [rule]
retry_policy: [prohibited or exact count/condition]
fallback_policy: [prohibited or exact rule]
concurrency_policy: [prohibited or exact rule]
redaction_and_evidence_boundary: [rule]
explicit_authorization: [source]
```

Incomplete identity or authorization blocks the action before it occurs. Failure does not automatically authorize another call or parameter change.

## 8. Completion rule

The executor must stop after this capsule's accepted terminal state. Do not silently continue into the next task, phase, Provider run, integration, release, or cleanup unless this capsule explicitly authorizes that exact combined closure.
