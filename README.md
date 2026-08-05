# ChatGPT × Local Agent Project Development Governance Skill

一个与具体业务、技术栈和本地 Agent 品牌无关的项目开发协作与治理 Skill。

它把远端 ChatGPT 的规划审查与远端实现、本地 Agent 的正式 worktree 执行、Git 分支写入所有权、固定来源 SHA、任务胶囊、风险分级、并行 Lane、共享资源、停止预算、证据交接和串行集成整理为可复用的仓库初始化能力。目标不是建设通用项目管理平台，而是在新项目或既有仓库中生成一套足够小、职责清晰、可核验、可版本化的顶层管控文件，使协作方式可以稳定复刻。

当前版本：`0.2.0`。

## 0.2.0 的核心变化

相较 `0.1.0`，本版本不再只描述“ChatGPT 规划、本地 Agent 执行”，而是形成完整的远端／本地协作合同：

- 五类正式任务：`【规划审查】`、`【远端实现】`、`【本地执行】`、`【并行执行编排】`、`【并行结果集成验收】`；
- 一个分支同一时刻只有一个写入者；
- 任务分支、长期目标分支和固定 `source_head` 分离；
- 远端与本地交接必须经过 commit、push、完整 SHA 核验和所有权释放／取得；
- 正式 Lane 由任务、唯一分支、正式 worktree、当前 writer、任务胶囊和独立证据路径组成；
- 并行结果只由唯一 `integration_owner` 串行集成；
- 具名责任人、状态机、共享资源、外部调用预算和可枚举暂停代码进入正式模板；
- 停止预算按具体 blocker 指纹计数，不因更换 Agent、模型、会话或执行端而重置；
- 新增 `check --strict` 与 JSON 输出，便于本地 Agent 做确定性门禁。

## 适用场景

- 新仓库建立远端 ChatGPT 与本地 Agent 的协同开发基线；
- 既有仓库需要从聊天约定升级为仓库内正式治理；
- 需要允许 ChatGPT 通过 GitHub 承担经授权的远端文档或代码修改；
- 需要让 Codex、Claude Code、Kimi、Gemini CLI 或其他本地 Agent 服从同一套执行合同；
- 需要多分支、多 worktree 或多 Agent 并行，但要求一分支一写入者、证据隔离和串行集成；
- 需要明确 Provider、发布、删除、迁移等外部或不可逆动作的调用预算与停止条件。

## 生成内容

初始化器默认只创建缺失文件，不覆盖现有文件：

```text
README.md
AGENTS.md
CHATGPT.md
PLANS.md
VERSION_MATRIX.md
.project-governance/config.json
docs/00_project_overview/PROJECT_OVERVIEW.md
docs/00_project_overview/PROJECT_GOVERNANCE.md
docs/02_dev_plans/BRANCH_TASK_CONTROL_TEMPLATE.md
docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md
docs/02_dev_plans/PARALLEL_GROUP_CONTROL_TEMPLATE.md
docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md
docs/03_execution_reports/PLANNING_REVIEW_TEMPLATE.md
docs/03_execution_reports/HANDOFF_TEMPLATE.md
docs/03_execution_reports/INTEGRATION_REPORT_TEMPLATE.md
```

各入口职责分离：

| 文件 | 只负责 |
|---|---|
| `README.md` | 稳定项目说明和最小权威入口 |
| `AGENTS.md` | 任意授权 Agent 的仓库级长期执行纪律 |
| `CHATGPT.md` | 远端规划、远端实现、并行编排和审查纪律 |
| `PLANS.md` | 当前路线、活跃长期分支、治理上限和紧邻下一任务 |
| `VERSION_MATRIX.md` | 版本、正式资产和历史交付身份 |
| 项目治理决议 | 长期协作、所有权、worktree、状态、预算与集成合同 |
| 分支任务控制 | 单一长期分支的目标、边界、基线、门禁和下一任务 |
| 任务胶囊 | 单次任务的具体授权、责任人、状态、预算和验收合同 |
| 并行组控制 | Lane 分配、容量、共享资源、暂停条件和集成顺序 |
| 各类报告 | 一次规划、执行、交接或集成事实，不替代长期规则 |

## 快速开始

要求 Python 3.11 或更高版本，无运行时第三方依赖。

```bash
python -m venv .venv
# Windows: .venv\Scripts\python -m pip install -e .
# POSIX:   .venv/bin/python -m pip install -e .

cp examples/minimal/project-governance.json /path/to/target/project-governance.json

project-governance-init init \
  --repo-root /path/to/target \
  --config /path/to/target/project-governance.json \
  --dry-run

project-governance-init init \
  --repo-root /path/to/target \
  --config /path/to/target/project-governance.json

project-governance-init check --repo-root /path/to/target
project-governance-init check --repo-root /path/to/target --strict
```

完全不安装时：

```bash
python scripts/project_governance_init.py init \
  --repo-root /path/to/target \
  --config examples/minimal/project-governance.json \
  --dry-run

python scripts/project_governance_init.py check \
  --repo-root /path/to/target \
  --strict
```

`init` 和 `check` 均支持 `--json`，供本地 Agent、CI 或确定性脚本读取。

## 最小配置

`examples/minimal/project-governance.json` 包含：

```json
{
  "project_name": "Example Project",
  "repository": "owner/example-project",
  "default_branch": "main",
  "integration_branch": "develop/v0.1",
  "formal_worktree_root": "/worktrees/example-project",
  "maximum_active_write_lanes": 1,
  "maximum_read_only_audit_lanes": 1,
  "same_blocker_attempt_budget": 2,
  "total_failed_recovery_budget": 4,
  "no_progress_checkpoint_budget": 2
}
```

新项目默认只允许 1 个主动写入 Lane。需要提升并行度时，应先通过规划审查确认独立分支、正式 worktree、唯一 writer、共享资源和串行集成均已具备可核验证据，而不是因设备性能或自动 worktree 数量充足直接提高并行数。

## 初始化与既有仓库升级

### 新仓库

1. 核实仓库、默认分支、集成路线和当前完整 SHA。
2. 配置项目事实、正式 worktree 根目录、验证命令和治理上限。
3. 先运行 `--dry-run`，再生成缺失文件。
4. 处理所有 `[待确认:...]` 项。
5. 运行普通和严格 `check`。
6. 在唯一任务分支提交、推送并交由规划审查确认。

### 既有仓库

不要直接对现有权威文件使用 `--force`。应：

1. 盘点现有 `README.md`、`AGENTS.md`、计划、规格和分支控制；
2. 在临时目录或独立任务分支生成 `0.2.0` 基线；
3. 对照差异，区分已有权威、真实冲突和缺失合同；
4. 通过规划审查冻结升级范围；
5. 只把获批差异原子写入目标仓库；
6. 重新执行严格校验并报告完整 SHA。

`--force` 只是明确授权后的确定性覆盖能力，不是自动迁移机制。

## 协作主流程

```text
规划审查／任务分配
→ 固定 source_ref + source_head
→ 唯一任务分支和 writer 取得所有权
→ 远端实现或正式本地 worktree 执行
→ 验证、commit、push、完整 SHA 核验
→ writer 释放所有权
→ 本地／人工接受
→ 唯一 integration owner 串行集成
→ 复验、关闭、worktree 清理和证据登记
```

远端与本地不能同时写同一分支。执行期间分支出现未知移动时，不自动 pull、merge 或 rebase，而是进入 `PAUSED_BRANCH_OWNERSHIP_CONFLICT`。

## 核心原则

- **事实优先：** 当前 GitHub／Git／worktree 事实高于聊天记忆。
- **一分支一写入者：** 多会话、多 Agent 和远端／本地均不例外。
- **任务胶囊服从上位规则：** 单次任务不得自行改变范围、架构、规格、治理、分支目标或版本身份。
- **任务类型与风险分离：** 谁负责和需要多少证据是两个维度。
- **执行事实与长期结论分离：** 一次运行不反向制造永久规则。
- **并行显式且有上限：** 一个 Lane 一套分支、worktree、writer、胶囊和证据；最终串行集成。
- **停止预算不因换人换模型重置：** 重试必须带来实质性纠正动作和新证据。
- **用户不承担例行操作：** 用户只承担不可替代的决策、授权和业务／视觉接受。
- **外部调用先闭合授权：** 调用次数、身份、输入输出、重试、fallback、证据和停止条件必须预先固定。
- **必要、简洁、价值大于成本：** 不因一次事故建设通用平台或复杂系统。

## 校验语义

普通 `check` 检查：

- 所有要求路径存在；
- 文件可按 UTF-8 读取；
- 没有未渲染的 `{{TEMPLATE_TOKEN}}`；
- `.project-governance/config.json` 的合同版本和数值字段有效。

`check --strict` 额外检查显式 `[待确认]`、`[TODO]` 和 `[TBD]` 标记。只有准备宣告初始化完成或治理升级闭环时，才应把严格检查作为硬门禁。

## 项目边界

本项目只负责生成和校验治理基线，不替代：

- 产品架构、业务规格和版本规划；
- 项目自己的 worktree 管理脚本；
- CI、发布、部署或 Provider 适配器；
- 通用任务数据库、Web 控制台、审批流或自动合并平台。
