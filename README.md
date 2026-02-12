# Airbnb dbt Snowflake Project

## Overview

This project uses **dbt (data build tool)** to transform and analyze Airbnb data stored in **Snowflake**. It follows a multi-layered architecture (Bronze, Silver, Gold) to process raw data into consumption-ready models.

The project handles data for:
- **Listings**
- **Bookings**
- **Hosts**

## Project Structure

The project is organized as follows:

- **`models/`**: Contains all dbt models.
  - **`bronze/`**: Raw data ingestion with incremental load logic.
  - **`silver/`**: Cleaned and standardized data tables.
  - **`gold/`**: Business-level models, including One Big Table (OBT) and Fact tables.
    - **`ephemeral/`**: Intermediate ephemeral models.
- **`snapshots/`**: SCD Type 2 snapshots for tracking historical changes in listings, hosts, and bookings.
- **`macros/`**: Custom macros for reusable logic (e.g., tagging, math operations, string trimming).
- **`seeds/`**: (Optional) CSV files for static data loading.
- **`tests/`**: Data integrity tests.
- **`analyses/`**: Ad-hoc analytical queries.

## Data Architecture

### 1. Bronze Layer (Raw)
- Ingests raw data from the `AIRBNB.staging` source schema.
- Models: `bronze_listings`, `bronze_bookings`, `bronze_hosts`.
- Materialization: `incremental` (filters for new records based on `created_at`).

### 2. Silver Layer (Cleaned)
- Cleans and transforms bronze data.
- Applies standardization (e.g., trimming, value tagging).
- Models: `silver_listing`, `silver_bookings`, `silver_host`.
- Materialization: `table`.

### 3. Gold Layer (Consumption)
- **OBT (One Big Table)**: Joins silver tables to create a wide, denormalized table for easy reporting (`models/gold/obt.sql`).
- **Fact Tables**: creates final fact tables for analytics (`models/gold/fact.sql`).
- **Snapshots**: Type 2 Slowly Changing Dimensions (SCD) verify history for `listings`, `hosts`, and `bookings`.

## Prerequisites

- **Python 3.8+**
- **dbt-snowflake**: `pip install dbt-snowflake`
- **Snowflake Account**: With appropriate permissions to create databases, schemas, and tables.

## Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd aws_dbt_snowflake
   ```

2. **Install dbt dependencies:**
   ```bash
   dbt deps
   ```

3. **Configure your `profiles.yml`:**
   Ensure your `~/.dbt/profiles.yml` (or local `profiles.yml`) is configured for the `aws_dbt_snowflake` profile.

   Example:
   ```yaml
   aws_dbt_snowflake:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: <your_account>
         user: <your_user>
         password: <your_password>
         role: <your_role>
         database: AIRBNB
         warehouse: <your_warehouse>
         schema: dbt_dev
         threads: 4
   ```

4. **Verify connection:**
   ```bash
   dbt debug
   ```

## Running the Project

### Run all models
```bash
dbt run
```

### Run specific layers
```bash
dbt run --select bronze
dbt run --select silver
dbt run --select gold
```

### Run Snapshots
To capture historical data changes:
```bash
dbt snapshot
```

### Generate Documentation
To generate and view the project's documentation website:
```bash
dbt docs generate
dbt docs serve
```

## Macros

The project includes custom macros in `macros/`:
- **`generate_schema_name`**: Customizes schema naming conventions.
- **`multiply`**: Utility for multiplication operations.
- **`tag`**: specific tagging logic.
- **`trimmer`**: String trimming utility.

## Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [dbt Snowflake Adapter](https://docs.getdbt.com/reference/warehouse-setups/snowflake-setup)
