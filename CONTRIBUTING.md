# Contributing

## Local setup

Use Python 3.12 and uv, then install the locked dependencies:

```bash
uv sync --locked
uv run dbt parse --project-dir airbnb_dbt --profiles-dir .github/dbt --no-partial-parse
```

The CI profile contains offline placeholders. Use your ignored local profile and `.env` for warehouse execution; never commit account credentials or real source data.

## Branch workflow

```text
feature/* → development → staging → main
```

Create feature/fix branches from `development` and open focused pull requests back to it. Promote reviewed candidates through `staging` and then `main`. Synchronize any direct hotfix back into the other two branches. Branch protection, approvals, and warehouse environments are configured separately.

## SQL changes

- Keep the source columns, model grain, and materialization behavior explicit.
- Prefer dbt `ref()` and `source()` dependencies for new models.
- Review snapshot unique keys, update timestamps, and validity predicates when changing historical joins.
- Add meaningful data tests when introducing new data contracts.
- Execute changed SQL against the intended warehouse before claiming runtime/data validation; offline parsing is a separate check.
- Update the README and architecture notes when changing the current staged execution order or fixed database references.

See [architecture](docs/ARCHITECTURE.md) for known modeling boundaries and [operations](docs/OPERATIONS.md) for source prerequisites.
