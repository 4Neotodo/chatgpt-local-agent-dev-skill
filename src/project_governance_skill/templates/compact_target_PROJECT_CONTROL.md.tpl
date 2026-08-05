<!-- project-governance-profile: compact_serial -->
# {{PROJECT_NAME}} — Project Control

## 1. 项目事实

- Repository：`{{REPOSITORY}}`
- Default branch：`{{DEFAULT_BRANCH}}`
- Governance profile：`compact_serial`
- Expected duration：`{{ESTIMATED_DURATION_DAYS}}` working day(s)
- Code root：`{{CODE_ROOT}}`
- Controlled validation：`{{TEST_COMMAND}}`
- Evidence root：`{{EVIDENCE_ROOT}}`
- Local configuration root：`{{LOCAL_CONFIG_ROOT}}`

## 2. 目标

{{PROJECT_PURPOSE}}

## 3. compact 适用判定

本 profile 只有在以下条件同时成立时有效：

1. 预计 1–3 个工作日完成；
2. 单一代码仓库；
3. 同一时刻只有一个正式 writer；
4. 不计划并行、竞争性尝试或独立审计 Lane；
5. 只需要一个短期任务分支，不需要多个结果再集成；
6. 无长期集成分支或正式 worktree 调度需求；
7. 风险主要为 L0–L2；
8. 验收路径短且可观察；
9. 需要扩展时可以先停下并升级为 `full_collaboration`。

工期只是必要条件之一，不是单独充分条件。

## 4. 协作边界

- ChatGPT：规划、任务胶囊、远端实现（仅显式授权）和结果审查；
- Local Agent：本地实现、测试、真实产物、必要外部调用、commit 与 push；
- User：范围／业务／视觉决策及不可逆动作授权；
- 任一分支同时只有一个 writer；
- 不建立自动并行或 worktree 管理合同。

## 5. 分支路线

默认路线：

```text
{{DEFAULT_BRANCH}} @ verified full SHA
→ one short-lived task branch
→ implementation and validation
→ commit + push + exact SHA review
→ explicit merge decision
```

不得把多个独立结果直接写入共享父分支。若实际需要多个结果，说明 compact 已不适用。

## 6. 范围控制

单次任务胶囊可以授权：

- 明确列出的代码、文档和测试；
- 与目标直接相关的最小修复；
- 与修改影响匹配的验证；
- 已逐项授权的外部动作。

单次胶囊不能授权：

- 静默改变产品范围、架构或正式规格；
- 引入并行 Lane、长期集成路线或复杂状态机；
- 未授权发布、部署、迁移、删除或 Provider fallback；
- 自动 merge 或覆盖未知本地改动。

## 7. 验收与完成定义

项目完成至少满足：

- 目标行为或产物满足已冻结验收标准；
- 影响匹配测试通过；
- 所有外部动作均在预算内并有证据；
- 最终 commit 已推送且远端 SHA 已核实；
- 用户要求的实际／视觉接受已记录；
- 没有未处理 blocker 或范围漂移；
- writer 已释放，项目状态为 `CLOSED`。

## 8. 升级规则

出现以下任一项，停止实施扩展并进行规划审查：

- 总周期预计超过 3 个工作日；
- 需要两个活跃 writer；
- 需要并行、独立审计、竞争候选或多结果集成；
- 需要正式 worktree/Lane、共享资源调度或长期集成分支；
- 需要复杂生产交付、迁移或发布链；
- compact 任务模板无法无歧义表达工作。

升级只允许 `compact_serial → full_collaboration`。初始化器会生成 full 缺失文件，但不会自动覆盖共享权威文件；共享文件必须经规划审查后明确替换。禁止自动降级并删除 full 合同。
