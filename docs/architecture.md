# Architecture

## Medallion Layers (What + Why)

### RAW (Bronze / Landing)
**What:** Raw/landing table in Snowflake: `RETAIL_PIPELINE_DB.RAW.SUPERSTORE_RAW`  
**Why:** Keeps a stable starting point to reprocess from, without re-downloading.

### CURATED (Silver / Cleaned)
**What:** Cleaned dataset produced by Spark in Databricks and loaded into Snowflake:  
`RETAIL_PIPELINE_DB.CURATED.SUPERSTORE_CURATED_SPARK_V2`  
**Why:** Enforces safer types and removes invalid rows so analytics is reliable.

### GOLD (Analytics)
**What:** Reporting-ready KPI table:  
`RETAIL_PIPELINE_DB.GOLD.MONTHLY_SALES_PROFIT_SPARK`  
**Why:** Pre-aggregated output for dashboards (fast + easy for business users).

---

## Pipeline Flow

1) **Snowflake Setup**
- Create warehouse + database + schemas (`RAW`, `CURATED`, `GOLD`)

2) **RAW Load**
- Upload `superstore_clean.csv` into `RAW.SUPERSTORE_RAW` via Snowflake UI

3) **Databricks Spark Transform (Silver)**
- Read CSV from Unity Catalog Volume  
- Safe-cast numeric columns using `try_cast` to avoid crashes  
- Filter invalid rows (e.g., malformed numeric fields)  
- Write output CSV with `quoteAll=true` so Snowflake parses commas/quotes safely

4) **CURATED Load**
- Upload Spark output CSV into Snowflake CURATED table (`SUPERSTORE_CURATED_SPARK_V2`)

5) **GOLD Build**
- Create monthly KPI table from CURATED:
  - total sales
  - total profit
  - profit margin

6) **Quality Checks**
- Compare row counts across layers and validate expected outputs

---

## Diagram (simple)

[Local CSV]
   |
   | (Upload)
   v
Snowflake RAW (SUPERSTORE_RAW)
   |
   | (Databricks reads CSV from Volume, transforms)
   v
Databricks Spark Silver (df_silver_clean)
   |
   | (Export quoted CSV + Upload)
   v
Snowflake CURATED (SUPERSTORE_CURATED_SPARK_V2)
   |
   | (SQL aggregation)
   v
Snowflake GOLD (MONTHLY_SALES_PROFIT_SPARK)