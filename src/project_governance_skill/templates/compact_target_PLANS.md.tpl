<!-- project-governance-profile: compact_serial -->
# PLANS.md

## 当前路线

- 项目：`{{PROJECT_NAME}}`
- 仓库：`{{REPOSITORY}}`
- 治理 profile：`compact_serial`
- 预计周期：`{{ESTIMATED_DURATION_DAYS}}` 个工作日
- 默认分支：`{{DEFAULT_BRANCH}}`
- 并行执行：不适用
- 正式 worktree 分配：不适用
- 多结果集成：不适用

## 项目目标

{{PROJECT_PURPOSE}}

## 当前状态

`{{CURRENT_STATUS}}`

## 串行路线

```text
规划审查
→ 一个已授权任务分支
→ 唯一 writer 实现与验证
→ commit / push / 完整 SHA 核实
→ ChatGPT 结果审查
→ 修订或关闭
```

## 治理上限

- 同一时刻只允许 1 个 writer；
- 不创建 Lane、并行组、竞争性候选或集成报告；
- 同一具体 blocker 的有效纠正尝试上限：`{{SAME_BLOCKER_ATTEMPT_BUDGET}}`；
- 外部与不可逆动作必须在任务胶囊中逐项授权；
- 预计周期超过 3 天、需要并行／多分支集成或复杂 L3 时，先升级规划，不继续扩展 compact。

## 紧邻下一任务

`{{NEXT_TASK}}`

除非规划审查更新本文件，任何执行报告不得自行改变路线、范围或下一任务。
