SELECT
    date,
    epidemic,
    ROUND(SUM(units_sold * price),2) AS total_gross_sales
FROM retail.sales_data_clean
GROUP BY date, epidemic
ORDER BY date, epidemic;

--Overall sales summary by promotion status--
SELECT
    promotion,
    ROUND(SUM(units_sold * price), 2) AS total_gross_sales,
    ROUND(AVG(units_sold * price), 2) AS avg_gross_sales,
	ROUND(AVG(units_sold), 2) AS avg_units_sold,
	ROUND(AVG(discount), 2) AS avg_discount
FROM retail.sales_data_clean
GROUP BY promotion
ORDER BY promotion;

--Full-dataset category and promotion summary--
SELECT
    category,
	promotion,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    ROUND(AVG(units_sold * price), 2) AS avg_gross_sales,
    ROUND(AVG(discount), 2) AS avg_discount_pct,
    COUNT(*) AS row_count
FROM retail.sales_data_clean
GROUP BY category,promotion
ORDER BY category,promotion;


-- Promotion and Discount Analysis --

--Store-level sales summary by promotion status--
SELECT
    store_id,
	promotion,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    ROUND(AVG(units_sold * price), 2) AS avg_gross_sales,
    ROUND(AVG(discount), 2) AS avg_discount_pct,
    COUNT(*) AS row_count
FROM retail.sales_data_clean
WHERE epidemic = false
GROUP BY store_id,promotion
ORDER BY store_id,promotion;


--Non epidemic sales by discount rate, promotion status--
WITH discount_analysis AS (
    SELECT
        promotion,
        discount,
        units_sold * price AS gross_sales,
        units_sold
    FROM retail.sales_data_clean
	WHERE epidemic = false
)
SELECT
    promotion,
    discount,
    ROUND(AVG(gross_sales), 2) AS avg_gross_sales,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    COUNT(*) AS row_count
FROM discount_analysis
GROUP BY promotion, discount
ORDER BY promotion, discount;


SELECT
    category,
    promotion,
    ROUND(AVG(discount), 2) AS avg_discount_pct,
    ROUND(AVG(units_sold * price))  AS avg_gross_sales,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    COUNT(*) AS row_count
FROM retail.sales_data_clean
GROUP BY category, promotion
ORDER BY category, promotion;

SELECT
    category,
    discount,
	promotion,
    ROUND(AVG(units_sold * price)) AS avg_gross_sales,
	ROUND(SUM(units_sold * price)) AS total_gross_sales,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    COUNT(*) AS row_count
FROM retail.sales_data_clean
WHERE epidemic = false
GROUP BY category, discount,promotion
ORDER BY category, discount,promotion;


-- Scenario Analysis: estimate revenue when converting 25% discount sales to 10% -- 
WITH base_sales AS (
    SELECT
        discount,
        promotion,
        units_sold * price AS gross_sales
    FROM retail.sales_data_clean
    WHERE epidemic = false
),
promo_discount_summary AS (
    SELECT
        discount,
        AVG(gross_sales) AS avg_gross_sales,
        COUNT(*) AS row_count
    FROM base_sales
    WHERE promotion = true
      AND discount IN (10, 25)
    GROUP BY discount
),
pivoted AS (
    SELECT
        MAX(CASE WHEN discount = 10 THEN avg_gross_sales END) AS avg_rev_10_promo,
        MAX(CASE WHEN discount = 25 THEN avg_gross_sales END) AS avg_rev_25_promo,
        MAX(CASE WHEN discount = 25 THEN row_count END) AS row_count_25_promo
    FROM promo_discount_summary
),
all_sales_total AS (
    SELECT
        SUM(gross_sales) AS total_revenue_all_non_epidemic
    FROM base_sales
),
scenario AS (
    SELECT
        p.avg_rev_10_promo,
        p.avg_rev_25_promo,
        p.row_count_25_promo,
        a.total_revenue_all_non_epidemic,
        (p.avg_rev_25_promo * p.row_count_25_promo) AS current_total_revenue_25_promo,
        (p.avg_rev_10_promo * p.row_count_25_promo) AS projected_total_revenue_as_10_promo
    FROM pivoted p
    CROSS JOIN all_sales_total a
)
SELECT
    ROUND(avg_rev_25_promo, 2) AS current_avg_revenue_25_promo,
    ROUND(avg_rev_10_promo, 2) AS projected_avg_revenue_10_promo,
    row_count_25_promo,
    ROUND(current_total_revenue_25_promo, 2) AS current_total_revenue_25_promo,
    ROUND(projected_total_revenue_as_10_promo, 2) AS projected_total_revenue_as_10_promo,
    ROUND(projected_total_revenue_as_10_promo - current_total_revenue_25_promo, 2) AS net_increased_revenue,
    ROUND(total_revenue_all_non_epidemic, 2) AS total_revenue_all_non_epidemic,
    ROUND(
        100.0 * (projected_total_revenue_as_10_promo - current_total_revenue_25_promo)
        / NULLIF(total_revenue_all_non_epidemic, 0),
        4
    ) AS pct_increased_revenue_of_all_sales
FROM scenario;


