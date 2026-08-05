from __future__ import annotations

import json
from pathlib import Path

from project_governance_skill.cli import main


def write_config(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "project_name": "CLI Project",
                "repository": "owner/cli-project",
                "integration_branch": "develop/v0.2",
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


def test_cli_init_and_check_json(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_config(config_path)

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
    assert all(item["status"] == "created" for item in init_output["results"])

    assert main(["check", "--repo-root", str(repo_root), "--strict", "--json"]) == 0
    check_output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert check_output["passed"] is True
    assert check_output["strict"] is True


def test_cli_dry_run_json_writes_nothing(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_config(config_path)

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
    assert not repo_root.exists()


def test_cli_strict_fails_unconfirmed_marker(tmp_path: Path, capsys: object) -> None:
    config_path = tmp_path / "input.json"
    repo_root = tmp_path / "repo"
    write_config(config_path)
    assert main(["init", "--repo-root", str(repo_root), "--config", str(config_path)]) == 0
    capsys.readouterr()  # type: ignore[attr-defined]

    (repo_root / "README.md").write_text("[TBD: purpose]\n", encoding="utf-8")
    assert main(["check", "--repo-root", str(repo_root), "--strict", "--json"]) == 1
    output = json.loads(capsys.readouterr().out)  # type: ignore[attr-defined]
    assert output["passed"] is False
    assert output["unconfirmed_markers"] == ["README.md"]
