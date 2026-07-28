# [Project] — [Branch / Phase] Task Control v0.1

**Target branch:** `[branch]`  
**Source branch:** `[branch]`  
**Source commit:** `[full SHA]`  
**Current state:** `[Active / Blocked / Pending / Closed]`  
**Risk level:** `[L0/L1/L2/L3]`  
**Last updated:** `[YYYY-MM-DD]`

## 1. Document duty

This is the single task-control entry for the named branch. Maintain only:

- branch or phase objective and implementation boundary;
- established long-lived baselines;
- current valid state;
- incomplete acceptance gates;
- immediate next task.

Per-command logs, detailed test output, external-call traces, and temporary evidence belong to Git, test output, `.tmp/<task-id>/`, and execution reports.

## 2. Objective

`[Describe the independently meaningful branch/phase outcome.]`

## 3. Active implementation root

```text
[path]
```

State historical or out-of-scope roots explicitly.

## 4. Approved boundaries

### In scope

- `[item]`

### Out of scope

- `[item]`

### Prohibited without planning review

- product scope, architecture, formal specification, support boundary, branch objective, governance, or version identity change;
- unrelated refactor or cleanup;
- unauthorized external call, retry, fallback, merge, rebase, release, deletion, or artifact replacement.

## 5. Established baselines

- `[baseline, authority, version, and identity]`

## 6. Completed milestones

| ID | Result | Evidence | State |
|---|---|---|---|
| `[task-id]` | `[summary]` | `[commit/test/artifact]` | Complete |

## 7. Remaining gates

| Gate | Acceptance | State |
|---|---|---|
| `[gate]` | `[observable condition]` | Pending |

## 8. Current blocker or risk

`[Separate product-result blocker, execution-process blocker, and non-blocking friction.]`

## 9. Immediate next task

```text
[task-id]
```

Task type: `[【规划审查】/【本地执行】/【UI修改】/【版本/发布控制】]`  
Risk: `[L0/L1/L2/L3]`

`[One-task objective and strict boundary.]`

## 10. Authoritative entries

1. `[formal decision/specification]`
2. `[repository plan]`
3. `[this branch control]`
4. `AGENTS.md`
5. `CHATGPT.md`

## 11. Update triggers

Update only when branch objective, boundary, established baseline, gate state, blocker, or immediate next task changes. Do not append execution diaries.
