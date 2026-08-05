# Compact Serial Example

This configuration selects `compact_serial` for a project expected to finish in one to three working days with one repository, one active writer, no planned parallelism, no competitive candidate, and no multi-result integration.

The initializer creates seven governance paths and intentionally does not replace or create the target repository `README.md`.

```bash
project-governance-init init \
  --profile compact_serial \
  --repo-root /path/to/project \
  --config examples/compact/project-governance.json \
  --dry-run
```

If the project needs a second writer, formal worktree/Lane, independent audit, parallel implementation, multiple-result integration, or complex L3 lifecycle work, stop and upgrade to `full_collaboration` through planning review.
