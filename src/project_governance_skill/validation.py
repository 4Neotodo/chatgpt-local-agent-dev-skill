from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path
import re
from typing import Any, Mapping

from .config import load_config
from .profiles import (
    COMPACT_DISALLOWED_PATHS,
    COMPACT_PROFILE_MARKER,
    COMPACT_SERIAL_PROFILE,
    DEFAULT_GOVERNANCE_PROFILE,
    FULL_COLLABORATION_PROFILE,
    FULL_TEMPLATE_MAP,
    GOVERNANCE_CONTRACT_VERSION,
    LEGACY_GOVERNANCE_CONTRACT_VERSION,
    LEGACY_V02_REQUIRED_CONFIG_KEYS,
    PERSISTED_KEYS_BY_PROFILE,
    PROFILE_TEMPLATE_MAPS,
    SUPPORTED_GOVERNANCE_CONTRACT_VERSIONS,
    ConfigurationError,
    normalize_profile,
)

PLACEHOLDER_RE = re.compile(r"{{([A-Z][A-Z0-9_]*)}}")
UNCONFIRMED_RE = re.compile(r"\[(?:待确认|TODO|TBD)(?::[^\]]*)?\]", re.IGNORECASE)


@dataclass(frozen=True)
class RepositoryCheck:
    profile: str
    contract_version: str | None
    missing: tuple[str, ...]
    unresolved_template_tokens: tuple[str, ...]
    unconfirmed_markers: tuple[str, ...]
    config_errors: tuple[str, ...]
    profile_errors: tuple[str, ...]
    strict: bool

    @property
    def passed(self) -> bool:
        base_failed = bool(
            self.missing
            or self.unresolved_template_tokens
            or self.config_errors
            or self.profile_errors
        )
        strict_failed = self.strict and bool(self.unconfirmed_markers)
        return not base_failed and not strict_failed

    def to_dict(self) -> dict[str, Any]:
        return {
            "passed": self.passed,
            "strict": self.strict,
            "profile": self.profile,
            "contract_version": self.contract_version,
            "missing": list(self.missing),
            "unresolved_template_tokens": list(self.unresolved_template_tokens),
            "unconfirmed_markers": list(self.unconfirmed_markers),
            "config_errors": list(self.config_errors),
            "profile_errors": list(self.profile_errors),
        }


def _infer_check_profile(
    raw_config: Mapping[str, Any] | None,
    requested_profile: str | None,
    *,
    config_errors: list[str],
    profile_errors: list[str],
) -> tuple[str, str | None]:
    normalized_requested: str | None = None
    if requested_profile is not None:
        try:
            normalized_requested = normalize_profile(requested_profile)
        except ConfigurationError as exc:
            profile_errors.append(str(exc))

    if raw_config is None:
        return normalized_requested or DEFAULT_GOVERNANCE_PROFILE, None

    declared_version_raw = raw_config.get("governance_contract_version")
    declared_version = str(declared_version_raw) if declared_version_raw is not None else None
    if declared_version not in SUPPORTED_GOVERNANCE_CONTRACT_VERSIONS:
        config_errors.append(
            ".project-governance/config.json: governance_contract_version must be one of "
            f"{SUPPORTED_GOVERNANCE_CONTRACT_VERSIONS!r}, got {declared_version!r}"
        )

    declared_profile_raw = raw_config.get("governance_profile")
    if declared_profile_raw is None:
        if declared_version == LEGACY_GOVERNANCE_CONTRACT_VERSION:
            inferred = FULL_COLLABORATION_PROFILE
        else:
            inferred = normalized_requested or DEFAULT_GOVERNANCE_PROFILE
            config_errors.append(
                ".project-governance/config.json: missing governance_profile for contract 0.3.0"
            )
    else:
        try:
            inferred = normalize_profile(declared_profile_raw)
        except ConfigurationError as exc:
            profile_errors.append(str(exc))
            inferred = normalized_requested or DEFAULT_GOVERNANCE_PROFILE

    if normalized_requested is not None and normalized_requested != inferred:
        profile_errors.append(
            f"Requested profile {normalized_requested!r} does not match configured profile {inferred!r}"
        )
    return inferred, declared_version


def check_repository(
    repo_root: Path,
    *,
    strict: bool = False,
    profile: str | None = None,
) -> RepositoryCheck:
    root = repo_root.expanduser().resolve()
    missing: list[str] = []
    unresolved: list[str] = []
    unconfirmed: list[str] = []
    config_errors: list[str] = []
    profile_errors: list[str] = []

    config_path = root / ".project-governance/config.json"
    raw_config: dict[str, Any] | None = None
    if config_path.is_file():
        try:
            data = json.loads(config_path.read_text(encoding="utf-8"))
            if not isinstance(data, dict):
                raise ConfigurationError("Config root must be a JSON object")
            raw_config = data
        except (ConfigurationError, json.JSONDecodeError) as exc:
            config_errors.append(f".project-governance/config.json: {exc}")

    effective_profile, contract_version = _infer_check_profile(
        raw_config,
        profile,
        config_errors=config_errors,
        profile_errors=profile_errors,
    )
    template_map = PROFILE_TEMPLATE_MAPS.get(effective_profile, FULL_TEMPLATE_MAP)

    file_texts: dict[str, str] = {}
    for relative_path in template_map:
        target = root / relative_path
        if not target.is_file():
            missing.append(relative_path)
            continue
        try:
            text = target.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            config_errors.append(f"{relative_path}: not valid UTF-8: {exc}")
            continue
        file_texts[relative_path] = text
        if PLACEHOLDER_RE.search(text):
            unresolved.append(relative_path)
        if UNCONFIRMED_RE.search(text):
            unconfirmed.append(relative_path)

    if raw_config is not None:
        try:
            loaded = load_config(config_path)
            loaded_profile = str(loaded["governance_profile"])
            if loaded_profile != effective_profile:
                profile_errors.append(
                    f"Validated profile {loaded_profile!r} does not match effective profile {effective_profile!r}"
                )
        except ConfigurationError as exc:
            config_errors.append(f".project-governance/config.json: {exc}")

        if contract_version == GOVERNANCE_CONTRACT_VERSION:
            for key in PERSISTED_KEYS_BY_PROFILE.get(effective_profile, []):
                if key not in raw_config:
                    config_errors.append(f".project-governance/config.json: missing {key}")
        elif contract_version == LEGACY_GOVERNANCE_CONTRACT_VERSION:
            if effective_profile != FULL_COLLABORATION_PROFILE:
                profile_errors.append("Contract 0.2.0 is valid only as full_collaboration")
            for key in sorted(LEGACY_V02_REQUIRED_CONFIG_KEYS):
                if key not in raw_config:
                    config_errors.append(f".project-governance/config.json: missing {key}")

    agents_text = file_texts.get("AGENTS.md", "")
    if effective_profile == COMPACT_SERIAL_PROFILE:
        if agents_text and COMPACT_PROFILE_MARKER not in agents_text:
            profile_errors.append(
                "AGENTS.md does not contain the compact_serial profile marker; "
                "profile migration requires reviewed replacement of shared governance files"
            )
        for relative_path in COMPACT_DISALLOWED_PATHS:
            if (root / relative_path).is_file():
                profile_errors.append(
                    f"compact_serial repository contains disallowed full-profile path: {relative_path}"
                )
    elif COMPACT_PROFILE_MARKER in agents_text:
        profile_errors.append(
            "AGENTS.md is still compact_serial while config declares full_collaboration; "
            "upgrade requires reviewed replacement of shared governance files"
        )

    return RepositoryCheck(
        profile=effective_profile,
        contract_version=contract_version,
        missing=tuple(missing),
        unresolved_template_tokens=tuple(unresolved),
        unconfirmed_markers=tuple(unconfirmed),
        config_errors=tuple(config_errors),
        profile_errors=tuple(profile_errors),
        strict=strict,
    )
