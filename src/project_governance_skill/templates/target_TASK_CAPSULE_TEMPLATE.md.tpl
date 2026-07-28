# Local Agent Task Capsule

## 1. Identity

- Repository: `[owner/name]`
- Target branch: `[branch]`
- Expected starting commit: `[full SHA or verify current remote head]`
- Task ID: `[stable task-id]`
- Task type: `[【本地执行】/【UI修改】/【版本/发布控制】]`
- Risk level: `[L0/L1/L2/L3]`
- One-task objective: `[one independently acceptable closure]`

## 2. Verified background

`[Only facts needed to execute. Separate current authority from historical evidence.]`

## 3. Minimum authoritative context

Read in this order:

1. `AGENTS.md`
2. `[target branch task control]`
3. `[direct formal decision/specification]`
4. `[direct implementation/test/assets]`

Do not mechanically read unrelated root documents or historical plans. Add context only when needed to resolve conflict or provenance.

## 4. Git and worktree gate

Run before edits:

```bash
git branch --show-current
git status --short
git fetch origin
git pull --ff-only
```

Requirements:

- current branch equals the target branch;
- worktree is clean before and after synchronization;
- pull succeeds as fast-forward only;
- stop on unrelated changes;
- do not stash, merge, rebase, change remote, or rewrite credentials.

## 5. Allowed changes

- `[path or narrowly defined behavior]`

## 6. Prohibited changes

- `[path or behavior]`
- no scope, architecture, specification, governance, branch-objective, or version-identity expansion;
- no unrelated cleanup or dependency upgrade;
- no extra external call, retry, fallback, concurrency, or artifact replacement unless explicitly listed below.

## 7. Execution requirements

1. `[step]`
2. `[step]`
3. Preserve temporary evidence under `.tmp/[task-id]/` when required.
4. Explicitly stage only task files.

## 8. External or irreversible action policy

- Authorized external target/provider: `[none or exact identity]`
- Maximum calls/actions: `[0 or exact count]`
- Retry: `[prohibited or exact policy]`
- Fallback: `[prohibited or exact policy]`
- Concurrency: `[prohibited or exact policy]`
- Input identity: `[path/hash/version]`
- Output path and overwrite policy: `[exact rule]`
- Redaction/evidence boundary: `[rule]`

When any identity or authorization is incomplete, stop before the action.

## 9. Acceptance criteria

- `[exact command]` → `[required result]`
- `[artifact/file/visual check]` → `[required result]`
- no out-of-scope diff;
- required plan/spec/version update only when its trigger is met;
- final worktree clean after commit;
- push succeeds to `origin/[target-branch]`.

## 10. Stop conditions

Stop and report `BLOCKED` when:

- branch/head/worktree identity is wrong;
- authority conflicts;
- required local evidence is absent or provenance-broken;
- controlled runtime/dependency is unavailable;
- acceptance requires an unapproved scope or rule change;
- an external call or retry is not authorized;
- a frozen or prohibited asset would need modification.

## 11. Completion report contract

Report:

1. result: `PASS`, `BLOCKED`, or `PARTIAL`;
2. target branch, starting/completion commit, synchronization, push, and final worktree;
3. changed files and core behavior;
4. validation commands and exact results;
5. artifacts and retained evidence identity;
6. triggered plan/spec/governance/version updates;
7. incomplete items and immediate next recommendation;
8. execution-process blockage assessment.

Do not continue into the next task or phase in the same session unless this capsule explicitly authorizes that exact combined closure.
