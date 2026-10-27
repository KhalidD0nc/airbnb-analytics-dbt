# Airbnb dbt models

The internal project/profile name is `airbnb_dbt`. Run dbt commands from the repository root using the `--project-dir airbnb_dbt` flag.

- **Bronze:** source bookings, hosts, and listings; currently materialized as tables through the model-level YAML configuration.
- **Silver:** incremental entity transformations with unique keys.
- **Gold:** the wide `obt` table, a `fact` table, and ephemeral entity projections.
- **Snapshots:** timestamp-based booking, host, and listing history.

Copy `profiles.yml.example` to your ignored `profiles.yml`, then configure environment values using the root `.env.example`. For an offline check:

```bash
uv run dbt parse --project-dir airbnb_dbt --profiles-dir .github/dbt --no-partial-parse
```

Some gold inputs are hardcoded warehouse names rather than declared dbt dependencies. Use the [staged execution order](../README.md#4-run-in-dependency-order) for a fresh environment. See [architecture](../docs/ARCHITECTURE.md) for current materialization/history behavior and [operations](../docs/OPERATIONS.md) for required source columns.
