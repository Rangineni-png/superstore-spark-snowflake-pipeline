from pyspark.sql import functions as F

# Read input (uploaded to Volume)
path = "/Volumes/de_catalog/superstore/raw_files/superstore_clean.csv"

df = (spark.read
      .option("header", True)
      .option("inferSchema", True)
      .csv(path))

def safe_double(colname: str):
    return F.expr(f"try_cast({colname} as double)")

def safe_int(colname: str):
    return F.expr(f"try_cast({colname} as int)")

df_silver = (
    df
    .withColumn("row_id", safe_int("row_id"))
    .withColumn("order_date", F.to_date("order_date"))
    .withColumn("ship_date", F.to_date("ship_date"))
    .withColumn("sales", safe_double("sales"))
    .withColumn("profit", safe_double("profit"))
    .withColumn("discount", safe_double("discount"))
    .withColumn("quantity", safe_int("quantity"))
)

# Filter “clean” rows for curated output
df_silver_clean = df_silver.filter(
    F.col("row_id").isNotNull() &
    F.col("order_date").isNotNull() &
    F.col("sales").isNotNull() &
    F.col("quantity").isNotNull() &
    F.col("discount").isNotNull()
)

# Write quoted CSV (so Snowflake upload doesn’t break on commas/quotes)
out_path = "/Volumes/de_catalog/superstore/raw_files/superstore_curated_spark_out_q"

(df_silver_clean
 .coalesce(1)
 .write
 .mode("overwrite")
 .option("header", True)
 .option("quoteAll", True)
 .option("escape", "\"")
 .csv(out_path)
)