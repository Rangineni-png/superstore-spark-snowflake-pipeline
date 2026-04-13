# Results / Proof

This folder contains screenshots proving the pipeline ran successfully.

## Screenshots to include
1) `databricks_silver_clean_rows.png`
- Shows Databricks output:
  - `silver_clean_rows: 9694`

2) `snowflake_curated_count.png`
- Shows:
  - `SELECT COUNT(*) FROM RETAIL_PIPELINE_DB.CURATED.SUPERSTORE_CURATED_SPARK_V2;`
  - Result: `9694`

3) `snowflake_gold_preview.png`
- Shows:
  - `SELECT COUNT(*) FROM RETAIL_PIPELINE_DB.GOLD.MONTHLY_SALES_PROFIT_SPARK;` → `48`
  - `SELECT * ... LIMIT 10;` (sample output)

4) (Optional) `snowflake_quality_checks.png`
- Shows:
  - RAW rows, CURATED rows, GOLD rows in one query

These screenshots act as execution evidence since Snowflake/Databricks environments are private.