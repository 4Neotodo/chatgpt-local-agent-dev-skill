# Planning Review — [Decision / Task ID]

## 1. Decision boundary

`[What must be decided now, what is explicitly outside this review, and what irreversible or product decision remains with the user.]`

## 2. Verified current authority and identity

```yaml
repository: [owner/name]
branch_or_ref: [ref]
verified_head: [full SHA]
current_writer: [owner/not_applicable]
current_state: [state]
```

- Formal governance/specifications: `[paths and versions]`
- Current `PLANS.md`/branch control: `[paths]`
- Execution evidence: `[full commits/tests/artifacts/reports]`
- Missing or unverified evidence: `[items or none]`

## 3. Findings

### Verified facts

- `[fact with source]`

### Inferences

- `[explicit inference and supporting facts]`

### Invalid or outdated assumptions

- `[assumption and why it no longer governs]`

### First-principles challenge

- `[root cause, necessary outcome, simplest sufficient control, and whether the current task framing is too narrow]`

## 4. Options and value/cost test

| Option | Value | Cost/complexity | Risk/reversibility | Decision |
|---|---|---|---|---|
| `[option]` | `[value]` | `[cost]` | `[risk]` | `[accept/reject/defer]` |

Avoid a general platform, parser, database, state service, document, or gate unless repeated cross-task value clearly exceeds maintenance cost.

## 5. Decisions

1. `[confirmed decision]`
2. `[confirmed decision]`

State separately:

- product/specification decision;
- governance/process decision;
- execution-fact correction;
- task-only exception;
- user authorization still required.

## 6. Task classification and ownership

```yaml
next_task_type: [formal task type]
risk_level: [L0/L1/L2/L3]
long_lived_target_branch: [branch]
task_branch: [unique branch or not_applicable]
source_ref: [ref]
source_head: [full SHA or must reverify immediately before allocation]
parallel_type: [type]
parallel_group_id: [id/not_applicable]
lane_id: [id/not_applicable]
planning_owner: [owner]
lane_owner: [owner]
remote_writer: [owner/not_applicable]
local_writer: [owner/not_applicable]
validation_owner: [owner]
integration_owner: [owner/not_applicable]
closure_owner: [owner]
```

## 7. Required document updates

| Path | Formal duty triggered | Required change |
|---|---|---|
| `[path]` | `[reason]` | `[change]` |

Do not update unrelated entries or duplicate execution logs.

## 8. Immediate next task

- Task ID: `[id]`
- Objective: `[one independently acceptable closure]`
- Allowed scope: `[scope]`
- Forbidden scope: `[scope]`
- External-call budgets: `[explicit integers]`
- Shared resources: `[resource/owner/mode]`
- Acceptance: `[observable result]`
- Initial state: `[state]`
- Allowed terminal states: `[states]`
- Stop budgets: `[values or inherited defaults]`

## 9. Closure state

`[CLOSED / PAUSED_FOR_PLANNING_REVIEW / PAUSED_BRANCH_OWNERSHIP_CONFLICT / user decision required]`

If this review included remote writes, record completed commit, push, remote-head verification, and writer ownership release before declaring closure.
