# Parallel Group Control — [Parallel Group ID]

## 1. Group identity

```yaml
parallel_group_id: [stable id]
repository: [owner/name]
parallel_type: [independent_long_lived_branch | child_task_branch | competitive_attempt | read_only_audit]
long_lived_target_branch: [branch or multiple independent branches]
fixed_group_source_ref: [ref or not_applicable]
fixed_group_source_head: [full SHA or not_applicable]
parallel_group_owner: [owner]
integration_owner: [owner or not_applicable]
closure_owner: [owner]
initial_state: [ALLOCATED]
```

## 2. Capacity

```yaml
maximum_active_write_lanes: [integer]
maximum_read_only_audit_lanes: [integer]
current_active_write_lanes: [integer]
current_read_only_audit_lanes: [integer]
```

Capacity is a ceiling, not target concurrency. Automatically retained worktrees do not increase formal Lane capacity.

## 3. Lane registry

| Lane ID | Task ID | Task branch | Source SHA | Writer | Formal worktree | State | Acceptance | Integration order |
|---|---|---|---|---|---|---|---|---|
| `[lane]` | `[task]` | `[branch/not_applicable]` | `[full SHA]` | `[owner/not_applicable]` | `[path/not_applicable]` | `[state]` | `[criteria/ref]` | `[n/not_applicable]` |

Every Lane has a complete formal task capsule. This table is an index, not a replacement contract.

## 4. Dependencies

| Lane | Depends on | Dependency condition | Failure action |
|---|---|---|---|
| `[lane]` | `[lane/baseline/not_applicable]` | `[observable condition]` | `[pause state]` |

## 5. Shared-resource schedule

| Resource | Mode | Owner | Acquire trigger | Release trigger | Evidence | Conflict action |
|---|---|---|---|---|---|---|
| `[resource]` | `[exclusive/serialized]` | `[owner]` | `[trigger]` | `[trigger]` | `[evidence]` | `[PAUSED_PARALLEL_LANE/PAUSED_PARALLEL_GROUP]` |

At minimum consider external-call identity/budget, visual or office-suite validation, formal release artifacts/version, upper-level governance files, integration target, and human-acceptance identity.

## 6. Group pause matrix

### Lane-only pause

Use `PAUSED_PARALLEL_LANE` when a blocker, exhausted budget, or failed acceptance is local to one Lane and other independent baselines remain trustworthy.

### Group pause

Use `PAUSED_PARALLEL_GROUP` when any of the following affects the group:

- shared source baseline or integration target moves;
- capacity ceiling is breached;
- upper-level governance or shared resource conflicts;
- cross-Lane file/evidence contamination;
- dependency invalidates multiple Lanes;
- integration order or candidate identity is no longer trustworthy.

Branch/source/writer identity conflict uses `PAUSED_BRANCH_OWNERSHIP_CONFLICT` immediately.

## 7. Group state

```yaml
current_state: [state]
state_owner: [owner]
last_verified_at: [timestamp]
last_verified_group_source_head: [full SHA/not_applicable]
active_shared_resources:
  - [resource/not_applicable]
```

A paused group does not automatically resume. The responsible owner must record new evidence, an allowed recovery decision, and refreshed fixed identities.

## 8. Integration order

```yaml
integration_target_branch: [branch or not_applicable]
integration_source_head: [full SHA or not_applicable]
order:
  - [lane id]
competitive_selection_rule: [rule or not_applicable]
post_step_checks:
  - [check]
```

Only accepted, pushed, fixed-SHA, evidence-complete, ownership-released Lanes may enter integration. The unique integration owner writes the target one result at a time and validates after each step.

## 9. Closure

The group closes only when:

- all Lanes are accepted, closed, or explicitly archived;
- integration is complete or formally not applicable;
- all writer and shared-resource ownership is released;
- evidence and unresolved risk are registered;
- formal worktree cleanup conditions are met;
- final group and integration reports are complete.
