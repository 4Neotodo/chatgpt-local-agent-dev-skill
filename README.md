# ChatGPT × Local Agent Project Development Skill

一个与具体业务、技术栈和本地 Agent 品牌无关的项目开发治理 Skill。

它把 ChatGPT 远端规划审查、本地 Agent 实现验证、Git 分支控制、任务胶囊、风险分级、证据交接、版本身份和执行报告整理为可复用的初始化能力。目标不是建设通用项目管理平台，而是在新项目或既有仓库中生成一套足够小、职责清晰、可审计的顶层管控文件，使开发协同方式可以稳定复刻。

## 适用场景

- 新仓库建立 ChatGPT 与本地 Agent 协同开发基线；
- 既有仓库缺少统一的 `AGENTS.md`、路线入口、版本身份和任务控制；
- 需要让 Codex、Claude Code、Kimi、Gemini CLI 或其他本地 Agent 遵循同一套开发纪律；
- 需要把一次性聊天约定固化为仓库内可读取、可版本化的长期规则。

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
docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md
docs/03_execution_reports/PLANNING_REVIEW_TEMPLATE.md
docs/03_execution_reports/HANDOFF_TEMPLATE.md
```

各入口职责严格分离：

| 文件 | 只负责 |
|---|---|
| `README.md` | 稳定项目说明和最小入口 |
| `AGENTS.md` | 本地 Agent 的仓库级长期执行纪律 |
| `CHATGPT.md` | ChatGPT 远端规划、审查和任务胶囊规则 |
| `PLANS.md` | 当前路线、活跃分支和紧邻下一任务 |
| `VERSION_MATRIX.md` | 版本、正式资产和历史交付身份 |
| 分支任务控制 | 单一分支的目标、边界、门禁、状态和下一任务 |
| 任务胶囊 | 单次执行的具体授权和验收合同 |
| 执行报告 | 一次执行事实，不替代长期规则 |

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
```

也可以完全不安装：

```bash
python scripts/project_governance_init.py init \
  --repo-root /path/to/target \
  --config examples/minimal/project-governance.json

python scripts/project_governance_init.py check \
  --repo-root /path/to/target
```

`PYTHONPATH=src python -m project_governance_skill ...` 仍可作为等价入口。

## 初始化工作流

1. 本地 Agent 核实仓库、目标分支、工作区和同步状态。
2. 读取 `SKILL.md`，盘点目标仓库已有入口，避免覆盖或复制职责。
3. 创建项目配置 JSON，先执行 `--dry-run`。
4. 生成缺失文件；已有文件默认 `skipped`，只有明确授权才使用 `--force`。
5. 将模板中的项目范围、路线、测试命令和版本身份改成真实内容。
6. 运行 `check`、必要测试和 `git diff`。
7. 显式暂存任务文件，形成小提交并推送目标分支。
8. ChatGPT 通过 GitHub 复核文档职责、边界和下一任务，再决定是否收口。

## 核心原则

- **任务真实需要优先：** 不机械读取全仓库文档。
- **必要、简洁、价值大于成本：** 不因一次误操作建设复杂平台或状态机。
- **执行事实与长期结论分离：** Git、测试和报告记录一次执行；规格、计划和治理文件记录长期结论。
- **任务胶囊服从上位规则：** 单次任务不得自行覆盖正式决议和仓库纪律。
- **验证匹配真实影响：** 不机械全测，也不以低价值检查代替真实验收。
- **本地 Agent 品牌中立：** 规则不依赖 Codex；任何具备本地文件、命令和 Git 能力的 Agent 均可执行。
- **外部调用先授权：** 真实 Provider、发布、删除、迁移和不可逆操作必须在调用前闭合身份与授权。

## 项目状态

当前为 `0.1.0` 初始基线：模板、确定性初始化器、校验命令和最小测试已包含。它只负责生成治理基线，不替代项目本身的架构规划、业务规格或实施决策。
