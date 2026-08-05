# ChatGPT × Local Agent Project Development Governance Skill

一个与具体业务、技术栈和本地 Agent 品牌无关的项目开发协作与治理 Skill。

它把远端 ChatGPT 的规划审查与经授权远端实现、本地 Agent 的正式执行、Git 写入所有权、固定来源 SHA、任务胶囊、验证证据、外部动作授权和结果交接整理为可复用的仓库初始化能力。`0.3.0` 在同一代码库中提供两个一等治理 profile：

- `compact_serial`：面向预计 1–3 个工作日完成、单仓库、单 writer、无计划并行的小项目；
- `full_collaboration`：面向长期、多分支、worktree、Lane、并行审计／实现和串行集成项目。

两个 profile 共享核心安全合同。compact 减少协调结构，不降低 Git、范围、验证、外部调用和证据要求。

当前版本：`0.3.0`。

## 选择 profile

| 条件 | `compact_serial` | `full_collaboration` |
|---|---:|---:|
| 预计周期 | 1–3 个工作日 | 不限 |
| 同时活跃 writer | 1 | 可多个，但一分支一 writer |
| 计划并行 | 不允许 | 显式 Lane 与容量 |
| 正式 worktree | 不要求 | 本地写 Lane 必须分配 |
| 多结果集成 | 不允许 | 唯一 integration owner 串行集成 |
| 独立审计 Lane | 不允许 | 支持 |
| 状态与停止预算 | 5 个状态、单 blocker 尝试上限 | 完整状态、暂停代码和多维预算 |
| 适合风险 | 通常 L0–L2 | L0–L3 |

`compact_serial` 只有在以下条件同时成立时才适用：单仓库、单一当前 writer、无计划并行或竞争性候选、无多个结果再集成、分支路线短、验收可观察、风险主要不超过 L2，并且项目扩大时可以先停下升级。工期只是必要条件之一，不是充分条件。

出现第二 writer、并行、独立审计、正式 worktree/Lane、多个任务结果集成、复杂生产迁移或长期路线时，应选择或升级为 `full_collaboration`。

## 生成内容

### compact_serial

默认生成 7 个治理路径，不接管目标项目的 `README.md`：

```text
AGENTS.md
CHATGPT.md
PLANS.md
.project-governance/config.json
docs/00_project_overview/PROJECT_CONTROL.md
docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md
docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md
```

它保留：

- 仓库事实优先；
- 一个分支一个 writer；
- 固定 `source_head`；
- ChatGPT 规划／审查与本地 Agent 执行分工；
- 窄任务胶囊；
- 影响匹配验证；
- 外部动作整数预算；
- 固定 SHA writer 切换；
- 同一 blocker 的有限纠正尝试；
- profile 升级门禁。

它不生成：正式 worktree、Lane、并行组、竞争性候选、分支集成控制、独立 handoff 报告或 integration 报告。

### full_collaboration

生成原 `0.2.0` 完整 15 文件基线：

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

完整 profile 保留五类正式任务、唯一分支 writer、固定来源 SHA、正式 worktree/Lane、共享资源、停止预算、固定 SHA 交接和唯一 integration owner 串行集成。

## 快速开始

要求 Python 3.11 或更高版本，无运行时第三方依赖。

```bash
python -m venv .venv
# Windows: .venv\Scripts\python -m pip install -e .
# POSIX:   .venv/bin/python -m pip install -e .
```

### 小项目

```bash
cp examples/compact/project-governance.json /path/to/project/project-governance.json

project-governance-init init \
  --profile compact_serial \
  --repo-root /path/to/project \
  --config /path/to/project/project-governance.json \
  --dry-run

project-governance-init init \
  --profile compact_serial \
  --repo-root /path/to/project \
  --config /path/to/project/project-governance.json

project-governance-init check \
  --profile compact_serial \
  --repo-root /path/to/project \
  --strict
```

### 完整协作项目

```bash
cp examples/minimal/project-governance.json /path/to/project/project-governance.json

project-governance-init init \
  --profile full_collaboration \
  --repo-root /path/to/project \
  --config /path/to/project/project-governance.json \
  --dry-run

project-governance-init init \
  --profile full_collaboration \
  --repo-root /path/to/project \
  --config /path/to/project/project-governance.json

project-governance-init check \
  --profile full_collaboration \
  --repo-root /path/to/project \
  --strict
```

也可以不安装：

```bash
python scripts/project_governance_init.py init \
  --profile compact_serial \
  --repo-root /path/to/project \
  --config examples/compact/project-governance.json
```

`init` 和 `check` 均支持 `--json`。`--profile` 可以来自 CLI 或配置；`check --profile` 与配置不一致时会失败，而不是静默切换。

## compact 配置

```json
{
  "governance_profile": "compact_serial",
  "project_name": "Example Compact Project",
  "repository": "owner/example-project",
  "default_branch": "main",
  "primary_language": "zh-CN",
  "test_command": "python -m pytest -q",
  "code_root": "src/",
  "project_purpose": "Deliver one bounded capability through a serial ChatGPT/local-Agent workflow.",
  "current_status": "Initialization / Planning Review Required",
  "next_task": "Project-P1-scope-contract-and-first-task-capsule",
  "evidence_root": ".tmp",
  "local_config_root": ".local",
  "same_blocker_attempt_budget": 2,
  "estimated_duration_days": 2
}
```

compact 固定约束：

```text
integration_branch = not_applicable
formal_worktree_root = not_applicable
auto_worktree_root = not_applicable
maximum_active_write_lanes = 1
maximum_read_only_audit_lanes = 0
```

这些值由 profile 默认并校验，不进入 compact 输出配置。compact 也不接受 full 专用的 `total_failed_recovery_budget` 和 `no_progress_checkpoint_budget`。

## 初始化与升级

### 新仓库

1. 先通过规划审查选择 profile；
2. 核实仓库、默认分支和当前完整 SHA；
3. 完成 profile 对应配置；
4. 先执行 `--dry-run`；
5. 生成缺失文件；
6. 处理所有项目级 `[待确认]`；
7. 运行普通和严格检查；
8. 在唯一任务分支提交、推送并审查。

### 既有仓库

不要直接对已有权威文件使用 `--force`。应先在临时目录或独立任务分支生成所选 profile，比较已有权威与候选合同，再只写入批准差异。

### compact → full

支持升级，但不是自动迁移：

1. 规划审查确认 compact 前提已经失效；
2. 将配置改为 `full_collaboration`；
3. 在隔离目录生成 full 候选；
4. 新增 full 专用文件；
5. 审阅并明确替换共享 `AGENTS.md`、`CHATGPT.md`、`PLANS.md`、任务胶囊和执行报告；
6. 运行 full 严格检查；
7. 提交、推送并审查。

仅改配置名称或只生成缺失文件不会通过 profile 一致性检查。自动 full → compact 降级不受支持，避免误删长期治理合同。

## v0.2 兼容性

`0.3.0` 接受没有 `governance_profile` 的 `0.2.0` 配置，并将其解释为 legacy `full_collaboration`。新生成的 `0.3.0` 配置必须显式声明 profile。

原有 Python 导入 `TEMPLATE_MAP`、`DEFAULTS` 和 `PERSISTED_KEYS` 继续指向完整 profile，减少调用方破坏。

## 校验语义

普通 `check` 检查：

- 根据配置 profile 推导的必需路径；
- UTF-8；
- 未渲染 `{{TEMPLATE_TOKEN}}`；
- 合同版本和 profile；
- profile 对应的持久化字段和数值规则；
- compact marker 与 full/compact 共享文件一致性；
- compact 下不应存在并行组和集成报告路径。

`check --strict` 额外对 `[待确认]`、`[TODO]`、`[TBD]` 失败。只有准备宣告初始化或升级完成时，才应把 strict 作为硬门禁。

## 核心原则

- **事实优先：** 当前 GitHub／Git 事实高于聊天记忆。
- **一分支一 writer：** profile 不改变此规则。
- **任务胶囊是窄授权：** 不得自行扩大范围、规格、版本或外部动作。
- **任务类型与风险分离：** 责任分工不等于低风险。
- **验证匹配真实影响：** 不机械全测，也不以 smoke 替代真实验收。
- **执行事实与长期结论分离。**
- **用户只承担不可替代的判断与授权。**
- **必要、简洁、价值大于成本。**

## 项目边界

本项目只负责生成和校验治理基线，不替代：

- 产品架构、业务规格和版本规划；
- 项目自己的 worktree 或 CI 管理；
- 发布、部署、Provider 适配器或任务数据库；
- 通用审批流、Web 控制台或自动合并平台。
