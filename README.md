# Superstore Spark → Snowflake Data Pipeline (Medallion)

End-to-end batch data pipeline using **Databricks (Spark/PySpark)** for transformations and **Snowflake** for warehouse storage and analytics.  
Implements a simple **Medallion Architecture**: **RAW → CURATED → GOLD**.

## Tech Stack
- Databricks Free Edition (Spark / PySpark)
- Snowflake (Snowsight)
- SQL
- Git/GitHub

---

## Architecture (high level)
1) **RAW (Snowflake)**  
   - Load `superstore_clean.csv` into `RETAIL_PIPELINE_DB.RAW.SUPERSTORE_RAW`

2) **CURATED (Databricks Spark → Snowflake)**  
   - Databricks reads the CSV from a Unity Catalog Volume  
   - Applies safe casting + filters invalid rows  
   - Exports a Snowflake-safe quoted CSV  
   - Upload that output into `RETAIL_PIPELINE_DB.CURATED.SUPERSTORE_CURATED_SPARK_V2`

3) **GOLD (Snowflake)**  
   - Build reporting-ready KPI table: `RETAIL_PIPELINE_DB.GOLD.MONTHLY_SALES_PROFIT_SPARK`

---

## Repo Structure
- `snowflake/`
  - `01_setup.sql` – creates warehouse + database + schemas
  - `02_raw_tables.sql` – RAW landing table DDL
  - `03_curated_tables.sql` – CURATED table from RAW (SQL-based)
  - `04_gold_kpis.sql` – GOLD KPI table from Spark-curated output
  - `05_quality_checks.sql` – row-count checks across layers
- `spark/jobs/`
  - `silver_transform.py` – Spark “Silver” job: safe casts, filters, writes quoted CSV for Snowflake upload
- `docs/architecture.md` – pipeline diagram + explanations
- `results/` – screenshots of successful runs (proof)

---

## How to Run (Repro Steps)

### A) Snowflake setup
1) Open Snowsight Worksheet
2) Run:
- `snowflake/01_setup.sql`
- `snowflake/02_raw_tables.sql`

### B) Load RAW data (Snowflake UI)
1) Snowflake Home → **Upload local files**
2) Select file: `superstore_clean.csv`
3) Load into:
- Database: `RETAIL_PIPELINE_DB`
- Schema: `RAW`
- Table: `SUPERSTORE_RAW` (existing)

### C) Databricks transform (Silver → export)
1) Upload `superstore_clean.csv` into a Volume (Unity Catalog):
- `/Volumes/de_catalog/superstore/raw_files/superstore_clean.csv`
2) Run the Spark job:
- `spark/jobs/silver_transform.py`
3) Download the output CSV from the Databricks Volume folder:
- `/Volumes/de_catalog/superstore/raw_files/superstore_curated_spark_out_q/part-*.csv`
4) Rename downloaded file to: `superstore_curated_spark.csv`

### D) Load CURATED Spark output into Snowflake (UI)
1) Snowflake Home → **Upload local files**
2) Select: `superstore_curated_spark.csv`
3) Load into:
- Database: `RETAIL_PIPELINE_DB`
- Schema: `CURATED`
- Table: `SUPERSTORE_CURATED_SPARK_V2` (existing)

### E) Build GOLD KPIs
Run:
- `snowflake/04_gold_kpis.sql`

### F) Run quality checks
Run:
- `snowflake/05_quality_checks.sql`

---

## Expected Results (so you know it worked)
- `RAW.SUPERSTORE_RAW` row count: **~9994** (depending on the exact input file)
- `CURATED.SUPERSTORE_CURATED_SPARK_V2` row count: **9694** (after filtering invalid rows in Spark)
- `GOLD.MONTHLY_SALES_PROFIT_SPARK` row count: **48** (monthly aggregated KPI rows)

---

## Proof / Evidence
See `results/` for screenshots showing:
- Databricks `silver_clean_rows: 9694`
- Snowflake `COUNT(*)` on CURATED = 9694
- Snowflake GOLD KPI table output (48 months)

---

## Notes
- Databricks Free Edition restrictions prevent direct Spark→Snowflake connector writes, so the pipeline uses an export-to-CSV + Snowflake UI upload for the CURATED handoff.
- The focus here is pipeline structure, transformations, and analytics-ready outputs.