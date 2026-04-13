-- 03_curated_tables.sql
-- CURATED table built from RAW (typed columns)

USE DATABASE RETAIL_PIPELINE_DB;
USE SCHEMA CURATED;

CREATE OR REPLACE TABLE SUPERSTORE_CURATED AS
SELECT
  ROW_ID::NUMBER                         AS ROW_ID,
  ORDER_ID::STRING                       AS ORDER_ID,
  TO_DATE(ORDER_DATE)                    AS ORDER_DATE,
  TO_DATE(SHIP_DATE)                     AS SHIP_DATE,
  SHIP_MODE::STRING                      AS SHIP_MODE,
  CUSTOMER_ID::STRING                    AS CUSTOMER_ID,
  CUSTOMER_NAME::STRING                  AS CUSTOMER_NAME,
  SEGMENT::STRING                        AS SEGMENT,
  COUNTRY::STRING                        AS COUNTRY,
  CITY::STRING                           AS CITY,
  STATE::STRING                          AS STATE,
  POSTAL_CODE::STRING                    AS POSTAL_CODE,
  REGION::STRING                         AS REGION,
  PRODUCT_ID::STRING                     AS PRODUCT_ID,
  CATEGORY::STRING                       AS CATEGORY,
  SUB_CATEGORY::STRING                   AS SUB_CATEGORY,
  PRODUCT_NAME::STRING                   AS PRODUCT_NAME,
  SALES::NUMBER(12,2)                    AS SALES,
  QUANTITY::NUMBER                       AS QUANTITY,
  DISCOUNT::NUMBER(6,4)                  AS DISCOUNT,
  PROFIT::NUMBER(12,2)                   AS PROFIT
FROM RETAIL_PIPELINE_DB.RAW.SUPERSTORE_RAW;