# Analytics architecture

## Layers and materialization

The model sources are `AIRBNB.STAGING.LISTINGS`, `BOOKINGS`, and `HOSTS`. A separate, unused `stripe.payments` source declaration is also present.

The project-level bronze configuration says `incremental`, but the three model definitions in `models/properties.yml` override it to `table`. Their `is_incremental()` branches are therefore not active with the current configuration.

Silver models explicitly select incremental materialization and an entity unique key. They currently read their full upstream bronze relations rather than filtering new rows with `is_incremental()`.

Gold contains the `obt` wide table, the `fact` output, and three ephemeral projections used by snapshots. Ephemeral models are rendered as CTEs rather than separate physical tables.

## Dependency boundaries

| Node | Upstream inputs |
| --- | --- |
| `bronze_bookings`, `bronze_listings`, `bronze_hosts` | Declared staging sources |
| `silver_bookings`, `silver_listing`, `silver_host` | Bronze models through `ref()` |
| `obt` | Fully qualified `AIRBNB.SILVER.*` relations |
| `bookings`, `listings`, `hosts` | `ref('obt')` |
| `dim_bookings`, `dim_listings`, `dim_hosts` | Ephemeral projections through `ref()` |
| `fact` | Fully qualified `AIRBNB.GOLD.OBT`, `DIM_LISTINGS`, and `DIM_HOSTS` |

The hardcoded gold inputs are not dbt dependency edges. The [operations guide](OPERATIONS.md) documents a staged order for a fresh warehouse.

## Current modeling boundaries

- `silver_bookings` computes total amount from nights, booking amount, and fees. Confirm the source meaning of `BOOKING_AMOUNT` before treating the result as revenue.
- The host-quality CASE checks `RESPONSE_RATE > 60` before the `> 80` and `> 90` conditions. With the current SQL, values above 60 receive `FAIR`; the later `GOOD` and `VERY_GOOD` branches are unreachable.
- Snapshot change detection uses `CREATED_AT`, `HOST_CREATED_AT`, or `LISTING_CREATED_AT`. Changes that leave those timestamps unchanged may not produce a new version.
- Snapshot queries are derived from booking-enriched `obt` projections. Validate unique-key grain when an entity appears in multiple bookings.
- `fact` joins snapshot dimensions by entity ID without a temporal-validity predicate. Multiple stored versions can multiply output rows. Validate grain before downstream reporting.

These notes describe the existing SQL. This repository presentation refresh does not change those business rules.

## Schema and environment selection

The schema macro uses explicit model schemas as written, without prefixing the target schema. Source declarations, gold relations, and snapshot database settings refer to `AIRBNB` directly. A different profile database or Git branch alone does not isolate all reads/writes.

Use an independently configured Snowflake account for a separate live environment, or parameterize the fixed references and validate the resulting graph before sharing an account across environments.

## Validation scope

Offline CI parses the project using non-working placeholder credentials. This checks the dbt configuration, Jinja rendering needed for parsing, and declared dependency references. It does not connect to Snowflake, execute models/snapshots, check row counts, or run data-quality assertions. There are currently no checked-in dbt data tests.
