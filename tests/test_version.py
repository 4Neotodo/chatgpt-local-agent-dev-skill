from __future__ import annotations

from pathlib import Path
import re
import tomllib

from project_governance_skill import __version__
from project_governance_skill.generator import GOVERNANCE_CONTRACT_VERSION


def test_release_versions_are_aligned() -> None:
    root = Path(__file__).resolve().parents[1]
    pyproject = tomllib.loads((root / "pyproject.toml").read_text(encoding="utf-8"))
    skill = (root / "SKILL.md").read_text(encoding="utf-8")
    match = re.search(r"^version:\s*([^\s]+)$", skill, flags=re.MULTILINE)

    assert match is not None
    assert pyproject["project"]["version"] == "0.2.0"
    assert __version__ == "0.2.0"
    assert GOVERNANCE_CONTRACT_VERSION == "0.2.0"
    assert match.group(1) == "0.2.0"
