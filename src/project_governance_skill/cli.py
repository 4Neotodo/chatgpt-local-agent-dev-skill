from __future__ import annotations

import argparse
import json
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
        description="Generate and check a ChatGPT and local-Agent project governance baseline.",
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
    init_parser.add_argument("--current-status")
    init_parser.add_argument("--next-task")
    init_parser.add_argument("--formal-worktree-root")
    init_parser.add_argument("--auto-worktree-root")
    init_parser.add_argument("--evidence-root")
    init_parser.add_argument("--local-config-root")
    init_parser.add_argument("--maximum-active-write-lanes", type=int)
    init_parser.add_argument("--maximum-read-only-audit-lanes", type=int)
    init_parser.add_argument("--same-blocker-attempt-budget", type=int)
    init_parser.add_argument("--total-failed-recovery-budget", type=int)
    init_parser.add_argument("--no-progress-checkpoint-budget", type=int)
    init_parser.add_argument(
        "--force",
        action="store_true",
        help="Explicitly overwrite existing generated paths",
    )
    init_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show planned actions without writing",
    )
    init_parser.add_argument(
        "--json",
        action="store_true",
        dest="json_output",
        help="Emit machine-readable results",
    )

    check_parser = subparsers.add_parser(
        "check",
        help="Check required paths, contract version, and unresolved markers",
    )
    check_parser.add_argument("--repo-root", required=True, type=Path)
    check_parser.add_argument(
        "--strict",
        action="store_true",
        help="Also fail on explicit [待确认], [TODO], or [TBD] markers",
    )
    check_parser.add_argument(
        "--json",
        action="store_true",
        dest="json_output",
        help="Emit machine-readable results",
    )
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
                "current_status": args.current_status,
                "next_task": args.next_task,
                "formal_worktree_root": args.formal_worktree_root,
                "auto_worktree_root": args.auto_worktree_root,
                "evidence_root": args.evidence_root,
                "local_config_root": args.local_config_root,
                "maximum_active_write_lanes": args.maximum_active_write_lanes,
                "maximum_read_only_audit_lanes": args.maximum_read_only_audit_lanes,
                "same_blocker_attempt_budget": args.same_blocker_attempt_budget,
                "total_failed_recovery_budget": args.total_failed_recovery_budget,
                "no_progress_checkpoint_budget": args.no_progress_checkpoint_budget,
            }
            config = load_config(args.config, overrides)
            results = generate(
                args.repo_root,
                config,
                force=args.force,
                dry_run=args.dry_run,
            )
            if args.json_output:
                print(
                    json.dumps(
                        {
                            "dry_run": args.dry_run,
                            "force": args.force,
                            "results": [item.__dict__ for item in results],
                        },
                        ensure_ascii=False,
                        indent=2,
                    )
                )
            else:
                print(format_results(results))
            return 0

        report = check_repository(args.repo_root, strict=args.strict)
        if args.json_output:
            print(json.dumps(report.to_dict(), ensure_ascii=False, indent=2))
        else:
            _print_check_report(report)
        return 0 if report.passed else 1
    except ConfigurationError as exc:
        print(f"Configuration error: {exc}", file=sys.stderr)
        return 2


def _print_check_report(report: object) -> None:
    # Kept separate so CLI output remains stable and easy for local Agents to parse.
    missing = getattr(report, "missing")
    unresolved = getattr(report, "unresolved_template_tokens")
    unconfirmed = getattr(report, "unconfirmed_markers")
    config_errors = getattr(report, "config_errors")
    strict = getattr(report, "strict")
    passed = getattr(report, "passed")

    if missing:
        print("Missing required governance paths:", file=sys.stderr)
        for path in missing:
            print(f"- {path}", file=sys.stderr)
    if unresolved:
        print("Files with unresolved {{TEMPLATE_TOKEN}} values:", file=sys.stderr)
        for path in unresolved:
            print(f"- {path}", file=sys.stderr)
    if config_errors:
        print("Configuration errors:", file=sys.stderr)
        for error in config_errors:
            print(f"- {error}", file=sys.stderr)
    if strict and unconfirmed:
        print("Files with explicit unconfirmed markers:", file=sys.stderr)
        for path in unconfirmed:
            print(f"- {path}", file=sys.stderr)

    if passed:
        if unconfirmed and not strict:
            print(
                "Governance baseline check passed; "
                f"{len(unconfirmed)} file(s) still contain explicit unconfirmed markers. "
                "Use --strict before declaring initialization complete."
            )
        else:
            print("Governance baseline check passed")


if __name__ == "__main__":
    raise SystemExit(main())
