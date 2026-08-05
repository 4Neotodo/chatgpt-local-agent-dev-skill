from __future__ import annotations

from pathlib import Path
import json

import pytest

from project_governance_skill.generator import (
    COMPACT_DISALLOWED_PATHS,
    COMPACT_PROFILE_MARKER,
    COMPACT_SERIAL_PROFILE,
    COMPACT_TEMPLATE_MAP,
    ConfigurationError,
    FULL_COLLABORATION_PROFILE,
    FULL_TEMPLATE_MAP,
    GOVERNANCE_CONTRACT_VERSION,
    LEGACY_GOVERNANCE_CONTRACT_VERSION,
    TEMPLATE_MAP,
    check_repository,
    generate,
    load_config,
)


def full_config() -> dict[str, str | int | bool]:
    return load_config(
        None,
        {
            "project_name": "Test Project",
            "repository": "owner/test-project",
            "default_branch": "main",
            "integration_branch": "develop/v0.3",
            "primary_language": "zh-CN",
            "test_command": "python -m pytest -q",
            "code_root": "src/",
            "project_purpose": "A deterministic governed test project.",
            "current_status": "Initialization / Planning Review Required",
            "next_task": "Test-Project-P1-governance-confirmation",
            "formal_worktree_root": "/worktrees/test-project",
            "auto_worktree_root": "not_applicable",
            "evidence_root": ".tmp",
            "local_config_root": ".local",
            "maximum_active_write_lanes": 1,
            "maximum_read_only_audit_lanes": 1,
            "same_blocker_attempt_budget": 2,
            "total_failed_recovery_budget": 4,
            "no_progress_checkpoint_budget": 2,
            "created_date": "2026-08-05",
        },
    )


def compact_config() -> dict[str, str | int | bool]:
    return load_config(
        None,
        {
            "governance_profile": COMPACT_SERIAL_PROFILE,
            "project_name": "Compact Project",
            "repository": "owner/compact-project",
            "default_branch": "main",
            "primary_language": "zh-CN",
            "test_command": "python -m pytest -q",
            "code_root": "src/",
            "project_purpose": "A one-to-three-day serial project.",
            "current_status": "Initialization / Planning Review Required",
            "next_task": "Compact-P1-freeze-scope",
            "evidence_root": ".tmp",
            "local_config_root": ".local",
            "same_blocker_attempt_budget": 2,
            "estimated_duration_days": 2,
            "created_date": "2026-08-05",
        },
    )


def test_backward_compatible_template_map_is_full_profile() -> None:
    assert TEMPLATE_MAP is FULL_TEMPLATE_MAP


def test_missing_project_name_is_rejected() -> None:
    with pytest.raises(ConfigurationError):
        load_config(None, {})


def test_unknown_profile_is_rejected() -> None:
    with pytest.raises(ConfigurationError, match="Unsupported governance_profile"):
        load_config(None, {"project_name": "Test", "governance_profile": "tiny"})


@pytest.mark.parametrize(
    ("key", "value"),
    [
        ("maximum_active_write_lanes", 0),
        ("maximum_read_only_audit_lanes", -1),
        ("same_blocker_attempt_budget", True),
        ("total_failed_recovery_budget", "many"),
        ("no_progress_checkpoint_budget", 0),
    ],
)
def test_invalid_full_integer_config_is_rejected(key: str, value: object) -> None:
    with pytest.raises(ConfigurationError):
        load_config(None, {"project_name": "Test", key: value})


@pytest.mark.parametrize("duration", [0, 4, True, "many"])
def test_invalid_compact_duration_is_rejected(duration: object) -> None:
    with pytest.raises(ConfigurationError):
        load_config(
            None,
            {
                "project_name": "Test",
                "governance_profile": COMPACT_SERIAL_PROFILE,
                "estimated_duration_days": duration,
            },
        )


def test_numeric_strings_are_normalized() -> None:
    loaded = load_config(
        None,
        {
            "project_name": "Test",
            "maximum_active_write_lanes": "2",
            "maximum_read_only_audit_lanes": "0",
        },
    )
    assert loaded["maximum_active_write_lanes"] == 2
    assert loaded["maximum_read_only_audit_lanes"] == 0


def test_missing_profile_defaults_to_full_for_v02_compatibility() -> None:
    loaded = load_config(None, {"project_name": "Test"})
    assert loaded["governance_profile"] == FULL_COLLABORATION_PROFILE


@pytest.mark.parametrize(
    ("key", "value"),
    [
        ("integration_branch", "develop/v0.3"),
        ("formal_worktree_root", "/worktrees/compact"),
        ("auto_worktree_root", "/auto"),
        ("maximum_active_write_lanes", 2),
        ("maximum_read_only_audit_lanes", 1),
    ],
)
def test_compact_structural_constraints_are_enforced(key: str, value: object) -> None:
    with pytest.raises(ConfigurationError, match="compact_serial constraints violated"):
        load_config(
            None,
            {
                "project_name": "Compact",
                "governance_profile": COMPACT_SERIAL_PROFILE,
                key: value,
            },
        )


@pytest.mark.parametrize(
    "key",
    ["total_failed_recovery_budget", "no_progress_checkpoint_budget"],
)
def test_compact_rejects_full_only_stop_budgets(key: str) -> None:
    with pytest.raises(ConfigurationError, match="does not support full-profile"):
        load_config(
            None,
            {
                "project_name": "Compact",
                "governance_profile": COMPACT_SERIAL_PROFILE,
                key: 2,
            },
        )


def test_generate_full_creates_all_full_paths(tmp_path: Path) -> None:
    results = generate(tmp_path, full_config())
    assert {item.status for item in results} == {"created"}
    assert {item.path for item in results} == set(FULL_TEMPLATE_MAP)
    for path in FULL_TEMPLATE_MAP:
        assert (tmp_path / path).is_file()


def test_generate_compact_creates_only_compact_paths(tmp_path: Path) -> None:
    results = generate(tmp_path, compact_config())
    assert {item.status for item in results} == {"created"}
    assert {item.path for item in results} == set(COMPACT_TEMPLATE_MAP)
    assert not (tmp_path / "README.md").exists()
    assert not (tmp_path / "VERSION_MATRIX.md").exists()
    for path in COMPACT_TEMPLATE_MAP:
        assert (tmp_path / path).is_file()


def test_generated_full_config_is_valid_and_typed_json(tmp_path: Path) -> None:
    special = full_config()
    special["project_purpose"] = 'Purpose with "quotes" and 中文.'
    special["maximum_active_write_lanes"] = 2
    generate(tmp_path, special)
    data = json.loads(
        (tmp_path / ".project-governance/config.json").read_text(encoding="utf-8")
    )
    assert data["project_purpose"] == special["project_purpose"]
    assert data["governance_contract_version"] == GOVERNANCE_CONTRACT_VERSION
    assert data["governance_profile"] == FULL_COLLABORATION_PROFILE
    assert data["maximum_active_write_lanes"] == 2
    assert isinstance(data["maximum_active_write_lanes"], int)
    assert "estimated_duration_days" not in data


def test_generated_compact_config_omits_full_only_fields(tmp_path: Path) -> None:
    generate(tmp_path, compact_config())
    data = json.loads(
        (tmp_path / ".project-governance/config.json").read_text(encoding="utf-8")
    )
    assert data["governance_contract_version"] == GOVERNANCE_CONTRACT_VERSION
    assert data["governance_profile"] == COMPACT_SERIAL_PROFILE
    assert data["estimated_duration_days"] == 2
    for key in (
        "integration_branch",
        "formal_worktree_root",
        "maximum_active_write_lanes",
        "maximum_read_only_audit_lanes",
        "total_failed_recovery_budget",
        "no_progress_checkpoint_budget",
    ):
        assert key not in data


def test_generated_full_contract_contains_current_collaboration_primitives(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    agents = (tmp_path / "AGENTS.md").read_text(encoding="utf-8")
    capsule = (tmp_path / "docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md").read_text(
        encoding="utf-8"
    )
    governance = (
        tmp_path / "docs/00_project_overview/PROJECT_GOVERNANCE.md"
    ).read_text(encoding="utf-8")

    for task_type in (
        "【规划审查】",
        "【远端实现】",
        "【本地执行】",
        "【并行执行编排】",
        "【并行结果集成验收】",
    ):
        assert task_type in agents

    for field in (
        "source_head:",
        "task_branch:",
        "lane_owner:",
        "remote_writer:",
        "local_writer:",
        "validation_owner:",
        "integration_owner:",
        "closure_owner:",
        "external_call_budgets:",
        "stop_budgets:",
        "handoff_contract:",
    ):
        assert field in capsule

    assert "one branch has at most one current writer" in governance
    assert "git update-ref" in governance
    assert "normalized_error_signature" in governance
    assert "reset_on_model_change: false" in governance


def test_generated_compact_contract_is_serial_and_has_upgrade_triggers(tmp_path: Path) -> None:
    generate(tmp_path, compact_config())
    agents = (tmp_path / "AGENTS.md").read_text(encoding="utf-8")
    capsule = (tmp_path / "docs/02_dev_plans/TASK_CAPSULE_TEMPLATE.md").read_text(
        encoding="utf-8"
    )
    control = (
        tmp_path / "docs/00_project_overview/PROJECT_CONTROL.md"
    ).read_text(encoding="utf-8")

    assert COMPACT_PROFILE_MARKER in agents
    assert "不要求专门 worktree" in agents
    assert "【实现执行】" in capsule
    assert "lane_id" in capsule
    assert "不得临时增加" in capsule
    assert "compact_serial → full_collaboration" in control
    assert "1–3" in control


def test_second_generate_is_unchanged_for_both_profiles(tmp_path: Path) -> None:
    full_root = tmp_path / "full"
    compact_root = tmp_path / "compact"
    generate(full_root, full_config())
    generate(compact_root, compact_config())
    assert {item.status for item in generate(full_root, full_config())} == {"unchanged"}
    assert {item.status for item in generate(compact_root, compact_config())} == {"unchanged"}


def test_existing_different_file_is_skipped_without_force(tmp_path: Path) -> None:
    target = tmp_path / "AGENTS.md"
    target.write_text("custom\n", encoding="utf-8")
    results = {item.path: item.status for item in generate(tmp_path, compact_config())}
    assert results["AGENTS.md"] == "skipped"
    assert target.read_text(encoding="utf-8") == "custom\n"


def test_force_overwrites_existing_file(tmp_path: Path) -> None:
    target = tmp_path / "AGENTS.md"
    target.write_text("custom\n", encoding="utf-8")
    results = {
        item.path: item.status for item in generate(tmp_path, compact_config(), force=True)
    }
    assert results["AGENTS.md"] == "overwritten"
    assert COMPACT_PROFILE_MARKER in target.read_text(encoding="utf-8")


@pytest.mark.parametrize("factory", [full_config, compact_config])
def test_dry_run_writes_nothing(tmp_path: Path, factory: object) -> None:
    config = factory()  # type: ignore[operator]
    results = generate(tmp_path, config, dry_run=True)
    assert {item.status for item in results} == {"created"}
    assert not any(tmp_path.iterdir())


@pytest.mark.parametrize("factory", [full_config, compact_config])
def test_check_repository_passes_normal_and_strict(
    tmp_path: Path,
    factory: object,
) -> None:
    config = factory()  # type: ignore[operator]
    generate(tmp_path, config)
    normal = check_repository(tmp_path)
    strict = check_repository(tmp_path, strict=True)
    assert normal.passed
    assert strict.passed
    assert normal.profile == config["governance_profile"]
    assert normal.contract_version == GOVERNANCE_CONTRACT_VERSION
    assert normal.missing == ()
    assert normal.unresolved_template_tokens == ()
    assert normal.unconfirmed_markers == ()
    assert normal.config_errors == ()
    assert normal.profile_errors == ()


def test_check_repository_detects_missing_unresolved_and_unconfirmed(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    (tmp_path / "PLANS.md").unlink()
    (tmp_path / "AGENTS.md").write_text("{{UNRESOLVED}}\n", encoding="utf-8")
    (tmp_path / "README.md").write_text("[TODO: confirm purpose]\n", encoding="utf-8")

    report = check_repository(tmp_path, strict=True)
    assert not report.passed
    assert report.missing == ("PLANS.md",)
    assert report.unresolved_template_tokens == ("AGENTS.md",)
    assert report.unconfirmed_markers == ("README.md",)


def test_non_strict_check_reports_but_does_not_fail_unconfirmed_marker(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    (tmp_path / "README.md").write_text("[待确认:purpose]\n", encoding="utf-8")
    report = check_repository(tmp_path)
    assert report.passed
    assert report.unconfirmed_markers == ("README.md",)


def test_check_detects_contract_version_mismatch(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    config_path = tmp_path / ".project-governance/config.json"
    data = json.loads(config_path.read_text(encoding="utf-8"))
    data["governance_contract_version"] = "9.9.9"
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("governance_contract_version" in item for item in report.config_errors)


def test_check_detects_missing_current_profile_field(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    config_path = tmp_path / ".project-governance/config.json"
    data = json.loads(config_path.read_text(encoding="utf-8"))
    del data["governance_profile"]
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("missing governance_profile" in item for item in report.config_errors)


@pytest.mark.parametrize(
    ("factory", "missing_key"),
    [
        (full_config, "maximum_active_write_lanes"),
        (compact_config, "estimated_duration_days"),
    ],
)
def test_check_detects_missing_profile_persisted_field(
    tmp_path: Path,
    factory: object,
    missing_key: str,
) -> None:
    config = factory()  # type: ignore[operator]
    generate(tmp_path, config)
    config_path = tmp_path / ".project-governance/config.json"
    data = json.loads(config_path.read_text(encoding="utf-8"))
    del data[missing_key]
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any(f"missing {missing_key}" in item for item in report.config_errors)


def test_legacy_v02_full_repository_is_accepted(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    config_path = tmp_path / ".project-governance/config.json"
    data = json.loads(config_path.read_text(encoding="utf-8"))
    data["governance_contract_version"] = LEGACY_GOVERNANCE_CONTRACT_VERSION
    del data["governance_profile"]
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = check_repository(tmp_path, strict=True)
    assert report.passed
    assert report.profile == FULL_COLLABORATION_PROFILE
    assert report.contract_version == LEGACY_GOVERNANCE_CONTRACT_VERSION


def test_check_profile_argument_must_match_config(tmp_path: Path) -> None:
    generate(tmp_path, compact_config())
    report = check_repository(tmp_path, profile=FULL_COLLABORATION_PROFILE)
    assert not report.passed
    assert any("does not match configured profile" in item for item in report.profile_errors)


def test_compact_check_rejects_disallowed_parallel_or_integration_paths(tmp_path: Path) -> None:
    generate(tmp_path, compact_config())
    disallowed = tmp_path / COMPACT_DISALLOWED_PATHS[0]
    disallowed.parent.mkdir(parents=True, exist_ok=True)
    disallowed.write_text("legacy full path\n", encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("disallowed full-profile path" in item for item in report.profile_errors)


def test_compact_check_requires_profile_marker(tmp_path: Path) -> None:
    generate(tmp_path, compact_config())
    agents = tmp_path / "AGENTS.md"
    agents.write_text(
        agents.read_text(encoding="utf-8").replace(COMPACT_PROFILE_MARKER + "\n", ""),
        encoding="utf-8",
    )

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("does not contain the compact_serial profile marker" in item for item in report.profile_errors)


def test_full_check_rejects_unreconciled_compact_shared_files(tmp_path: Path) -> None:
    generate(tmp_path, full_config())
    agents = tmp_path / "AGENTS.md"
    agents.write_text(COMPACT_PROFILE_MARKER + "\n" + agents.read_text(encoding="utf-8"), encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("still compact_serial" in item for item in report.profile_errors)
