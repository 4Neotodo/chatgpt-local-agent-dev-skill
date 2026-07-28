from __future__ import annotations

import argparse
from pathlib import Path
import sys

from .generator import (
    ConfigurationError,
    check_repository,
    format_results,
    generate,
    load_config,
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="project-governance-init",
        description="Generate a ChatGPT and local-Agent project governance baseline.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    init_parser = subparsers.add_parser("init", help="Generate missing governance files")
    init_parser.add_argument("--repo-root", required=True, type=Path)
    init_parser.add_argument("--config", type=Path)
    init_parser.add_argument("--project-name")
    init_parser.add_argument("--repository")
    init_parser.add_argument("--default-branch")
    init_parser.add_argument("--integration-branch")
    init_parser.add_argument("--primary-language")
    init_parser.add_argument("--test-command")
    init_parser.add_argument("--code-root")
    init_parser.add_argument("--project-purpose")
    init_parser.add_argument("--force", action="store_true", help="Explicitly overwrite existing generated paths")
    init_parser.add_argument("--dry-run", action="store_true", help="Show planned actions without writing")

    check_parser = subparsers.add_parser("check", help="Check required paths and unresolved template tokens")
    check_parser.add_argument("--repo-root", required=True, type=Path)
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        if args.command == "init":
            overrides = {
                "project_name": args.project_name,
                "repository": args.repository,
                "default_branch": args.default_branch,
                "integration_branch": args.integration_branch,
                "primary_language": args.primary_language,
                "test_command": args.test_command,
                "code_root": args.code_root,
                "project_purpose": args.project_purpose,
            }
            config = load_config(args.config, overrides)
            results = generate(args.repo_root, config, force=args.force, dry_run=args.dry_run)
            print(format_results(results))
            return 0

        missing, unresolved = check_repository(args.repo_root)
        if missing:
            print("Missing required governance paths:", file=sys.stderr)
            for path in missing:
                print(f"- {path}", file=sys.stderr)
        if unresolved:
            print("Files with unresolved template tokens:", file=sys.stderr)
            for path in unresolved:
                print(f"- {path}", file=sys.stderr)
        if missing or unresolved:
            return 1
        print("Governance baseline check passed")
        return 0
    except ConfigurationError as exc:
        parser.error(str(exc))
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
