# Context Handoff — [Project / Branch / Task]

## 1. Repository state

- Repository: `[owner/name]`
- Branch: `[branch]`
- Current remote head: `[full SHA]`
- Worktree at handoff: `[clean/unknown/not applicable]`
- Branch/task state: `[state]`

## 2. Current authority

1. `[path]`
2. `[path]`
3. `AGENTS.md`
4. `CHATGPT.md`

## 3. Completed work

- `[task/result/commit]`

## 4. Current blocker or unresolved decision

`[Separate product-result blocker, execution-process blocker, and non-blocking friction.]`

## 5. Retained local evidence

| Path | Identity | Provenance | Required by | Cleanup condition |
|---|---|---|---|---|
| `[.tmp/task-id/file]` | `[SHA256/size]` | `[source]` | `[next task]` | `[condition]` |

If none, state `None`.

## 6. Immediate next task

- Task ID: `[id]`
- Type/risk: `[type] / [level]`
- Objective: `[one closure]`
- Required context: `[minimal paths]`
- Acceptance: `[exact result]`

## 7. Prohibited continuation

- `[do not call Provider / do not enter next phase / do not modify frozen files / do not replace evidence]`

This handoff is a navigation aid. It does not replace formal decisions, branch task control, or the next task capsule.
