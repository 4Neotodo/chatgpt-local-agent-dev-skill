# {{PROJECT_NAME}}

{{PROJECT_PURPOSE}}

## Stable authority entries

| Entry | Duty |
|---|---|
| `README.md` | Stable project purpose and minimum navigation |
| `docs/00_project_overview/PROJECT_OVERVIEW.md` | Product and repository overview |
| `docs/00_project_overview/PROJECT_GOVERNANCE.md` | Remote/local collaboration, ownership, worktree, Lane, state, budget, and integration contract |
| `AGENTS.md` | Long-lived execution rules for any authorized Agent |
| `CHATGPT.md` | Remote planning, remote implementation, orchestration, and review rules |
| `PLANS.md` | Current repository route, active long-lived branches, governance limits, and immediate next task |
| `VERSION_MATRIX.md` | Formal version, artifact, and historical identity |
| active branch task control | One long-lived branch objective, boundary, baselines, gates, and next task |
| task capsule | One execution authorization and acceptance contract |
| reports | One planning, execution, handoff, or integration fact set |

Do not infer current state from chat history alone. Verify the repository, branch, full commit SHA, worktree, ownership, and directly relevant authority before writing or making current-state claims.

## Collaboration lifecycle

```text
planning review / allocation
→ fixed source_ref + source_head
→ unique task branch and current writer
→ remote implementation or formal local-worktree execution
→ validation, commit, push, and full-SHA verification
→ writer ownership release
→ local or human acceptance
→ serial integration by the unique integration owner
→ closure, evidence registration, and worktree cleanup
```

One branch has one current writer. Remote and local writers do not overlap. Unknown branch movement is not absorbed through automatic pull, merge, or rebase.

## Repository identity

- Repository: `{{REPOSITORY}}`
- Default branch: `{{DEFAULT_BRANCH}}`
- Integration/development branch: `{{INTEGRATION_BRANCH}}`
- Primary code root: `{{CODE_ROOT}}`
- Primary validation: `{{TEST_COMMAND}}`
- Formal worktree root: `{{FORMAL_WORKTREE_ROOT}}`
- Governance contract: `{{GOVERNANCE_CONTRACT_VERSION}}`

## Current route

See `PLANS.md`. Keep per-run commands, logs, and temporary evidence out of this file.
