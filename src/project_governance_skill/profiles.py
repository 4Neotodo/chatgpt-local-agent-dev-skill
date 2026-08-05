from __future__ import annotations

from dataclasses import dataclass
from typing import Any


GOVERNANCE_CONTRACT_VERSION = "0.3.0"
LEGACY_GOVERNANCE_CONTRACT_VERSION = "0.2.0"
SUPPORTED_GOVERNANCE_CONTRACT_VERSIONS = (
    LEGACY_GOVERNANCE_CONTRACT_VERSION,
    GOVERNANCE_CONTRACT_VERSION,
)

FULL_COLLABORATION_PROFILE = "full_collaboration"
COMPACT_SERIAL_PROFILE = "compact_serial"
DEFAULT_GOVERNANCE_PROFILE = FULL_COLLABORATION_PROFILE
SUPPORTED_GOVERNANCE_PROFILES = (
    COMPACT_SERIAL_PROFILE,
    FULL_COLLABORATION_PROFILE,
)

COMPACT_PROFILE_MARKER = "<!-- project-governance-profile: compact_serial -->"

FULL_TEMPLATE_MAP: dict[str, str] = {
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

COMPACT_TEMPLATE_MAP: dict[str, str] = {
    "AGENTS.md": "compact_target_AGENTS.md.tpl",
    "CHATGPT.md": "compact_target_CHATGPT.md.tpl",
    "PLANS.md": "compact_target_PLANS.md.tpl",
    ".project-governance/config.json": "target_config.json.tpl",
    "docs/00_project_overview/PROJECT_CONTROL.md": "compact_target_PROJECT_CONTROL.md.tpl",
    "docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md": "compact_target_TASK_CAPSULE_TEMPLATE.md.tpl",
    "docs/03_execution_reports/EXECUTION_REPORT_TEMPLATE.md": "compact_target_EXECUTION_REPORT_TEMPLATE.md.tpl",
}

PROFILE_TEMPLATE_MAPS: dict[str, dict[str, str]] = {
    FULL_COLLABORATION_PROFILE: FULL_TEMPLATE_MAP,
    COMPACT_SERIAL_PROFILE: COMPACT_TEMPLATE_MAP,
}

# Compatibility exports for callers that used the former single profile.
TEMPLATE_MAP = FULL_TEMPLATE_MAP

COMPACT_DISALLOWED_PATHS = (
    "docs/02_dev_plans/PARALLEL_GROUP_CONTROL_TEMPLATE.md",
    "docs/03_execution_reports/INTEGRATION_REPORT_TEMPLATE.md",
)

COMMON_DEFAULTS: dict[str, str | int | bool] = {
    "repository": "[待确认:repository]",
    "default_branch": "main",
    "primary_language": "zh-CN",
    "test_command": "[待确认:test_command]",
    "code_root": "[待确认:code_root]",
    "project_purpose": "[待确认:project_purpose]",
    "current_status": "Initialization / Planning Review Required",
    "next_task": "Establish the first approved branch task control and task capsule",
    "evidence_root": ".tmp",
    "local_config_root": ".local",
    "same_blocker_attempt_budget": 2,
}

PROFILE_DEFAULTS: dict[str, dict[str, str | int | bool]] = {
    FULL_COLLABORATION_PROFILE: {
        "integration_branch": "[待确认:integration_branch]",
        "formal_worktree_root": "[待确认:formal_worktree_root]",
        "auto_worktree_root": "not_applicable",
        "maximum_active_write_lanes": 1,
        "maximum_read_only_audit_lanes": 1,
        "total_failed_recovery_budget": 4,
        "no_progress_checkpoint_budget": 2,
    },
    COMPACT_SERIAL_PROFILE: {
        "next_task": "Establish the first approved compact task capsule",
        "integration_branch": "not_applicable",
        "formal_worktree_root": "not_applicable",
        "auto_worktree_root": "not_applicable",
        "maximum_active_write_lanes": 1,
        "maximum_read_only_audit_lanes": 0,
        "estimated_duration_days": 3,
    },
}

DEFAULTS: dict[str, str | int | bool] = {
    **COMMON_DEFAULTS,
    **PROFILE_DEFAULTS[FULL_COLLABORATION_PROFILE],
    "governance_profile": FULL_COLLABORATION_PROFILE,
}

REQUIRED_KEYS = {"project_name"}
INTEGER_RULES: dict[str, tuple[int, int | None]] = {
    "maximum_active_write_lanes": (1, None),
    "maximum_read_only_audit_lanes": (0, None),
    "same_blocker_attempt_budget": (1, None),
    "total_failed_recovery_budget": (1, None),
    "no_progress_checkpoint_budget": (1, None),
    "estimated_duration_days": (1, 3),
}

COMMON_PERSISTED_KEYS = [
    "governance_contract_version",
    "governance_profile",
    "project_name",
    "repository",
    "default_branch",
    "primary_language",
    "test_command",
    "code_root",
    "project_purpose",
    "current_status",
    "next_task",
    "evidence_root",
    "local_config_root",
    "same_blocker_attempt_budget",
]

FULL_PERSISTED_KEYS = [
    *COMMON_PERSISTED_KEYS,
    "integration_branch",
    "formal_worktree_root",
    "auto_worktree_root",
    "maximum_active_write_lanes",
    "maximum_read_only_audit_lanes",
    "total_failed_recovery_budget",
    "no_progress_checkpoint_budget",
    "created_date",
]

COMPACT_PERSISTED_KEYS = [
    *COMMON_PERSISTED_KEYS,
    "estimated_duration_days",
    "created_date",
]

PERSISTED_KEYS_BY_PROFILE: dict[str, list[str]] = {
    FULL_COLLABORATION_PROFILE: FULL_PERSISTED_KEYS,
    COMPACT_SERIAL_PROFILE: COMPACT_PERSISTED_KEYS,
}

PERSISTED_KEYS = FULL_PERSISTED_KEYS

LEGACY_V02_REQUIRED_CONFIG_KEYS = {
    "maximum_active_write_lanes",
    "maximum_read_only_audit_lanes",
    "same_blocker_attempt_budget",
    "total_failed_recovery_budget",
    "no_progress_checkpoint_budget",
}

PROFILE_INTEGER_KEYS: dict[str, tuple[str, ...]] = {
    FULL_COLLABORATION_PROFILE: (
        "maximum_active_write_lanes",
        "maximum_read_only_audit_lanes",
        "same_blocker_attempt_budget",
        "total_failed_recovery_budget",
        "no_progress_checkpoint_budget",
    ),
    COMPACT_SERIAL_PROFILE: (
        "maximum_active_write_lanes",
        "maximum_read_only_audit_lanes",
        "same_blocker_attempt_budget",
        "estimated_duration_days",
    ),
}

COMPACT_UNSUPPORTED_EXPLICIT_KEYS = {
    "total_failed_recovery_budget",
    "no_progress_checkpoint_budget",
}


class ConfigurationError(ValueError):
    """Raised when project governance configuration is invalid."""


@dataclass(frozen=True)
class FileResult:
    path: str
    status: str


def normalize_profile(value: Any) -> str:
    profile = str(value).strip()
    if profile not in SUPPORTED_GOVERNANCE_PROFILES:
        supported = ", ".join(SUPPORTED_GOVERNANCE_PROFILES)
        raise ConfigurationError(
            f"Unsupported governance_profile {profile!r}; expected one of: {supported}"
        )
    return profile


def template_map_for_profile(profile: str) -> dict[str, str]:
    return PROFILE_TEMPLATE_MAPS[normalize_profile(profile)]


def persisted_keys_for_profile(profile: str) -> list[str]:
    return PERSISTED_KEYS_BY_PROFILE[normalize_profile(profile)]
