# Execution Report — [Task ID]

## 1. Result

```yaml
result: [PASS | PARTIAL | INVALID_TASK_CAPSULE | PAUSED_FOR_PLANNING_REVIEW | PAUSED_PARALLEL_LANE | PAUSED_PARALLEL_GROUP | PAUSED_BRANCH_OWNERSHIP_CONFLICT]
current_state: [state]
one_sentence_reason: [reason]
```

## 2. Identity and ownership

```yaml
repository: [owner/name]
long_lived_target_branch: [branch]
verified_source_head: [full SHA]
task_branch: [branch or not_applicable]
parallel_group_id: [id or not_applicable]
lane_id: [id or not_applicable]
parallel_type: [type]
formal_worktree_path: [path or not_applicable]
writer: [owner or not_applicable]
starting_commit: [full SHA]
completed_commit_sha: [full SHA or unchanged]
final_branch_head: [full SHA]
push_result: [result]
writer_ownership_released: [true | false]
final_worktree_status: [clean or exact dirty paths]
```

Report full SHAs. Do not substitute abbreviated commits or remembered task text.

## 3. Changed files and behavior

| Path | Change | Authorized scope reference |
|---|---|---|
| `[path]` | `[behavior/document-duty change]` | `[capsule item]` |

State explicitly whether any out-of-scope diff exists.

## 4. Validation

| Command/check | Runtime/environment | Native result | Acceptance conclusion |
|---|---|---|---|
| `[command]` | `[controlled runtime]` | `[exit code and summary]` | `[pass/fail/not_applicable]` |

Record native exit codes and final summaries. Do not label command-selection friction as a product test failure when the controlled runtime works.

## 5. Artifacts and evidence

| Artifact/evidence | Identity | Provenance/source | Downstream use | Cleanup condition |
|---|---|---|---|---|
| `[path]` | `[size/SHA256/version/full SHA]` | `[source]` | `[reader/purpose]` | `[condition]` |

Use `None` when no cross-task evidence is retained. Do not retain untracked evidence without a declared reader and cleanup condition.

## 6. External calls and irreversible actions

```yaml
external_call_budgets:
  provider_calls: [authorized]
  network_tokenization_calls: [authorized]
  other_external_actions: [authorized]
external_calls_used:
  provider_calls: [actual]
  network_tokenization_calls: [actual]
  other_external_actions: [actual]
retry_or_fallback_used: [details or not_applicable]
identity_and_authorization_verified_before_action: [true | false | not_applicable]
```

List exact call/action evidence when any count is non-zero. A failed call does not imply permission for another call.

## 7. Stop-budget usage and blockers

```yaml
stop_budget_usage:
  same_blocker_attempts:
    [blocker id]: [used / limit]
  total_failed_recoveries: [used / limit]
  no_progress_checkpoints: [used / limit]
```

For every active blocker:

```yaml
blocker_id: [id]
blocker_family: [family]
error_code: [code]
normalized_error_signature: [signature]
operation: [operation]
repository_role: [role]
canonical_repository_path: [path]
checkpoint_id: [checkpoint]
attempts_used: [integer]
evidence:
  - [path/native output]
```

First observation and diagnosis are not automatically attempts. State the material corrective action and rerun evidence for each consumed attempt.

## 8. Shared-resource usage

| Resource | Mode | Owner | Acquired | Released | Evidence | Conflict |
|---|---|---|---|---|---|---|
| `[resource]` | `[exclusive/serialized/not_applicable]` | `[owner]` | `[yes/no/not_applicable]` | `[yes/no/not_applicable]` | `[evidence]` | `[none/details]` |

## 9. Long-lived document triggers

```yaml
plan_updated: [yes/no and reason]
specification_updated: [yes/no and reason]
governance_updated: [yes/no and reason]
branch_control_updated: [yes/no and reason]
version_matrix_updated: [yes/no and reason]
```

Ordinary implementation details and one-time run facts do not trigger durable-document updates.

## 10. Handoff and integration readiness

```yaml
handoff_target: [owner/state or not_applicable]
producer_release_condition_met: [true | false | not_applicable]
receiver_acquire_checks_required:
  - [check]
integration_readiness: [ready | not_ready | not_applicable]
accepted_commit_for_integration: [full SHA or not_applicable]
unresolved_conflicts_or_risks:
  - [risk or none]
next_task: [task id or not_applicable]
```

## 11. Execution-process blockage assessment

- Task-result blocker: `[none or facts]`
- Execution-process blocker: `[none or facts]`
- Non-blocking friction: `[none or facts]`
- Repeated issue: `[yes/no/unknown]`
- Existing rules sufficient: `[yes/no and why]`
- Governance recommendation: `[none / capsule fix / repository-discipline planning review / approved local-tool task]`

The executor reports facts and recommendations only. This section does not authorize governance, scope, architecture, specification, budget, Lane-limit, version, or integration changes.
