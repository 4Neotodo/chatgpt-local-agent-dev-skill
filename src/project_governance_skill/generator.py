from __future__ import annotations

from dataclasses import dataclass
from datetime import date
from importlib import resources
import json
from pathlib import Path
import re
from typing import Any, Iterable, Mapping


GOVERNANCE_CONTRACT_VERSION = "0.2.0"
PLACEHOLDER_RE = re.compile(r"{{([A-Z][A-Z0-9_]*)}}")
UNCONFIRMED_RE = re.compile(r"\[(?:待确认|TODO|TBD)(?::[^\]]*)?\]", re.IGNORECASE)

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
    "docs/02_dev_plans/PARALLEL_GROUP_CONTROL_TEMPLATE.md": "target_PARALLEL_GROUP_CONTROL_TEMPLATE.md.tpl",
    "docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md": "target_EXECUTION_REPORT_TEMPLATE.md.tpl",
    "docs/03_execution_reports/PLANNING_REVIEW_TEMPLATE.md": "target_PLANNING_REVIEW_TEMPLATE.md.tpl",
    "docs/03_execution_reports/HANDOFF_TEMPLATE.md": "target_HANDOFF_TEMPLATE.md.tpl",
    "docs/03_execution_reports/INTEGRATION_REPORT_TEMPLATE.md": "target_INTEGRATION_REPORT_TEMPLATE.md.tpl",
}

DEFAULTS: dict[str, str | int | bool] = {
    "repository": "[待确认:repository]",
    "default_branch": "main",
    "integration_branch": "[待确认:integration_branch]",
    "primary_language": "zh-CN",
    "test_command": "[待确认:test_command]",
    "code_root": "[待确认:code_root]",
    "project_purpose": "[待确认:project_purpose]",
    "current_status": "Initialization / Planning Review Required",
    "next_task": "Establish the first approved branch task control and task capsule",
    "formal_worktree_root": "[待确认:formal_worktree_root]",
    "auto_worktree_root": "not_applicable",
    "evidence_root": ".tmp",
    "local_config_root": ".local",
    "maximum_active_write_lanes": 1,
    "maximum_read_only_audit_lanes": 1,
    "same_blocker_attempt_budget": 2,
    "total_failed_recovery_budget": 4,
    "no_progress_checkpoint_budget": 2,
}

REQUIRED_KEYS = {"project_name"}
INTEGER_RULES: dict[str, tuple[int, int | None]] = {
    "maximum_active_write_lanes": (1, None),
    "maximum_read_only_audit_lanes": (0, None),
    "same_blocker_attempt_budget": (1, None),
    "total_failed_recovery_budget": (1, None),
    "no_progress_checkpoint_budget": (1, None),
}

PERSISTED_KEYS = [
    "governance_contract_version",
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
    "formal_worktree_root",
    "auto_worktree_root",
    "evidence_root",
    "local_config_root",
    "maximum_active_write_lanes",
    "maximum_read_only_audit_lanes",
    "same_blocker_attempt_budget",
    "total_failed_recovery_budget",
    "no_progress_checkpoint_budget",
    "created_date",
]


class ConfigurationError(ValueError):
    """Raised when project governance configuration is invalid."""


@dataclass(frozen=True)
class FileResult:
    path: str
    status: str


@dataclass(frozen=True)
class RepositoryCheck:
    missing: tuple[str, ...]
    unresolved_template_tokens: tuple[str, ...]
    unconfirmed_markers: tuple[str, ...]
    config_errors: tuple[str, ...]
    strict: bool

    @property
    def passed(self) -> bool:
        base_failed = bool(self.missing or self.unresolved_template_tokens or self.config_errors)
        strict_failed = self.strict and bool(self.unconfirmed_markers)
        return not base_failed and not strict_failed

    def to_dict(self) -> dict[str, Any]:
        return {
            "passed": self.passed,
            "strict": self.strict,
            "missing": list(self.missing),
            "unresolved_template_tokens": list(self.unresolved_template_tokens),
            "unconfirmed_markers": list(self.unconfirmed_markers),
            "config_errors": list(self.config_errors),
        }


def load_config(
    path: Path | None,
    overrides: Mapping[str, str | int | bool | None] | None = None,
) -> dict[str, str | int | bool]:
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

    config: dict[str, str | int | bool] = {**DEFAULTS}
    for key, value in raw.items():
        if value is None or key == "governance_contract_version":
            continue
        if not isinstance(value, (str, int, float, bool)):
            raise ConfigurationError(f"Config value for {key!r} must be scalar")
        config[key] = value

    for key, (minimum, maximum) in INTEGER_RULES.items():
        config[key] = _coerce_int(key, config.get(key), minimum=minimum, maximum=maximum)

    config["created_date"] = str(raw.get("created_date") or date.today().isoformat())
    config["project_name"] = str(config["project_name"]).strip()
    config["project_slug"] = _slugify(str(config["project_name"]))
    config["governance_contract_version"] = GOVERNANCE_CONTRACT_VERSION
    return config


def _coerce_int(key: str, value: Any, *, minimum: int, maximum: int | None) -> int:
    if isinstance(value, bool):
        raise ConfigurationError(f"Config value for {key!r} must be an integer, not boolean")
    if isinstance(value, int):
        result = value
    elif isinstance(value, float) and value.is_integer():
        result = int(value)
    elif isinstance(value, str) and re.fullmatch(r"[+-]?\d+", value.strip()):
        result = int(value.strip())
    else:
        raise ConfigurationError(f"Config value for {key!r} must be an integer")

    if result < minimum:
        raise ConfigurationError(f"Config value for {key!r} must be >= {minimum}")
    if maximum is not None and result > maximum:
        raise ConfigurationError(f"Config value for {key!r} must be <= {maximum}")
    return result


def _slugify(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9._-]+", "-", value.strip()).strip("-").lower()
    return slug or "project"


def _template_text(name: str) -> str:
    return resources.files("project_governance_skill.templates").joinpath(name).read_text(encoding="utf-8")


def render(template: str, config: Mapping[str, str | int | bool]) -> str:
    keys = set(PLACEHOLDER_RE.findall(template))
    values = {
        key: str(config.get(key.lower(), f"[待确认:{key.lower()}]"))
        for key in keys
    }
    rendered = PLACEHOLDER_RE.sub(lambda match: values[match.group(1)], template)
    return rendered.replace("\r\n", "\n").rstrip() + "\n"


def generate(
    repo_root: Path,
    config: Mapping[str, str | int | bool],
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
            content = json.dumps(
                {key: config[key] for key in PERSISTED_KEYS},
                ensure_ascii=False,
                indent=2,
            ) + "\n"
        else:
            content = render(_template_text(template_name), config)

        if target.exists():
            existing = target.read_text(encoding="utf-8").replace("\r\n", "\n")
            if existing == content:
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


def check_repository(repo_root: Path, *, strict: bool = False) -> RepositoryCheck:
    root = repo_root.expanduser().resolve()
    missing: list[str] = []
    unresolved: list[str] = []
    unconfirmed: list[str] = []
    config_errors: list[str] = []

    for relative_path in TEMPLATE_MAP:
        target = root / relative_path
        if not target.is_file():
            missing.append(relative_path)
            continue
        try:
            text = target.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            config_errors.append(f"{relative_path}: not valid UTF-8: {exc}")
            continue
        if PLACEHOLDER_RE.search(text):
            unresolved.append(relative_path)
        if UNCONFIRMED_RE.search(text):
            unconfirmed.append(relative_path)

    config_path = root / ".project-governance/config.json"
    if config_path.is_file():
        try:
            raw_config = json.loads(config_path.read_text(encoding="utf-8"))
            if not isinstance(raw_config, dict):
                raise ConfigurationError("Config root must be a JSON object")
            load_config(config_path)
            declared = raw_config.get("governance_contract_version")
            if declared != GOVERNANCE_CONTRACT_VERSION:
                config_errors.append(
                    ".project-governance/config.json: governance_contract_version "
                    f"must be {GOVERNANCE_CONTRACT_VERSION!r}, got {declared!r}"
                )
            for key in INTEGER_RULES:
                if key not in raw_config:
                    config_errors.append(f".project-governance/config.json: missing {key}")
        except (ConfigurationError, json.JSONDecodeError) as exc:
            config_errors.append(f".project-governance/config.json: {exc}")

    return RepositoryCheck(
        missing=tuple(missing),
        unresolved_template_tokens=tuple(unresolved),
        unconfirmed_markers=tuple(unconfirmed),
        config_errors=tuple(config_errors),
        strict=strict,
    )


def format_results(results: Iterable[FileResult]) -> str:
    return "\n".join(f"{item.status:11} {item.path}" for item in results)
