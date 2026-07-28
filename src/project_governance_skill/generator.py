from __future__ import annotations

from dataclasses import dataclass
from datetime import date
from importlib import resources
import json
from pathlib import Path
import re
from typing import Any, Iterable


PLACEHOLDER_RE = re.compile(r"{{([A-Z][A-Z0-9_]*)}}")

TEMPLATE_MAP: dict[str, str] = {
    "README.md": "target_README.md.tpl",
    "AGENTS.md": "target_AGENTS.md.tpl",
    "CHATGPT.md": "target_CHATGPT.md.tpl",
    "PLANS.md": "target_PLANS.md.tpl",
    "VERSION_MATRIX.md": "target_VERSION_MATRIX.md.tpl",
    ".project-governance/config.json": "target_config.json.tpl",
    "docs/00_project_overview/PROJECT_OVERVIEW.md": "target_PROJECT_OVERVIEW.md.tpl",
    "docs/00_project_overview/PROJECT_GOVERNANCE.md": "target_PROJECT_GOVERNANCE.md.tpl",
    "docs/02_dev_plans/BRANCH_TASK_CONTROL_TEMPLATE.md": "target_BRANCH_TASK_CONTROL_TEMPLATE.md.tpl",
    "docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md": "target_TASK_CAPSULE_TEMPLATE.md.tpl",
    "docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md": "target_EXECUTION_REPORT_TEMPLATE.md.tpl",
    "docs/03_execution_reports/PLANNING_REVIEW_TEMPLATE.md": "target_PLANNING_REVIEW_TEMPLATE.md.tpl",
    "docs/03_execution_reports/HANDOFF_TEMPLATE.md": "target_HANDOFF_TEMPLATE.md.tpl",
}

DEFAULTS: dict[str, str] = {
    "repository": "[待确认]",
    "default_branch": "main",
    "integration_branch": "[待确认]",
    "primary_language": "zh-CN",
    "test_command": "[待确认]",
    "code_root": "[待确认]",
    "project_purpose": "[待确认：用一段话说明项目稳定目标、主要输入输出和用户价值]",
    "current_status": "Initialization / Planning Review Required",
    "next_task": "Establish the first approved branch task control and task capsule",
}

REQUIRED_KEYS = {"project_name"}


class ConfigurationError(ValueError):
    """Raised when project governance configuration is invalid."""


@dataclass(frozen=True)
class FileResult:
    path: str
    status: str


def load_config(path: Path | None, overrides: dict[str, str | None] | None = None) -> dict[str, str]:
    raw: dict[str, Any] = {}
    if path is not None:
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except FileNotFoundError as exc:
            raise ConfigurationError(f"Config file not found: {path}") from exc
        except json.JSONDecodeError as exc:
            raise ConfigurationError(f"Invalid JSON config: {path}: {exc}") from exc
        if not isinstance(data, dict):
            raise ConfigurationError("Config root must be a JSON object")
        raw.update(data)

    if overrides:
        raw.update({key: value for key, value in overrides.items() if value is not None})

    missing = [key for key in sorted(REQUIRED_KEYS) if not str(raw.get(key, "")).strip()]
    if missing:
        raise ConfigurationError(f"Missing required config keys: {', '.join(missing)}")

    config: dict[str, str] = {**DEFAULTS}
    for key, value in raw.items():
        if value is None:
            continue
        if not isinstance(value, (str, int, float, bool)):
            raise ConfigurationError(f"Config value for {key!r} must be scalar")
        config[key] = str(value)

    config["created_date"] = str(raw.get("created_date") or date.today().isoformat())
    config["project_slug"] = _slugify(config["project_name"])
    return config


def _slugify(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9._-]+", "-", value.strip()).strip("-").lower()
    return slug or "project"


def _template_text(name: str) -> str:
    return resources.files("project_governance_skill.templates").joinpath(name).read_text(encoding="utf-8")


def render(template: str, config: dict[str, str]) -> str:
    keys = set(PLACEHOLDER_RE.findall(template))
    values = {key: config.get(key.lower(), f"[待确认:{key.lower()}]") for key in keys}
    rendered = PLACEHOLDER_RE.sub(lambda match: values[match.group(1)], template)
    return rendered.replace("\r\n", "\n").rstrip() + "\n"


def generate(
    repo_root: Path,
    config: dict[str, str],
    *,
    force: bool = False,
    dry_run: bool = False,
) -> list[FileResult]:
    root = repo_root.expanduser().resolve()
    if root.exists() and not root.is_dir():
        raise ConfigurationError(f"Repository root is not a directory: {root}")
    if not dry_run:
        root.mkdir(parents=True, exist_ok=True)

    results: list[FileResult] = []
    for relative_path, template_name in TEMPLATE_MAP.items():
        target = (root / relative_path).resolve()
        if root != target and root not in target.parents:
            raise ConfigurationError(f"Unsafe target path: {relative_path}")

        if relative_path == ".project-governance/config.json":
            persisted_keys = [
                "project_name",
                "repository",
                "default_branch",
                "integration_branch",
                "primary_language",
                "test_command",
                "code_root",
                "project_purpose",
                "current_status",
                "next_task",
                "created_date",
            ]
            content = json.dumps(
                {key: config[key] for key in persisted_keys},
                ensure_ascii=False,
                indent=2,
            ) + "\n"
        else:
            content = render(_template_text(template_name), config)
        if target.exists():
            existing = target.read_text(encoding="utf-8")
            if existing.replace("\r\n", "\n") == content:
                results.append(FileResult(relative_path, "unchanged"))
                continue
            if not force:
                results.append(FileResult(relative_path, "skipped"))
                continue
            status = "overwritten"
        else:
            status = "created"

        if not dry_run:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content, encoding="utf-8", newline="\n")
        results.append(FileResult(relative_path, status))

    return results


def check_repository(repo_root: Path) -> tuple[list[str], list[str]]:
    root = repo_root.expanduser().resolve()
    missing: list[str] = []
    unresolved: list[str] = []

    for relative_path in TEMPLATE_MAP:
        target = root / relative_path
        if not target.is_file():
            missing.append(relative_path)
            continue
        text = target.read_text(encoding="utf-8")
        if PLACEHOLDER_RE.search(text):
            unresolved.append(relative_path)

    return missing, unresolved


def format_results(results: Iterable[FileResult]) -> str:
    return "\n".join(f"{item.status:11} {item.path}" for item in results)
