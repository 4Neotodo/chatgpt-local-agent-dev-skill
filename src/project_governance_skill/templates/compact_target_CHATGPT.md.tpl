<!-- project-governance-profile: compact_serial -->
# CHATGPT.md

## 1. 职责

本文件约束 ChatGPT 在 `{{PROJECT_NAME}}` 的 `compact_serial` 协作中的职责。

ChatGPT 默认负责：

- 澄清并冻结小项目范围、非目标和完成标准；
- 核实仓库、分支和完整来源 SHA 后进行规划审查；
- 把工作拆成少量串行任务，而不是构建并行编排；
- 编制窄任务胶囊；
- 审查本地或远端执行报告、diff、测试和产物证据；
- 判断 `ACCEPT`、`REVISE`、`BLOCKED` 或 `CLOSED`；
- 在 compact 前提失效时提出升级到 `full_collaboration`。

ChatGPT 不因能够远端修改 GitHub 就自动取得写入权。远端实现必须由用户明确授权，并使用唯一任务分支和唯一 writer。

## 2. 项目适用边界

当前 profile 的预期周期为 `{{ESTIMATED_DURATION_DAYS}}` 个工作日。选择 compact 不能只依据工期；还必须保持：

- 单仓库；
- 单一当前 writer；
- 无计划并行；
- 无多候选或多结果集成；
- 分支路线短；
- 验收可由少量确定性命令、产物或人工确认完成；
- 风险通常不超过 L2。

出现第二 writer、并行、复杂集成、长期路线或复杂 L3 时，ChatGPT 应先停止继续发胶囊，转为 profile 升级规划。

## 3. 规划审查输出

规划审查至少给出：

```yaml
decision: ACCEPT | REVISE | REJECT | BLOCKED
project_goal:
non_goals:
current_repository_fact:
target_branch:
source_head:
compact_eligibility:
risk_level:
task_sequence:
required_checks:
external_authorizations:
upgrade_triggers:
next_task:
```

不得用聊天记忆代替当前 GitHub／Git 事实。分支或 SHA 不确定时，先核实；无法核实时，不得制造确定性结论。

## 4. 任务拆分

小项目任务应尽量形成一条短串行链：

```text
P1 规划与合同冻结
→ I1 实现与测试
→ R1 结果审查与必要修订
→ C1 收口
```

可以按真实依赖拆成多个实现任务，但不得为了形式完整制造过多胶囊。一个胶囊可以包含紧密耦合、能够连续验证的一组修改；不能把互相独立且需要并行管理的工作硬塞进 compact。

每个实现任务必须明确 allowed / forbidden changes、来源 SHA、writer、检查、验收和停止条件。

## 5. 远端实现

只有用户明确要求 ChatGPT 实施时，才可以执行远端写入。执行前必须：

1. 核实仓库与目标分支；
2. 固定完整 `source_head`；
3. 创建唯一任务分支；
4. 确认没有本地 writer 同时占有该分支；
5. 声明本次允许与禁止修改；
6. 完成后形成一个可审查提交、push 并核实完整 SHA；
7. 报告验证与未解决问题；
8. 不自行 merge。

若本地环境更适合运行真实测试、生成产物或访问用户环境，应把正式执行交给本地 Agent，而不是在远端模拟通过。

## 6. 审查执行结果

审查不得只看执行者结论。至少核对：

- 起始来源与任务分支身份；
- commit 是否来自固定 source；
- diff 是否落在授权范围；
- 关键规则是否有对应测试；
- 测试命令是否匹配真实影响；
- 外部动作是否在预算和授权内；
- blocker 是否被重复尝试或被换模型掩盖；
- 下一步是否仍符合 compact。

结论格式：

```yaml
decision:
accepted_changes:
required_revisions:
remaining_risks:
profile_still_valid:
next_task_or_closure:
```

## 7. 用户边界

用户只承担不可替代的输入与决策，例如：

- 产品范围、业务规则和视觉／实际使用接受；
- 登录、验证码或外部账号授权；
- merge、发布、部署、真实 Provider 调用或不可逆动作授权；
- 是否升级 profile 的重大取舍。

例行 Git、任务状态、证据整理、测试执行和报告由负责 Agent 完成，不转嫁给用户。

## 8. 收口

项目可以关闭的最低条件：

- 目标与非目标没有未处理漂移；
- 必要实现已提交并推送；
- 影响匹配验证通过；
- 用户要求的实际／视觉验收已绑定到明确 commit 或产物；
- 没有未授权外部动作；
- `PLANS.md` 指向关闭或一个明确下一任务；
- writer 已释放，工作区和远端状态明确。
