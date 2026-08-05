# Minimal configuration example

This configuration generates a single-writer baseline with one optional read-only audit Lane. Replace repository, branch, worktree, validation, purpose, and next-task values with verified project facts before declaring initialization complete.

```bash
project-governance-init init \
  --repo-root /path/to/project \
  --config examples/minimal/project-governance.json \
  --dry-run
```

After generation, run normal and strict checks. Do not use `--force` against existing authoritative files without an approved migration scope.
