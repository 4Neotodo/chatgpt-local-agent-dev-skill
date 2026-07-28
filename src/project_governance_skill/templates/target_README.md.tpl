# {{PROJECT_NAME}}

{{PROJECT_PURPOSE}}

## Current status

`{{CURRENT_STATUS}}`

Repository: `{{REPOSITORY}}`  
Default branch: `{{DEFAULT_BRANCH}}`  
Integration/development branch: `{{INTEGRATION_BRANCH}}`

## Authoritative entries

1. Stable project overview: `docs/00_project_overview/PROJECT_OVERVIEW.md`
2. Shared governance decision: `docs/00_project_overview/PROJECT_GOVERNANCE.md`
3. Local Agent execution rules: `AGENTS.md`
4. ChatGPT planning and review rules: `CHATGPT.md`
5. Current route and next task: `PLANS.md`
6. Version and artifact identity: `VERSION_MATRIX.md`
7. Branch task controls: `docs/02_dev_plans/`
8. Execution evidence and reports: Git history, test output, `.tmp/<task-id>/`, and `docs/03_execution_reports/` when a retained report is required

Do not use historical plans, old branches, temporary summaries, implementation snapshots, or previous chat messages as the default current authority.

## Development model

```text
approved project direction and formal decisions
→ ChatGPT planning review and task capsule
→ local Agent implementation, validation, commit, push, and report
→ ChatGPT evidence review and next-task or closure decision
→ user review only where business, visual, device, cost, risk, or irreversible authority is required
```

Primary code root: `{{CODE_ROOT}}`  
Primary validation command: `{{TEST_COMMAND}}`  
Primary documentation language: `{{PRIMARY_LANGUAGE}}`
