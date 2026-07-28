# Minimal example

Use the sibling `project-governance.json` as a starting configuration:

```bash
project-governance-init init \
  --repo-root /path/to/example-project \
  --config examples/minimal/project-governance.json \
  --dry-run
```

The generated baseline intentionally contains visible `[待确认]` sections for project-specific planning decisions. The initializer does not invent product scope, architecture, release identity, or acceptance evidence.
