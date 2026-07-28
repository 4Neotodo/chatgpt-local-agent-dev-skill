from __future__ import annotations

from pathlib import Path
import json

import pytest

from project_governance_skill.generator import (
    ConfigurationError,
    TEMPLATE_MAP,
    check_repository,
    generate,
    load_config,
)


def config() -> dict[str, str]:
    return load_config(
        None,
        {
            "project_name": "Test Project",
            "repository": "owner/test-project",
            "default_branch": "main",
            "integration_branch": "develop/v0.1",
            "primary_language": "zh-CN",
            "test_command": "python -m pytest -q",
            "code_root": "src/",
            "project_purpose": "A deterministic test project.",
            "created_date": "2026-07-28",
        },
    )


def test_missing_project_name_is_rejected() -> None:
    with pytest.raises(ConfigurationError):
        load_config(None, {})


def test_generate_creates_all_paths(tmp_path: Path) -> None:
    results = generate(tmp_path, config())
    assert {item.status for item in results} == {"created"}
    assert {item.path for item in results} == set(TEMPLATE_MAP)
    for path in TEMPLATE_MAP:
        assert (tmp_path / path).is_file()


def test_generated_config_is_valid_json(tmp_path: Path) -> None:
    special = config()
    special["project_purpose"] = 'Purpose with "quotes" and 中文.'
    generate(tmp_path, special)
    data = json.loads((tmp_path / ".project-governance/config.json").read_text(encoding="utf-8"))
    assert data["project_purpose"] == special["project_purpose"]


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


def test_check_repository_detects_missing_and_unresolved(tmp_path: Path) -> None:
    generate(tmp_path, config())
    missing, unresolved = check_repository(tmp_path)
    assert missing == []
    assert unresolved == []

    (tmp_path / "PLANS.md").unlink()
    (tmp_path / "AGENTS.md").write_text("{{UNRESOLVED}}\n", encoding="utf-8")
    missing, unresolved = check_repository(tmp_path)
    assert missing == ["PLANS.md"]
    assert unresolved == ["AGENTS.md"]
