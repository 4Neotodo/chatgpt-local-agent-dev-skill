<!-- project-governance-profile: compact_serial -->
# Compact Serial Task Capsule Template

> 适用于一个串行任务。实例化后必须替换所有适用的方括号占位；不适用字段写 `not_applicable`，不得留空。

```yaml
task_id: [unique task id]
task_type: 【规划审查】 | 【实现执行】
risk_level: L0 | L1 | L2 | L3
repository: {{REPOSITORY}}
governance_profile: compact_serial
project_target_branch: [target branch]
task_branch: [unique task branch or not_applicable for read-only planning]
source_ref: [verified source branch/ref]
source_head: [full 40-character SHA]
execution_side: local | remote | not_applicable
current_writer: [one writer or not_applicable]
planning_owner: [owner]
validation_owner: [owner]

objective:
  - [observable objective]

allowed_changes:
  - [specific path or behavior]

forbidden_changes:
  - [specific excluded path, behavior, contract, or operation]

required_context:
  - [minimum authoritative file, commit, issue, or artifact]

required_checks:
  - command: [exact command]
    purpose: [what it proves]
    pass_condition: [observable condition]

acceptance_criteria:
  - [observable behavior, artifact, diff, or user acceptance]

external_actions:
  - action: not_applicable | [provider call / publish / deploy / delete / migrate / other]
    target_or_identity: not_applicable | [exact target]
    integer_budget: 0
    retry_policy: no_retry | [exact policy]
    fallback_policy: none | [exact authorized fallback]
    evidence: not_applicable | [path or native record]
    redaction_boundary: not_applicable | [rule]
    explicit_authorization: false
    stop_condition: [condition]

stop_rule:
  same_blocker_attempt_budget: {{SAME_BLOCKER_ATTEMPT_BUDGET}}
  reset_on_agent_change: false
  reset_on_model_change: false
  reset_on_session_change: false
  reset_on_execution_side_change: false

handoff_if_writer_changes:
  required: false
  outgoing_commit: not_applicable
  outgoing_push_verified: false
  outgoing_writer_released: false
  incoming_exact_sha_verified: false
  incoming_clean_state_verified: false

initial_state: PLANNED
allowed_terminal_states:
  - BLOCKED
  - READY_FOR_REVIEW
  - CLOSED

final_report_fields:
  - repository_and_branches
  - source_head
  - completed_commit
  - changed_files
  - commands_and_results
  - acceptance_evidence
  - external_action_count
  - blocker_attempts
  - push_and_remote_sha
  - ownership_release
  - final_worktree_state
  - next_action
```

## 1. 有效性门禁

以下任一项缺失时，任务为 `INVALID_TASK_CAPSULE`，不得开始写入：

- 完整来源 SHA；
- 唯一 writer；
- 具体 allowed / forbidden changes；
- 至少一个与影响匹配的检查或明确 `not_applicable` 理由；
- 可观察验收标准；
- 外部动作预算和授权；
- 可枚举终态。

## 2. 串行限制

本胶囊不包含且不得临时增加：

- lane_id；
- parallel_group_id；
- formal_worktree_path；
- competitive candidate；
- integration_owner；
- integration_order。

出现上述真实需求时，停止并升级为 `full_collaboration`，不能在本模板内自造字段绕过 profile。

## 3. 状态转换

```text
PLANNED
→ IN_PROGRESS
→ READY_FOR_REVIEW
→ CLOSED
```

发生范围、来源、所有权、授权、验证或 blocker 问题时：

```text
PLANNED | IN_PROGRESS | READY_FOR_REVIEW
→ BLOCKED
```

只有规划审查解决问题并更新胶囊或来源身份后，才能从 `BLOCKED` 重新开始。

## 4. writer 切换

同一 writer 从开始执行到 push 完成时，handoff 字段保持 `required: false`。writer 需要切换时，必须先更新为 `true`，并完成：

1. 原 writer commit、push；
2. 核实远端完整 SHA；
3. 原 writer 明确释放；
4. 新 writer fetch；
5. 新 writer核实相同 SHA、干净工作区、任务分支和授权；
6. 新 writer取得写入权。

任何一步缺失都保持 `BLOCKED`。

## 5. 完成条件

进入 `READY_FOR_REVIEW` 之前必须满足：

- 修改未超出 allowed changes；
- forbidden changes 未触发；
- required checks 已执行并记录；
- 外部动作未超预算；
- commit 已 push；
- 完整远端 SHA 已核实；
- 执行报告完整；
- writer 已释放或明确保持到审查修订。
