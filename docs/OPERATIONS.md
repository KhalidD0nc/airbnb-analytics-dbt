# Operations

## Tooling

Install Python 3.12 and uv, then run `uv sync --locked` from the repository root. Use the dbt CLI through `uv run`; the root `main.py` is a starter script, not a pipeline runner.

The internal dbt project and profile are both named `airbnb_dbt`. The repository and Python tooling package use `airbnb-analytics-dbt`.

## Connection setup

Copy `.env.example` to `.env` and `airbnb_dbt/profiles.yml.example` to `airbnb_dbt/profiles.yml`. Both local files are ignored. The profile reads process environment variables rather than embedding credentials.

| Variable | Purpose |
| --- | --- |
| `SNOWFLAKE_ACCOUNT` | Snowflake account identifier |
| `SNOWFLAKE_USER` | User for the configured account |
| `SNOWFLAKE_PASSWORD` | Password used by this example profile |
| `SNOWFLAKE_ROLE` | Role with the required source-read and target-write permissions |
| `SNOWFLAKE_WAREHOUSE` | Compute warehouse |
| `SNOWFLAKE_DATABASE` | Profile database, defaulting to `AIRBNB` |
| `SNOWFLAKE_SCHEMA` | Profile's default schema, defaulting to `DBT_WORK` |

Run `uv run --env-file .env dbt debug --project-dir airbnb_dbt --profiles-dir airbnb_dbt` to check a real connection. That command contacts Snowflake. Configure authentication according to your account's policy if password authentication is not available.

## Source tables

Source ingestion and source-table DDL are outside this repository. The current transformations expect these fields:

| Relation | Required fields used by the models |
| --- | --- |
| `AIRBNB.STAGING.BOOKINGS` | `BOOKING_ID`, `LISTING_ID`, `BOOKING_DATE`, `NIGHTS_BOOKED`, `BOOKING_AMOUNT`, `CLEANING_FEE`, `SERVICE_FEE`, `BOOKING_STATUS`, `CREATED_AT` |
| `AIRBNB.STAGING.LISTINGS` | `LISTING_ID`, `HOST_ID`, `ROOM_TYPE`, `PROPERTY_TYPE`, `CITY`, `COUNTRY`, `BEDROOMS`, `BATHROOMS`, `ACCOMMODATES`, `PRICE_PER_NIGHT`, `CREATED_AT` |
| `AIRBNB.STAGING.HOSTS` | `HOST_ID`, `HOST_NAME`, `HOST_SINCE`, `IS_SUPERHOST`, `RESPONSE_RATE`, `CREATED_AT` |

Use compatible numeric/date types for the arithmetic and timestamp operations in the SQL. No seed rows, source loader, or dataset files are bundled.

## Fresh warehouse execution order

1. Load the three staging tables.
2. Run bronze and silver: `dbt run --select bronze silver`.
3. Build the wide table: `dbt run --select obt`.
4. Populate the snapshot dimensions: `dbt snapshot`.
5. Build the fact output: `dbt run --select fact`.

For each dbt command above, use the prefix `uv run --env-file .env` and append `--project-dir airbnb_dbt --profiles-dir airbnb_dbt` when invoking it from the repository root. The root README contains complete copyable commands.

The staged order compensates for gold queries that do not use `ref()` for their warehouse dependencies. Parsing alone cannot enforce this order.

## Documentation and exploration

```bash
uv run --env-file .env dbt docs generate --project-dir airbnb_dbt --profiles-dir airbnb_dbt
uv run --env-file .env dbt docs serve --project-dir airbnb_dbt --profiles-dir airbnb_dbt
```

Generating the catalog connects to the configured warehouse. The `analyses/` folder contains ad hoc exploration SQL; review its fixed relation names before execution.

## Local artifacts and credentials

Keep `.env`, real `profiles.yml`, `logs/`, dbt `target/`, and private key files out of version control. Removing a previously committed credential from the current tree does not remove it from historical commits; rotate it in Snowflake if it is still valid. Do not reuse previously published credentials in a new clone.
