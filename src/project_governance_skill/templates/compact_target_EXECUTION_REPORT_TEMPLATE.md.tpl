<!-- project-governance-profile: compact_serial -->
# Compact Serial Execution Report Template

## 1. 身份

```yaml
task_id: [task id]
task_type: 【规划审查】 | 【实现执行】
risk_level: [L0-L3]
repository: {{REPOSITORY}}
governance_profile: compact_serial
project_target_branch: [branch]
task_branch: [branch or not_applicable]
source_head: [full SHA]
completed_commit: [full SHA or not_applicable]
execution_side: [local | remote | not_applicable]
writer: [writer or not_applicable]
final_state: BLOCKED | READY_FOR_REVIEW | CLOSED
```

## 2. 范围结果

```yaml
allowed_changes_completed:
  - [item]
forbidden_changes_triggered: false
scope_deviations:
  - not_applicable
changed_files:
  - [path]
```

任何范围偏差必须列出，不能以“顺便修复”隐藏。

## 3. Git 事实

```yaml
starting_branch: [branch]
starting_head: [full SHA]
remote_source_head_verified: true | false
task_branch_created_from_source: true | false
commit_created: true | false
push_succeeded: true | false
remote_completed_sha_verified: true | false
writer_released: true | false
final_worktree_clean: true | false
```

记录未知移动、dirty worktree、非快进或所有权问题。不得用自动 pull/rebase 结果替代原始事实。

## 4. 验证

| Command / check | Exit or result | What it proves | Evidence |
|---|---:|---|---|
| `[exact command]` | `[result]` | `[purpose]` | `[path/output]` |

```yaml
required_checks_total: [integer]
required_checks_passed: [integer]
required_checks_failed: [integer]
acceptance_criteria:
  - criterion: [criterion]
    result: PASS | FAIL | NOT_RUN
    evidence: [evidence]
```

## 5. 外部动作

```yaml
external_actions:
  - action: not_applicable | [action]
    authorized_budget: 0
    actual_count: 0
    target_or_identity: not_applicable | [target]
    result: not_applicable | PASS | FAIL
    fallback_used: false
    evidence: not_applicable | [path/native record]
```

失败不会自动产生新的预算。

## 6. Blocker 与尝试

```yaml
blockers:
  - status: not_applicable | open | resolved
    error_summary: not_applicable | [summary]
    failing_operation: not_applicable | [command/operation]
    effective_correction_attempts: 0
    latest_material_change: not_applicable | [change]
    latest_native_evidence: not_applicable | [evidence]
    stop_budget_reached: false
```

换 Agent、模型、会话或重复命令不计为新纠正策略，也不重置次数。

## 7. 结果与下一步

```yaml
result_summary: [concise factual result]
remaining_risks:
  - not_applicable | [risk]
compact_profile_still_valid: true | false
next_action: [one concrete next action]
```

允许的下一步仅为：

- ChatGPT 规划／结果审查；
- 同一任务的明确修订；
- 用户业务、视觉或实际使用接受；
- 显式 merge／发布决策；
- 升级为 `full_collaboration`；
- 关闭。
