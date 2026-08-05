# [Project] — [Long-Lived Branch / Phase] Task Control v0.1

**Repository:** `[owner/name]`
**Long-lived target branch:** `[branch]`
**Branch source:** `[source ref]`
**Established source commit:** `[full SHA]`
**Current state:** `[Active / Pending / Blocked / Closed]`
**Risk envelope:** `[L0/L1/L2/L3]`
**Last updated:** `[YYYY-MM-DD]`

## 1. Document duty

This is the single current control entry for the named long-lived branch or phase. Maintain only:

- independently meaningful branch objective and implementation boundary;
- established long-lived baselines and formal authority;
- current valid state, ownership model, and active Lane limits;
- incomplete acceptance gates, blockers, and immediate next task.

Per-command logs, full test output, individual external calls, temporary evidence, and task-branch details belong to Git, task capsules, `{{EVIDENCE_ROOT}}/<task-id>/`, and reports.

## 2. Objective

`[Describe the independently meaningful branch/phase outcome.]`

## 3. Active implementation root

```text
[path]
```

State historical, superseded, or out-of-scope roots explicitly.

## 4. Approved boundaries

### In scope

- `[item]`

### Out of scope

- `[item]`

### Prohibited without planning review

- product scope, architecture, formal specification, support boundary, branch objective, governance, stop budget, Lane limit, or version identity change;
- unrelated refactor, cleanup, dependency upgrade, or historical rewrite;
- unauthorized external call, retry, fallback, merge, rebase, release, deployment, deletion, migration, or artifact replacement.

## 5. Branch ownership and execution model

```yaml
long_lived_target_branch: [branch]
integration_owner: [owner or not_applicable]
maximum_active_write_lanes: [integer]
maximum_read_only_audit_lanes: [integer]
formal_worktree_root: [path or not_applicable]
current_target_writer: not_applicable
```

The long-lived target is not a shared parallel write branch. Child work uses unique task branches and, when local, unique formal worktrees. Integration is one result at a time by the named owner.

## 6. Established baselines

| Baseline | Authority/version | Identity | State |
|---|---|---|---|
| `[baseline]` | `[path/version]` | `[full SHA/hash/artifact]` | `[current/superseded]` |

## 7. Completed milestones

| Task ID | Result | Commit/evidence | State |
|---|---|---|---|
| `[task-id]` | `[summary]` | `[full SHA/test/artifact]` | Complete |

## 8. Active task branches and Lanes

| Task/Lane | Task branch | Source SHA | Writer | Worktree | State | Integration readiness |
|---|---|---|---|---|---|---|
| `[task-id / lane-id]` | `[branch]` | `[full SHA]` | `[owner/not_applicable]` | `[path/not_applicable]` | `[state]` | `[not_ready/ready/not_applicable]` |

Do not use this table as a substitute for the full task capsule or parallel-group control.

## 9. Remaining gates

| Gate | Acceptance | Owner | State |
|---|---|---|---|
| `[gate]` | `[observable condition]` | `[owner]` | Pending |

## 10. Current blocker or risk

Separate:

- product/result blocker;
- execution-process blocker;
- non-blocking friction;
- branch/source/ownership conflict;
- group-level shared-baseline or shared-resource risk.

Record only current durable status. Detailed blocker attempts and evidence belong to the active task report/state.

## 11. Immediate next task

```text
[task-id]
```

Task type: `[【规划审查】/【远端实现】/【本地执行】/【并行执行编排】/【并行结果集成验收】]`
Risk: `[L0/L1/L2/L3]`
Source ref/head: `[ref] / [full SHA or must verify immediately before allocation]`

`[One independently acceptable objective and strict boundary.]`

## 12. Authoritative entries

1. `[formal decision/specification]`
2. `PLANS.md`
3. `[this branch control]`
4. `docs/00_project_overview/PROJECT_GOVERNANCE.md`
5. `AGENTS.md`
6. `CHATGPT.md`

## 13. Update triggers

Update only when branch objective, boundary, established baseline, active route, gate state, current durable blocker, ownership model, Lane limit, or immediate next task changes. Do not append execution diaries.
