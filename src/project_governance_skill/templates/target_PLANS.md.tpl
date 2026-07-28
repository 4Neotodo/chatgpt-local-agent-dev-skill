# PLANS.md

## 1. Document duty

This file maintains only repository-level current route, active branches, authoritative entries, and the immediate next task.

Branch milestones, command logs, test results, and individual external calls belong to branch task control, Git, test output, task evidence, and execution reports. Formal version and artifact identity belong to `VERSION_MATRIX.md`.

## 2. Current route

| Item | Current state |
|---|---|
| Repository | `{{REPOSITORY}}` |
| Default branch | `{{DEFAULT_BRANCH}}` |
| Integration/development branch | `{{INTEGRATION_BRANCH}}` |
| Project state | `{{CURRENT_STATUS}}` |
| Primary code root | `{{CODE_ROOT}}` |
| Primary validation | `{{TEST_COMMAND}}` |

## 3. Immediate next task

```text
{{NEXT_TASK}}
```

Task type: `【规划审查】`

The first planning review must confirm product scope, branch route, authoritative specifications, risk model, acceptance boundaries, and the first branch task control. Do not begin implementation merely because the governance templates exist.

## 4. Authoritative entries

1. `README.md`
2. `docs/00_project_overview/PROJECT_OVERVIEW.md`
3. `docs/00_project_overview/PROJECT_GOVERNANCE.md`
4. `AGENTS.md`
5. `CHATGPT.md`
6. `VERSION_MATRIX.md`
7. active branch task-control document under `docs/02_dev_plans/`

Historical plans, closed branches, previous chat summaries, and old execution reports are not default current context.

## 5. Update rules

Update this file only when repository route, active branch, immediate next task, or authoritative entry changes. Do not copy per-run logs or detailed branch history into this file.
