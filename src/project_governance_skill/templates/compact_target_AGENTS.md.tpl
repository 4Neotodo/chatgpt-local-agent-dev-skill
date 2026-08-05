<!-- project-governance-profile: compact_serial -->
# AGENTS.md

## 1. 适用合同

本仓库使用 `compact_serial` 治理 profile。

项目：`{{PROJECT_NAME}}`
仓库：`{{REPOSITORY}}`
默认分支：`{{DEFAULT_BRANCH}}`
预计周期：`{{ESTIMATED_DURATION_DAYS}}` 个工作日

该 profile 只适用于预计 1–3 个工作日内完成、单仓库、单一当前写入者、无计划并行、无多结果集成且验收路径较短的小项目。它降低协调结构，不降低 Git、范围、验证、外部动作和证据要求。

任一前提失效时，停止扩展并返回规划审查，决定是否升级为 `full_collaboration`。不得在 compact 合同中临时拼接 Lane、并行组、竞争性实现或复杂集成流程。

## 2. 权威顺序

按以下顺序解释任务：

1. 用户当前明确授权与已接受的规划结论；
2. 仓库现行规格、治理与项目控制；
3. 根目录 `AGENTS.md`、`CHATGPT.md`、`PLANS.md` 的职责范围；
4. 当前已实例化任务胶囊；
5. 固定 Git 提交、测试、产物和执行报告所证明的一次执行事实；
6. 历史聊天和历史报告仅作溯源，不自动成为现行规则。

低层文件不得静默覆盖高层决议。出现范围、规格、架构、版本身份或治理冲突时，进入 `BLOCKED` 并返回规划审查。

## 3. 串行协作主流程

默认流程为：

```text
ChatGPT 规划审查
→ 形成一个窄任务胶囊
→ 唯一 writer 在唯一任务分支串行执行
→ 运行影响匹配的验证
→ commit、push、核实完整 SHA
→ 提交执行报告
→ ChatGPT 审查并决定继续、修订或关闭
```

正式任务只有两类：

- `【规划审查】`：范围、规格、路线、任务拆分、风险与结果审查；
- `【实现执行】`：经授权的代码、文档、测试、产物和必要 Git 写入。

`execution_side` 使用 `local` 或 `remote` 表示执行端。执行端不是新的任务类型，也不改变风险等级。

## 4. 开始前 Git 门禁

任何写入前至少核实：

```bash
git branch --show-current
git status --short
git remote -v
git fetch origin --prune
git rev-parse HEAD
```

并确认：

- 仓库与远端正确；
- 工作区无无关改动；
- 当前分支、目标分支与任务胶囊一致；
- `source_head` 是写入前即时核实的完整 SHA；
- 当前 writer 唯一且没有远端／本地重叠写入；
- 任务允许的修改、禁止修改和验收标准已经闭合。

发现 dirty worktree、未知提交、分支移动、所有权不明或来源 SHA 不一致时立即停止。不得用自动 pull、merge、rebase、reset、stash 或冲突吸收掩盖问题。

本 profile **不要求专门 worktree**。普通干净 checkout 即可。若执行者自行使用 worktree，它只是本地实现细节，不得被提升为项目长期合同，也不得据此启动并行写入。

## 5. 分支与写入所有权

- 一个分支同一时刻只有一个 current writer；
- 默认分支不直接写入，除非用户明确授权该次直接写入；
- 实现任务通常从已核实 `source_head` 创建一个短期任务分支；
- 不创建并行 Lane、竞争分支或多结果集成分支；
- 远端 ChatGPT 与本地 Agent 不得同时写同一分支；
- 更换 Agent、模型、会话或执行端不会自动释放或重置所有权。

如果任务始终由同一 writer 完成，不需要额外交接文档。只有 writer 发生切换时，才执行固定 SHA 交接：

```text
原 writer commit + push
→ 核实远端完整 SHA
→ 明确释放写入权
→ 新 writer fetch 并核实同一 SHA、干净工作区和分支身份
→ 新 writer 取得写入权
```

未完成上述步骤不得切换 writer。

## 6. 任务胶囊合同

每次正式执行必须有一个已实例化任务胶囊，至少声明：

```yaml
task_id:
task_type:
risk_level:
repository:
target_branch:
task_branch:
source_head:
execution_side:
current_writer:
planning_owner:
validation_owner:
allowed_changes:
forbidden_changes:
required_context:
required_checks:
acceptance_criteria:
external_actions:
initial_state:
allowed_terminal_states:
final_report_fields:
```

空闲字段使用 `not_applicable`，不得留空。缺少来源 SHA、writer、范围、检查或验收标准时，任务无效，不得先写后补。

任务胶囊是窄执行授权，不得自行修改：

- 产品范围与业务规则；
- 架构、公共接口、正式规格与数据合同；
- 分支路线、版本身份与治理 profile；
- 外部调用、发布、迁移、删除或其他不可逆动作授权；
- 验收对象与通过标准。

如实现需要触碰上述内容，停止并返回规划审查。

## 7. 风险与验证

风险等级：

- `L0`：纯文档或状态修正，不改变行为、合同、输出或身份；
- `L1`：窄局部实现，不改变共享合同、业务输出或正式版本；
- `L2`：共享行为、业务能力、schema、输出、基础能力或跨组件合同变化；
- `L3`：生产交付、正式发布、真实外部生命周期、迁移或用户环境验收。

compact 项目通常应保持在 L0–L2。出现 L3 不代表绝对禁止，但必须先回到规划审查，确认项目仍适合 compact；复杂 L3 默认升级为 `full_collaboration`。

验证必须匹配真实影响：

- 运行受影响模块的确定性测试；
- 对公共合同、schema、生成产物或 CLI 行为做直接验收；
- 不机械全测，也不得用低价值 smoke 代替必要的业务或产物验证；
- 记录实际命令、退出码、关键输出和失败分类；
- 测试通过不自动授权 merge、发布或关闭上级路线。

## 8. 外部与不可逆动作

真实 Provider 调用、发布、部署、删除、迁移、凭据修改、正式版本替换或其他不可逆动作，必须在执行前写入任务胶囊：

```yaml
action:
target_or_identity:
integer_budget:
retry_policy:
fallback_policy:
evidence:
redaction_boundary:
explicit_authorization:
stop_condition:
```

预算必须是非负整数，不得写“按需”。一次失败不会自动授权下一次调用、参数变化或 fallback。

## 9. 停止规则

默认同一具体 blocker 的有效纠正尝试上限为 `{{SAME_BLOCKER_ATTEMPT_BUDGET}}`。

一次有效尝试必须同时包含：

1. 明确的错误摘要或失败命令；
2. 与前次不同的实质性纠正动作；
3. 对应检查点重新执行；
4. 新的原生证据；
5. 结果仍失败。

首次发现和诊断不自动计为纠正尝试。重复同一命令、只改提示词、换 Agent、换模型、换会话或换执行端，不构成预算重置。

达到上限、连续没有新证据，或继续执行需要扩大范围时，状态转为 `BLOCKED`，停止写入并返回规划审查。

## 10. 状态

compact 任务只使用：

```text
PLANNED
IN_PROGRESS
BLOCKED
READY_FOR_REVIEW
CLOSED
```

- `PLANNED`：任务合同完整，尚未开始写入；
- `IN_PROGRESS`：唯一 writer 正在执行；
- `BLOCKED`：存在需要规划、授权或所有权处理的问题；
- `READY_FOR_REVIEW`：实现、验证、commit、push 和报告完成；
- `CLOSED`：结果已被接受，任务关闭。

不得为小项目引入更细状态机，除非规划审查决定升级 profile。

## 11. 执行报告

完成或阻断时至少报告：

- repository、target branch、task branch；
- 起始 `source_head` 和最终完整 commit SHA；
- 当前 writer 与写入权释放状态；
- 修改文件与范围偏差；
- 实际执行命令、测试和验收结果；
- 外部动作次数与证据；
- blocker、有效尝试次数和剩余风险；
- push 与远端 SHA 核实结果；
- 工作区最终状态；
- 下一步只能是什么。

执行事实写入报告；长期范围、路线、规格和版本结论写入对应权威文件。不要让一次报告反向制造永久规则。

## 12. 升级为 full_collaboration 的触发条件

出现任一情况，暂停 compact 扩展并进行规划审查：

- 预计总周期超过 3 个工作日；
- 需要第二个同时活跃的 writer；
- 需要并行实现、独立审计 Lane 或竞争性候选；
- 需要多个任务分支结果再集成；
- 需要长期集成分支、正式 worktree 分配或共享资源调度；
- 需要复杂生产迁移、正式发布链或多阶段不可逆动作；
- 单一任务胶囊无法清晰表达依赖、验收与停止条件。

升级必须通过审查生成新增 full 文件，并审阅替换共享治理文件。不得自动删除 compact 文件，也不得仅修改配置名称后宣称升级完成。
