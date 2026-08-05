from __future__ import annotations

from pathlib import Path
import json

import pytest

from project_governance_skill.generator import (
    ConfigurationError,
    GOVERNANCE_CONTRACT_VERSION,
    TEMPLATE_MAP,
    check_repository,
    generate,
    load_config,
)


def config() -> dict[str, str | int | bool]:
    return load_config(
        None,
        {
            "project_name": "Test Project",
            "repository": "owner/test-project",
            "default_branch": "main",
            "integration_branch": "develop/v0.2",
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


def test_missing_project_name_is_rejected() -> None:
    with pytest.raises(ConfigurationError):
        load_config(None, {})


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
def test_invalid_integer_config_is_rejected(key: str, value: object) -> None:
    with pytest.raises(ConfigurationError):
        load_config(None, {"project_name": "Test", key: value})


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


def test_generate_creates_all_paths(tmp_path: Path) -> None:
    results = generate(tmp_path, config())
    assert {item.status for item in results} == {"created"}
    assert {item.path for item in results} == set(TEMPLATE_MAP)
    for path in TEMPLATE_MAP:
        assert (tmp_path / path).is_file()


def test_generated_config_is_valid_and_typed_json(tmp_path: Path) -> None:
    special = config()
    special["project_purpose"] = 'Purpose with "quotes" and 中文.'
    special["maximum_active_write_lanes"] = 2
    generate(tmp_path, special)
    data = json.loads(
        (tmp_path / ".project-governance/config.json").read_text(encoding="utf-8")
    )
    assert data["project_purpose"] == special["project_purpose"]
    assert data["governance_contract_version"] == GOVERNANCE_CONTRACT_VERSION
    assert data["maximum_active_write_lanes"] == 2
    assert isinstance(data["maximum_active_write_lanes"], int)


def test_generated_contract_contains_current_collaboration_primitives(tmp_path: Path) -> None:
    generate(tmp_path, config())
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


def test_second_generate_is_unchanged(tmp_path: Path) -> None:
    generate(tmp_path, config())
    results = generate(tmp_path, config())
    assert {item.status for item in results} == {"unchanged"}


def test_existing_different_file_is_skipped_without_force(tmp_path: Path) -> None:
    target = tmp_path / "AGENTS.md"
    target.write_text("custom\n", encoding="utf-8")
    results = {item.path: item.status for item in generate(tmp_path, config())}
    assert results["AGENTS.md"] == "skipped"
    assert target.read_text(encoding="utf-8") == "custom\n"


def test_force_overwrites_existing_file(tmp_path: Path) -> None:
    target = tmp_path / "AGENTS.md"
    target.write_text("custom\n", encoding="utf-8")
    results = {item.path: item.status for item in generate(tmp_path, config(), force=True)}
    assert results["AGENTS.md"] == "overwritten"
    assert "Test Project" in target.read_text(encoding="utf-8")


def test_dry_run_writes_nothing(tmp_path: Path) -> None:
    results = generate(tmp_path, config(), dry_run=True)
    assert {item.status for item in results} == {"created"}
    assert not any(tmp_path.iterdir())


def test_check_repository_passes_normal_and_strict(tmp_path: Path) -> None:
    generate(tmp_path, config())
    normal = check_repository(tmp_path)
    strict = check_repository(tmp_path, strict=True)
    assert normal.passed
    assert strict.passed
    assert normal.missing == ()
    assert normal.unresolved_template_tokens == ()
    assert normal.unconfirmed_markers == ()
    assert normal.config_errors == ()


def test_check_repository_detects_missing_unresolved_and_unconfirmed(tmp_path: Path) -> None:
    generate(tmp_path, config())
    (tmp_path / "PLANS.md").unlink()
    (tmp_path / "AGENTS.md").write_text("{{UNRESOLVED}}\n", encoding="utf-8")
    (tmp_path / "README.md").write_text("[TODO: confirm purpose]\n", encoding="utf-8")

    report = check_repository(tmp_path, strict=True)
    assert not report.passed
    assert report.missing == ("PLANS.md",)
    assert report.unresolved_template_tokens == ("AGENTS.md",)
    assert report.unconfirmed_markers == ("README.md",)


def test_non_strict_check_reports_but_does_not_fail_unconfirmed_marker(tmp_path: Path) -> None:
    generate(tmp_path, config())
    (tmp_path / "README.md").write_text("[待确认:purpose]\n", encoding="utf-8")
    report = check_repository(tmp_path)
    assert report.passed
    assert report.unconfirmed_markers == ("README.md",)


def test_check_detects_contract_version_mismatch(tmp_path: Path) -> None:
    generate(tmp_path, config())
    config_path = tmp_path / ".project-governance/config.json"
    data = json.loads(config_path.read_text(encoding="utf-8"))
    data["governance_contract_version"] = "0.1.0"
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("governance_contract_version" in item for item in report.config_errors)


def test_check_detects_missing_persisted_numeric_field(tmp_path: Path) -> None:
    generate(tmp_path, config())
    config_path = tmp_path / ".project-governance/config.json"
    data = json.loads(config_path.read_text(encoding="utf-8"))
    del data["maximum_active_write_lanes"]
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = check_repository(tmp_path)
    assert not report.passed
    assert any("missing maximum_active_write_lanes" in item for item in report.config_errors)
