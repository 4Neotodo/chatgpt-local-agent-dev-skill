from __future__ import annotations

from importlib import resources
import json
from pathlib import Path
import re
from typing import Iterable, Mapping

from .config import load_config
from .profiles import (
    COMPACT_DISALLOWED_PATHS,
    COMPACT_PROFILE_MARKER,
    COMPACT_SERIAL_PROFILE,
    COMPACT_TEMPLATE_MAP,
    DEFAULTS,
    DEFAULT_GOVERNANCE_PROFILE,
    FULL_COLLABORATION_PROFILE,
    FULL_TEMPLATE_MAP,
    GOVERNANCE_CONTRACT_VERSION,
    INTEGER_RULES,
    LEGACY_GOVERNANCE_CONTRACT_VERSION,
    PERSISTED_KEYS,
    PERSISTED_KEYS_BY_PROFILE,
    PROFILE_TEMPLATE_MAPS,
    SUPPORTED_GOVERNANCE_CONTRACT_VERSIONS,
    SUPPORTED_GOVERNANCE_PROFILES,
    TEMPLATE_MAP,
    ConfigurationError,
    FileResult,
    normalize_profile,
    persisted_keys_for_profile,
    template_map_for_profile,
)
from .validation import RepositoryCheck, check_repository

PLACEHOLDER_RE = re.compile(r"{{([A-Z][A-Z0-9_]*)}}")


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

    profile = normalize_profile(config.get("governance_profile", DEFAULT_GOVERNANCE_PROFILE))
    template_map = template_map_for_profile(profile)
    persisted_keys = persisted_keys_for_profile(profile)

    results: list[FileResult] = []
    for relative_path, template_name in template_map.items():
        target = (root / relative_path).resolve()
        if root != target and root not in target.parents:
            raise ConfigurationError(f"Unsafe target path: {relative_path}")

        if relative_path == ".project-governance/config.json":
            content = json.dumps(
                {key: config[key] for key in persisted_keys},
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


def format_results(results: Iterable[FileResult]) -> str:
    return "\n".join(f"{item.status:11} {item.path}" for item in results)
