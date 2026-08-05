from __future__ import annotations

import json
from pathlib import Path

from project_governance_skill.cli import main
from project_governance_skill.generator import (
    COMPACT_SERIAL_PROFILE,
    FULL_COLLABORATION_PROFILE,
)


def write_full_config(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "project_name": "CLI Project",
                "repository": "owner/cli-project",
                "integration_branch": "develop/v0.3",
                "test_command": "python -m pytest -q",
                "code_root": "src/",
                "project_purpose": "CLI contract test.",
                "formal_worktree_root": "/worktrees/cli-project",
                "next_task": "CLI-P1-confirm",
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )


def write_compact_config(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "governance_profile": COMPACT_SERIAL_PROFILE,
                "project_name": "Compact CLI Project",
                "repository": "owner/compact-cli-project",
                "test_command": "python -m pytest -q",
                "code_root": "src/",
                "project_purpose": "Compact CLI contract test.",
                "next_task": "Compact-CLI-P1-confirm",
                "estimated_duration_days": 2,
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )


def test_cli_full_init_and_check_json(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_full_config(config_path)

    assert (
        main(
            [
                "init",
                "--repo-root",
                str(repo_root),
                "--config",
                str(config_path),
                "--json",
            ]
        )
        == 0
    )
    init_output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert init_output["dry_run"] is False
    assert init_output["profile"] == FULL_COLLABORATION_PROFILE
    assert all(item["status"] == "created" for item in init_output["results"])

    assert main(["check", "--repo-root", str(repo_root), "--strict", "--json"]) == 0
    check_output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert check_output["passed"] is True
    assert check_output["strict"] is True
    assert check_output["profile"] == FULL_COLLABORATION_PROFILE


def test_cli_compact_init_and_check_json(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_compact_config(config_path)

    assert main(["init", "--repo-root", str(repo_root), "--config", str(config_path), "--json"]) == 0
    init_output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert init_output["profile"] == COMPACT_SERIAL_PROFILE
    assert len(init_output["results"]) == 7
    assert not (repo_root / "README.md").exists()

    assert (
        main(
            [
                "check",
                "--repo-root",
                str(repo_root),
                "--profile",
                COMPACT_SERIAL_PROFILE,
                "--strict",
                "--json",
            ]
        )
        == 0
    )
    check_output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert check_output["passed"] is True
    assert check_output["profile"] == COMPACT_SERIAL_PROFILE
    assert check_output["profile_errors"] == []


def test_cli_profile_flag_can_select_compact_without_config_profile(
    tmp_path: Path,
    capsys: object,
) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_full_config(config_path)
    data = json.loads(config_path.read_text(encoding="utf-8"))
    for key in ("integration_branch", "formal_worktree_root"):
        data.pop(key, None)
    config_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    assert (
        main(
            [
                "init",
                "--repo-root",
                str(repo_root),
                "--config",
                str(config_path),
                "--profile",
                COMPACT_SERIAL_PROFILE,
                "--estimated-duration-days",
                "1",
                "--json",
            ]
        )
        == 0
    )
    output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert output["profile"] == COMPACT_SERIAL_PROFILE


def test_cli_dry_run_json_writes_nothing(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_compact_config(config_path)

    assert (
        main(
            [
                "init",
                "--repo-root",
                str(repo_root),
                "--config",
                str(config_path),
                "--dry-run",
                "--json",
            ]
        )
        == 0
    )
    output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert output["dry_run"] is True
    assert output["profile"] == COMPACT_SERIAL_PROFILE
    assert not repo_root.exists()


def test_cli_strict_fails_unconfirmed_marker(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_compact_config(config_path)
    assert main(["init", "--repo-root", str(repo_root), "--config", str(config_path)]) == 0
    capsys.readouterr()  # type: ignore[attr-defined]

    agents = repo_root / "AGENTS.md"
    agents.write_text(agents.read_text(encoding="utf-8") + "\n[TBD: purpose]\n", encoding="utf-8")
    assert main(["check", "--repo-root", str(repo_root), "--strict", "--json"]) == 1
    output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert output["passed"] is False
    assert output["unconfirmed_markers"] == ["AGENTS.md"]


def test_cli_check_profile_mismatch_fails(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_compact_config(config_path)
    assert main(["init", "--repo-root", str(repo_root), "--config", str(config_path)]) == 0
    capsys.readouterr()  # type: ignore[attr-defined]

    assert (
        main(
            [
                "check",
                "--repo-root",
                str(repo_root),
                "--profile",
                FULL_COLLABORATION_PROFILE,
                "--json",
            ]
        )
        == 1
    )
    output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert output["passed"] is False
    assert output["profile_errors"]


def test_cli_invalid_compact_duration_returns_configuration_error(
    tmp_path: Path,
    capsys: object,
) -> None:
    repo_root = tmp_path / "repo"
    assert (
        main(
            [
                "init",
                "--repo-root",
                str(repo_root),
                "--profile",
                COMPACT_SERIAL_PROFILE,
                "--project-name",
                "Bad Compact",
                "--estimated-duration-days",
                "4",
            ]
        )
        == 2
    )
    captured = capsys.readouterr()  # type: ignore[attr-defined]
    assert "Configuration error" in captured.err
