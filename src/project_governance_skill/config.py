from __future__ import annotations

from datetime import date
import json
from pathlib import Path
import re
from typing import Any, Mapping

from .profiles import (
    COMPACT_SERIAL_PROFILE,
    COMPACT_UNSUPPORTED_EXPLICIT_KEYS,
    COMMON_DEFAULTS,
    DEFAULT_GOVERNANCE_PROFILE,
    GOVERNANCE_CONTRACT_VERSION,
    INTEGER_RULES,
    PROFILE_DEFAULTS,
    PROFILE_INTEGER_KEYS,
    REQUIRED_KEYS,
    ConfigurationError,
    normalize_profile,
)


def read_raw_config(path: Path | None) -> dict[str, Any]:
    if path is None:
        return {}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise ConfigurationError(f"Config file not found: {path}") from exc
    except json.JSONDecodeError as exc:
        raise ConfigurationError(f"Invalid JSON config: {path}: {exc}") from exc
    if not isinstance(data, dict):
        raise ConfigurationError("Config root must be a JSON object")
    return data


def load_config(
    path: Path | None,
    overrides: Mapping[str, str | int | bool | None] | None = None,
) -> dict[str, str | int | bool]:
    raw = read_raw_config(path)
    if overrides:
        raw.update({key: value for key, value in overrides.items() if value is not None})

    missing = [key for key in sorted(REQUIRED_KEYS) if not str(raw.get(key, "")).strip()]
    if missing:
        raise ConfigurationError(f"Missing required config keys: {', '.join(missing)}")

    profile = normalize_profile(raw.get("governance_profile", DEFAULT_GOVERNANCE_PROFILE))
    config: dict[str, str | int | bool] = {
        **COMMON_DEFAULTS,
        **PROFILE_DEFAULTS[profile],
        "governance_profile": profile,
    }

    for key, value in raw.items():
        if value is None or key == "governance_contract_version":
            continue
        if not isinstance(value, (str, int, float, bool)):
            raise ConfigurationError(f"Config value for {key!r} must be scalar")
        config[key] = value

    for key in PROFILE_INTEGER_KEYS[profile]:
        minimum, maximum = INTEGER_RULES[key]
        config[key] = _coerce_int(
            key,
            config.get(key),
            minimum=minimum,
            maximum=maximum,
        )

    if profile == COMPACT_SERIAL_PROFILE:
        explicitly_unsupported = sorted(COMPACT_UNSUPPORTED_EXPLICIT_KEYS.intersection(raw))
        if explicitly_unsupported:
            raise ConfigurationError(
                "compact_serial does not support full-profile stop-budget keys: "
                + ", ".join(explicitly_unsupported)
            )
        _validate_compact_constraints(config)

    config["created_date"] = str(raw.get("created_date") or date.today().isoformat())
    config["project_name"] = str(config["project_name"]).strip()
    config["project_slug"] = _slugify(str(config["project_name"]))
    config["governance_profile"] = profile
    config["governance_contract_version"] = GOVERNANCE_CONTRACT_VERSION
    return config


def _validate_compact_constraints(config: Mapping[str, str | int | bool]) -> None:
    expected_values: dict[str, str | int] = {
        "integration_branch": "not_applicable",
        "formal_worktree_root": "not_applicable",
        "auto_worktree_root": "not_applicable",
        "maximum_active_write_lanes": 1,
        "maximum_read_only_audit_lanes": 0,
    }
    errors = [
        f"{key} must be {expected!r}, got {config.get(key)!r}"
        for key, expected in expected_values.items()
        if config.get(key) != expected
    ]
    if errors:
        raise ConfigurationError("compact_serial constraints violated: " + "; ".join(errors))


def _coerce_int(key: str, value: Any, *, minimum: int, maximum: int | None) -> int:
    if isinstance(value, bool):
        raise ConfigurationError(f"Config value for {key!r} must be an integer, not boolean")
    if isinstance(value, int):
        result = value
    elif isinstance(value, float) and value.is_integer():
        result = int(value)
    elif isinstance(value, str) and re.fullmatch(r"[+-]?\d+", value.strip()):
        result = int(value.strip())
    else:
        raise ConfigurationError(f"Config value for {key!r} must be an integer")

    if result < minimum:
        raise ConfigurationError(f"Config value for {key!r} must be >= {minimum}")
    if maximum is not None and result > maximum:
        raise ConfigurationError(f"Config value for {key!r} must be <= {maximum}")
    return result


def _slugify(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9._-]+", "-", value.strip()).strip("-").lower()
    return slug or "project"
