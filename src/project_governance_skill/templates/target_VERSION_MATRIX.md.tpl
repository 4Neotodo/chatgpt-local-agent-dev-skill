# VERSION_MATRIX.md

## 1. Document duty

This file records only version, formal asset, branch-baseline, release, and historical-delivery identity. It does not control the current task.

Read current task and next action from `PLANS.md` and the active branch task control.

## 2. Current identities

| Asset | Identity or state | Authority / notes |
|---|---|---|
| Project | `{{PROJECT_NAME}}` | `README.md` and project overview |
| Repository | `{{REPOSITORY}}` | Git remote |
| Default branch | `{{DEFAULT_BRANCH}}` | Repository setting |
| Integration/development branch | `{{INTEGRATION_BRANCH}}` | Confirm through planning review |
| Formal product version | Not released / `[待确认]` | Do not infer from a branch name or implementation milestone |
| Formal release artifact | None / `[待确认]` | Record path, size, SHA256, source commit, and replacement relation when created |

## 3. Branch identities

| Branch | Source commit | Current identity | Notes |
|---|---|---|---|
| `{{DEFAULT_BRANCH}}` | `[待确认]` | Default branch | Stable repository line; release meaning must be explicit |
| `{{INTEGRATION_BRANCH}}` | `[待确认]` | Integration/development candidate | Not automatically a product release |

## 4. Formal specifications and assets

| Asset | Version | Status | Authority |
|---|---|---|---|
| Product scope | `[待确认]` | Planning review required | `docs/00_project_overview/PROJECT_OVERVIEW.md` or project-specific formal decision |
| Project governance | v0.1 | Current initialization baseline | `docs/00_project_overview/PROJECT_GOVERNANCE.md` |
| Executable specification | `[待确认]` | Not established | Project-specific specification path |
| Test and acceptance assets | `[待确认]` | Not established | Must correspond to an explicit specification version |

## 5. Historical identity

Keep replaced specifications, tests, artifacts, and delivery records under their original identity when provenance matters. Historical assets do not prove the current version and must not silently become a new implementation baseline.

## 6. Update rules

Update only when:

1. a formal planning baseline is confirmed or revised;
2. a specification, application, engine, or product version becomes current;
3. a formal artifact, tag, or release identity changes;
4. historical delivery is replaced, revoked, or revalidated;
5. an old asset's formal reuse identity changes;
6. an integration or phase branch gains a formal version identity.

Do not record ordinary task progress, test runs, or branch-level implementation details here.
