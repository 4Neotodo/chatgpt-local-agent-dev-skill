# PLANS.md

## 1. Document duty

This file maintains only repository-level current route, active long-lived branches, authoritative entries, governance limits, and the immediate next task.

Branch milestones, command logs, test output, individual external calls, and temporary evidence belong to branch task control, Git, test output, `{{EVIDENCE_ROOT}}/<task-id>/`, and execution reports. Formal version and artifact identity belong to `VERSION_MATRIX.md`.

## 2. Current route

| Item | Current state |
|---|---|
| Repository | `{{REPOSITORY}}` |
| Default branch | `{{DEFAULT_BRANCH}}` |
| Integration/development branch | `{{INTEGRATION_BRANCH}}` |
| Project state | `{{CURRENT_STATUS}}` |
| Primary code root | `{{CODE_ROOT}}` |
| Primary validation | `{{TEST_COMMAND}}` |
| Governance contract | `{{GOVERNANCE_CONTRACT_VERSION}}` |

## 3. Collaboration and capacity baseline

```yaml
formal_worktree_root: {{FORMAL_WORKTREE_ROOT}}
auto_worktree_root: {{AUTO_WORKTREE_ROOT}}
maximum_active_write_lanes: {{MAXIMUM_ACTIVE_WRITE_LANES}}
maximum_read_only_audit_lanes: {{MAXIMUM_READ_ONLY_AUDIT_LANES}}
evidence_root: {{EVIDENCE_ROOT}}
local_config_root: {{LOCAL_CONFIG_ROOT}}
stop_budgets:
  same_blocker_attempt_budget: {{SAME_BLOCKER_ATTEMPT_BUDGET}}
  total_failed_recovery_budget: {{TOTAL_FAILED_RECOVERY_BUDGET}}
  no_progress_checkpoint_budget: {{NO_PROGRESS_CHECKPOINT_BUDGET}}
  reset_on_agent_change: false
  reset_on_model_change: false
  reset_on_session_change: false
```

The Lane limits are ceilings, not target concurrency. Raise them only through planning review after branch ownership, formal worktree isolation, evidence isolation, and serial integration have been demonstrated.

## 4. Active long-lived branches

| Branch | Objective | State | Current control |
|---|---|---|---|
| `{{INTEGRATION_BRANCH}}` | Purpose to be confirmed by the first planning review | `{{CURRENT_STATUS}}` | No branch task control established yet |

Task branches and temporary audit branches belong in branch/group control and task capsules rather than becoming permanent route entries here.

## 5. Immediate next task

```text
{{NEXT_TASK}}
```

Task type: `【规划审查】`

The first review must confirm product scope, branch route, formal worktree strategy, task types, risk model, authority paths, Lane limits, acceptance boundaries, and the first branch task control. Do not begin implementation merely because the governance files exist.

## 6. Authoritative entries

1. `README.md`
2. `docs/00_project_overview/PROJECT_OVERVIEW.md`
3. `docs/00_project_overview/PROJECT_GOVERNANCE.md`
4. `AGENTS.md`
5. `CHATGPT.md`
6. `VERSION_MATRIX.md`
7. active branch task-control document under `docs/02_dev_plans/`

## 7. Update rules

Update only when repository route, active long-lived branch, governance limit, authoritative entry, or immediate next task changes. Do not copy per-run logs, detailed branch history, or temporary evidence into this file.
