#!/usr/bin/env python3
"""Run the governance initializer directly from a source checkout."""

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from project_governance_skill.cli import main  # noqa: E402


if __name__ == "__main__":
    raise SystemExit(main())
