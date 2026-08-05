# Integration Report — [Integration Task / Parallel Group]

## 1. Integration identity

```yaml
repository: [owner/name]
parallel_group_id: [id/not_applicable]
integration_target_branch: [branch]
verified_integration_source_head: [full SHA]
integration_owner: [owner]
integration_worktree: [path/not_applicable]
integration_start_state: INTEGRATION
```

The integration target must have one writer and a fixed source head. Target movement before or during integration is a pause condition.

## 2. Accepted inputs

| Order | Lane ID | Task branch | Accepted commit | Accepted state | Writer released | Evidence complete | Candidate selected |
|---|---|---|---|---|---|---|---|
| `[n]` | `[lane]` | `[branch]` | `[full SHA]` | `[LOCAL_ACCEPTED/equivalent]` | `[true]` | `[true]` | `[true/not_applicable]` |

Reject any abbreviated/mismatched commit, unaccepted Lane, unreleased writer, or incomplete evidence before target mutation.

## 3. Integration steps

| Step | Input commit | Operation | Target head after step | Validation | Result |
|---|---|---|---|---|---|
| `[n]` | `[full SHA]` | `[merge/cherry-pick/approved operation]` | `[full SHA]` | `[command/check]` | `[pass/fail]` |

Integrate one result at a time. Run impact-matched validation after each step. Do not auto-rebase, auto-select conflicts, or integrate multiple candidates concurrently.

## 4. Competitive selection

```yaml
competitive_attempt: [true | false]
selection_rule: [frozen rule or not_applicable]
selected_lane: [lane/not_applicable]
unselected_lanes:
  - [lane/closure action]
```

Do not splice unaccepted competitive candidates.

## 5. Conflicts, pauses, and rollback

- Target movement: `[none/details]`
- Candidate mismatch: `[none/details]`
- Merge/content conflict: `[none/details]`
- Post-step validation failure: `[none/details]`
- Product/specification decision required: `[none/details]`
- Pause/rollback action: `[state and action]`
- Stop-budget usage: `[summary]`

A conflict requiring business, architecture, specification, governance, or scope judgment pauses for planning review. Identity conflict uses `PAUSED_BRANCH_OWNERSHIP_CONFLICT`.

## 6. Final validation

| Command/check | Native result | Acceptance conclusion |
|---|---|---|
| `[command]` | `[exit code/summary]` | `[pass/fail]` |

## 7. Final target and push

```yaml
final_integration_commit: [full SHA]
final_remote_target_head: [full SHA]
push_result: [result]
integration_owner_released: [true | false]
final_worktree_status: [clean/exact paths/not_applicable]
```

## 8. Group closure

```yaml
final_state: [CLOSED or pause state]
closure_owner: [owner]
formal_worktrees_removed_or_retained:
  - [lane/path/action]
evidence_manifest: [path/ref]
unresolved_risks:
  - [risk or none]
next_task: [task/not_applicable]
```

The group closes only after final push, ownership release, evidence registration, recoverability, and approved worktree cleanup.
