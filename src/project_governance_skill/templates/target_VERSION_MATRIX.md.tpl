# VERSION_MATRIX.md

## 1. Document duty

This file records formal version and artifact identity. It does not track the current task, Lane state, branch writer, retry budget, command log, or immediate next action.

## 2. Governance baseline

| Item | Identity | Status | Source |
|---|---|---|---|
| Repository governance contract | `{{GOVERNANCE_CONTRACT_VERSION}}` | Generated / planning confirmation required | `.project-governance/config.json` and `docs/00_project_overview/PROJECT_GOVERNANCE.md` |

## 3. Product versions

| Product/version | Specification | Implementation branch/commit | Formal artifacts | Status |
|---|---|---|---|---|
| No formal product version recorded | `not_applicable` | `not_applicable` | `not_applicable` | Planning review required |

## 4. Artifact identity requirements

A formal artifact entry records, as applicable:

- exact path and file name;
- size and SHA256;
- source full commit SHA;
- specification and support-boundary version;
- superseded or retired identity;
- acceptance or lifecycle evidence.

Historical tests and artifacts prove only their corresponding version and execution path. Do not reuse old evidence to claim a new version.

## 5. Update triggers

Update only when formal version identity, specification version, artifact identity, release status, or historical supersession changes. Do not append ordinary implementation milestones or temporary run results.
