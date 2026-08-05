# Fixed-SHA Handoff — [Project / Branch / Task]

## 1. Producer state

```yaml
repository: [owner/name]
long_lived_target_branch: [branch]
task_branch: [branch/not_applicable]
parallel_group_id: [id/not_applicable]
lane_id: [id/not_applicable]
producer: [remote_writer/local_writer]
producer_start_sha: [full SHA]
completed_commit_sha: [full SHA]
remote_branch_head_verified: [full SHA]
push_result: [result]
writer_ownership_released: [true]
producer_terminal_state: [REMOTE_READY_FOR_LOCAL_VALIDATION/LOCAL_ACCEPTED/other allowed state]
formal_worktree_status: [clean/path/not_applicable]
```

Do not hand off an abbreviated or unpushed commit. The completed commit, verified remote branch head, and reported SHA must be identical.

## 2. Changed scope and validation

- Changed files: `[paths]`
- Core behavior/document change: `[summary]`
- Producer-side validation: `[commands/results]`
- Remaining receiver-side validation: `[checks or not_applicable]`
- Out-of-scope diff: `[none/details]`

## 3. Current authority

1. `[formal decision/specification]`
2. `[branch task control]`
3. `[task capsule]`
4. `AGENTS.md`
5. `CHATGPT.md`

## 4. Evidence and artifacts

| Path | Identity | Provenance | Receiver use | Cleanup condition |
|---|---|---|---|---|
| `[path]` | `[SHA256/size/version/full SHA]` | `[source]` | `[purpose]` | `[condition]` |

Use `None` when no local evidence is retained. Missing or identity-broken evidence blocks the receiver; do not silently regenerate it.

## 5. External calls, resources, and budgets

```yaml
external_calls_used: [counts]
stop_budget_usage: [summary]
shared_resources_released:
  - [resource/true]
unresolved_blockers_or_risks:
  - [risk or none]
```

## 6. Receiver acquisition gate

```yaml
receiver: [local_writer/remote reviewer/integration_owner]
required_action:
  - fetch the task branch/ref
  - verify exact remote head equals completed_commit_sha
  - verify clean and approved worktree when local
  - verify branch is not occupied by another writer/worktree
  - verify ownership records and shared resources are released
pass_condition: all identities and ownership records match exactly
failure_action: PAUSED_BRANCH_OWNERSHIP_CONFLICT
```

The receiver acquires writer ownership only after the gate passes. Do not auto-pull, merge, rebase, or absorb a different commit.

## 7. Immediate receiver task

- Task ID: `[id]`
- Type/risk: `[type] / [level]`
- Objective: `[one closure]`
- Required context: `[minimal paths]`
- Acceptance: `[exact result]`
- Prohibited continuation: `[do not enter next phase/call Provider/modify frozen files/etc.]`

This handoff is a fixed-identity transfer record. It does not replace formal governance, branch control, or the receiver's task capsule.
