# AGENTS.md

## 1. Purpose

This is the repository-level long-term operating entry for any local development Agent working in `{{PROJECT_NAME}}`. It is Agent-brand-neutral and applies to Codex, Claude Code, Kimi, Gemini CLI, or another authorized local Agent.

Do not rely on chat history alone. Do not treat a historical branch, sample, implementation, test, or report as the repository's permanent current state.

## 2. Authority and context selection

Before execution, use this order:

1. inspect the actual repository, branch, and worktree;
2. read the explicit user instruction or current task capsule;
3. locate the target branch task control or directly corresponding plan;
4. decide what the current task actually needs to understand or decide;
5. read directly related formal decisions, specifications, code, tests, and assets;
6. read historical material only to resolve conflict, provenance, or an explicitly historical task.

Do not mechanically require every task to read `README.md`, `PLANS.md`, `VERSION_MATRIX.md`, all specifications, and all history. Use original authoritative text while context remains manageable. Create or use a sourced temporary context summary only when volume, distribution, or repetition materially harms execution quality or efficiency.

Repository entry duties:

- `README.md`: stable project description and minimum entry list;
- `CHATGPT.md`: remote planning and review discipline;
- `PLANS.md`: current route, active branches, and immediate next task;
- `VERSION_MATRIX.md`: version, formal asset, and historical delivery identity;
- branch task control: current branch objective, boundary, status, gates, and next task;
- formal decisions and specifications: product, architecture, and behavior authority;
- Git, tests, artifacts, and reports: one execution's facts.

## 3. Roles and task types

| Task type | Default execution side | Default writable scope |
|---|---|---|
| `【规划审查】` | ChatGPT / GitHub | decisions, plans, branch control, governance, and necessary indexes |
| `【本地执行】` | authorized local Agent | capsule-authorized code, tests, assets, and triggered plan updates |
| `【UI修改】` | authorized remote or local edit plus local visual validation | named UI files, related tests, and necessary UI specifications |
| `【版本/发布控制】` | task-defined | version matrix, release record, package, lifecycle, and delivery evidence |
| Schema or shared contract change | planning approval required | explicitly authorized contract, specification, implementation, and tests |

Task type assigns responsibility. Risk level assigns validation and reporting intensity. Neither authorizes unrelated file changes.

The task capsule is subordinate to formal decisions, this file, `CHATGPT.md`, and branch task control. On conflict, stop and report. Only an explicit user or approved planning-review exception written into the capsule may override a named rule.

## 4. Risk levels

### L0 — Documentation or state correction

No product, specification, code behavior, output semantics, or version identity change.

Minimum requirements:

- modify only target documents;
- check anchors, links, status, placeholders, and final diff;
- do not run unrelated product tests;
- update other entries only when route, identity, or long-term conclusion actually changes.

### L1 — Low-risk local correction

Narrow impact with no shared contract, business rule, output semantics, schema, template, or release identity change.

Minimum requirements:

- deterministic reproduction or direct tests;
- small, relevant regression set when needed;
- no release packaging, full lifecycle, or device acceptance;
- no mechanical plan update merely because code changed;
- no separate ceremonial closure task after passing acceptance and push.

### L2 — Shared behavior, capability, or foundation change

Shared modules, business behavior, validation, output, schema, template, or cross-component contract.

Minimum requirements:

- direct tests plus impact-matched regression;
- real sample, file, visual, or integration evidence when applicable;
- update long-lived documents only when their trigger conditions are met;
- do not perform L3 release work unless explicitly upgraded.

### L3 — Release candidate or delivery

Release package, production delivery, real lifecycle, external Provider, user environment, or device acceptance.

Apply the task-required combination of:

- packaging closure and blocker audit;
- artifact size, SHA256, source commit, and version identity;
- install, configure, start, update, and uninstall lifecycle;
- real Provider, production path, real sample, device, or user acceptance;
- release notes and version-matrix update.

L3 controls must not be indiscriminately imposed on L0–L2.

If risk is unclear, choose the higher plausible level and explain. If impact expands during execution, stop expansion and return to planning review or an explicitly upgraded capsule.

## 5. Required execution order

Every task must:

1. check repository, branch, and worktree;
2. confirm the task belongs to the target branch route or has explicit authorization;
3. confirm task type, risk, allowed scope, prohibited actions, and stop conditions;
4. read and modify only what the task directly needs;
5. preserve formal specification and schema semantics unless modification is authorized;
6. run the smallest validation set that fully proves the real impact;
7. update plans, specifications, versions, or branch status only when a trigger is met;
8. report according to risk level.

When product scope, architecture, formal specification, support boundary, repository governance, branch objective, or version identity must change, stop implementation expansion and request `【规划审查】`.

## 6. Git safety discipline

At local-task start:

```bash
git branch --show-current
git status --short
```

Routing:

- already on target branch and clean: `git fetch origin`, then `git pull --ff-only`;
- not on target branch and clean: fetch, switch only when authorized, then `git pull --ff-only`;
- dirty worktree: stop immediately; do not switch, stash, commit, delete, or modify files.

Recheck branch and worktree after switch or pull. The branch must equal the target, the worktree must be clean, and fast-forward pull must succeed before edits.

Additional rules:

1. pull, commit, and push only the capsule's target branch;
2. push only to `origin/<target-branch>` unless cross-branch action is explicitly authorized;
3. explicitly stage task files; do not use unreviewed `git add .`;
4. stop on unrelated changes;
5. do not auto-stash, merge, rebase, change remote, or rewrite credentials;
6. long-lived branch creation, cross-branch synchronization, merge, and closure require approved source, target, and scope;
7. temporary evidence belongs under `.tmp/<task-id>/`; explicit local configuration belongs under `.local/` unless the task defines another boundary;
8. report target branch, starting and completion commit, push result, and final worktree state.

## 7. Validation discipline

Validation must match real impact. Do not mechanically run the entire repository, and do not substitute a low-value check for required real execution.

- L0: target text, anchors, links, status, placeholders, and final diff;
- L1: deterministic reproduction, direct tests, and necessary small regression;
- L2: direct tests, necessary regression, and applicable real sample/file/visual evidence;
- L3: L2 plus release closure, artifact identity, lifecycle, Provider, device, or user acceptance.

Primary repository validation command:

```text
{{TEST_COMMAND}}
```

Primary code root:

```text
{{CODE_ROOT}}
```

Use the repository-controlled runtime or virtual environment when present. A system runtime missing test dependencies while the controlled runtime works is command-selection friction, not a product test failure. Do not install into the global environment merely to bypass the repository runtime.

For long-running commands, preserve and poll the same process until final exit. Do not start duplicate runs while the original process may still be active. Cross a gate only after receiving the native exit code and final summary.

Visual acceptance requires actual screenshots or an authorized visual tool when the task requires visual proof. DOM, static HTML, workbook structure, or text checks supplement rather than automatically replace visual review.

## 8. Real external calls and irreversible actions

Before a real Provider call, publication, package replacement, deletion, migration, credential change, or another irreversible action, close and record:

- authoritative input paths and identities;
- output path state and overwrite policy;
- provider/model/endpoint or external target;
- call count, retry, fallback, concurrency, and stop policy;
- expected evidence and redaction boundary;
- explicit authorization.

If identity or authorization is incomplete, stop before the action. Do not perform the action first and reconstruct evidence later. A failed authorized run does not automatically authorize retries or parameter changes.

## 9. Documents and planning-review triggers

Code tasks do not mechanically update plan documents. Update long-lived entries only when:

- task, branch, or phase status changes;
- immediate next task or route changes;
- product scope, architecture, formal specification, or support boundary changes;
- repository-level governance changes;
- formal version, artifact, or historical identity changes;
- the capsule explicitly requires a retained long-term conclusion.

One-time commands, tests, artifacts, and run facts belong in Git, test output, `.tmp/<task-id>/`, and the execution report.

Planning review is mandatory for:

- product, architecture, specification, support, governance, or branch-objective change;
- unauthorized long-lived branch creation or cross-branch merge;
- phase, branch, formal version, or release closure;
- an execution task that must break its approved boundary.

A capsule may authorize branch creation within one L2 local task when source, target, and scope are already approved. Passing L1/L2 work does not require a separate ceremonial closure review unless a higher-level boundary or route changes.

## 10. Governance iteration

Execution reports may identify blockers, friction, and improvement ideas, but suggestions do not automatically become rules or implementation authorization.

Process governance feedback in this order:

1. determine whether the capsule, path, command, evidence directory, or execution method was wrong, or an existing rule was ignored; fix the task first and do not duplicate rules;
2. only when a repeated cross-task rule is missing or must change, perform planning review and update formal governance plus this file when necessary;
3. implement approved tools, scripts, tests, or checks as a local task;
4. when remote write capability is insufficient or rule and implementation must be atomic, the capsule may combine them only after the governance decision is fixed.

Governance investment must remain necessary, simple, and worth its cost. One mistake does not justify a general platform, complex state machine, universal parser, or preventive gate for every low-probability failure.

## 11. Evidence retention and handoff

Only local evidence required by an already-authorized downstream task must be retained across tasks. The producing task must record:

- exact path;
- file identity or SHA256 when material;
- source relationship;
- downstream reader and purpose;
- cleanup or release condition.

Before the downstream task, recheck existence and identity. Missing or provenance-broken evidence blocks the task. Do not replace it with a new Provider call, random generation, or files assembled from different sources.

## 12. Completion report and process-blockage assessment

Every local task, whether complete or blocked, must separate task result from execution-process issues.

At minimum report:

1. Git summary;
2. modified files and behavior;
3. validation commands and results;
4. artifacts and retained evidence;
5. triggered specification, plan, governance, or version updates;
6. incomplete items and next recommendation;
7. final worktree state;
8. process-blockage assessment.

Process-blockage assessment must distinguish:

- task-result blocker: behavior, test, or acceptance failed;
- execution-process blocker: environment or method prevented continuation;
- non-blocking friction: stable fallback existed and valid results were obtained.

State whether the issue repeats, whether existing rules are sufficient, and whether the recommendation is a capsule fix, repository-discipline change, or approved local-tool implementation. The local Agent reports facts and recommendations; it does not self-authorize governance changes.

## 13. Data and security

- Primary documentation language: `{{PRIMARY_LANGUAGE}}`.
- Code identifiers, schema keys, and CLI parameters may use English.
- Do not commit secrets, credentials, unredacted private materials, raw sensitive Provider requests/responses, or sensitive logs.
- Historical tests and artifacts prove only their corresponding version and path.
- Do not modify expected artifacts to hide unapproved behavior changes.
