--Segregating raw data import from analysis for data integrity--
CREATE TABLE retail.sales_data_clean AS
SELECT
    date::DATE AS date,
    store_id::TEXT AS store_id,
    product_id::TEXT AS product_id,
    category::TEXT AS category,
    region::TEXT AS region,
    inventory_level::INTEGER AS inventory_level,
    units_sold::INTEGER AS units_sold,
    units_ordered::INTEGER AS units_ordered,
    price::NUMERIC AS price,
    discount::INTEGER AS discount,
    weather_condition::TEXT AS weather_condition,
    promotion::BOOLEAN AS promotion,
    competitor_pricing::NUMERIC AS competitor_pricing,
    seasonality::TEXT AS seasonality,
    epidemic::BOOLEAN AS epidemic,
    demand::INTEGER AS demand
FROM retail.sales_data_raw;


--verifying distinct values across categorical columns--
SELECT DISTINCT category
FROM retail.sales_data_clean
ORDER BY category;

SELECT DISTINCT region
FROM retail.sales_data_clean
ORDER BY region;

SELECT DISTINCT weather_condition
FROM retail.sales_data_clean
ORDER BY weather_condition;

SELECT DISTINCT seasonality
FROM retail.sales_data_clean
ORDER BY seasonality;


--Validation of categorical data being consistent across dataset--
SELECT
    store_id,
    COUNT(DISTINCT region) AS region_count
FROM retail.sales_data_clean
GROUP BY store_id
HAVING COUNT(DISTINCT region) > 1;

SELECT
    product_id,
    COUNT(DISTINCT category) AS category_count
FROM retail.sales_data_clean
GROUP BY product_id
HAVING COUNT(DISTINCT category) > 1;

SELECT
    date,
    COUNT(DISTINCT seasonality) AS season_count
FROM retail.sales_data_clean
GROUP BY date
HAVING COUNT(DISTINCT seasonality) > 1;

--Category count returns multiple counts, query below verifies product_id is consistent within store_ids--
-- No returned rows indicate that product identity is consistent within each store_id + product_id combination--
SELECT
    store_id,
    product_id,
    COUNT(DISTINCT category) AS category_count
FROM retail.sales_data_clean
GROUP BY store_id, product_id
HAVING COUNT(DISTINCT category) > 1;

--Verifying notable price differences which would confirm each product_id is almost certainly a different item--
SELECT
    store_id,
    product_id,
    COUNT(*) AS row_count,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price,
	STDDEV_SAMP(price) AS stdev_price,
    AVG(discount) AS avg_discount
FROM retail.sales_data_clean
GROUP BY store_id, product_id
ORDER BY product_id, store_id;
	
--Final validations, checking for any null/negative rows, duplicates, and business related checks--
SELECT COUNT(*) AS bad_row_count
FROM retail.sales_data_clean
WHERE
    date IS NULL
    OR store_id IS NULL
    OR product_id IS NULL
    OR category IS NULL
    OR region IS NULL
    OR inventory_level IS NULL
    OR units_sold IS NULL
    OR units_ordered IS NULL
    OR price IS NULL
    OR discount IS NULL
    OR weather_condition IS NULL
    OR promotion IS NULL
    OR competitor_pricing IS NULL
    OR seasonality IS NULL
    OR epidemic IS NULL
    OR demand IS NULL
    OR inventory_level < 0
    OR units_sold < 0
    OR units_ordered < 0
    OR price < 0
    OR discount < 0
    OR competitor_pricing < 0
    OR demand < 0;
	
SELECT
    date,
    store_id,
    product_id,
    COUNT(*) AS row_count
FROM retail.sales_data_clean
GROUP BY date, store_id, product_id
HAVING COUNT(*) > 1;
	
SELECT *
FROM retail.sales_data_clean
WHERE
    discount > 100
    OR (inventory_level = 0 AND units_sold > 0);
