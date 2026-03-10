CREATE VIEW retail.avg_price_by_promotion AS
SELECT
    promotion,
    AVG(units_sold) AS avg_units_sold,
    AVG(demand) AS avg_demand,
    AVG(inventory_level) AS avg_inventory_level,
    AVG(price) AS avg_price,
    AVG(discount) AS avg_discount,
	AVG(units_sold * price) AS avg_gross_sales,
	AVG(competitor_pricing) AS avg_competitor_price
FROM retail.sales_data_clean
GROUP BY promotion
ORDER BY promotion;

CREATE VIEW retail.avg_price_by_date_promotion AS
SELECT
    date,
    promotion,
    ROUND(AVG(price), 2) AS avg_price,
	ROUND(AVG(competitor_pricing),2) AS avg_competitor_price
FROM retail.sales_data_clean
GROUP BY date, promotion
ORDER BY date, promotion;

CREATE VIEW retail._sales_over_time AS
SELECT
    date,
    ROUND(SUM(units_sold * price), 2) AS total_gross_sales
FROM retail.sales_data_clean
GROUP BY date
ORDER BY date;

CREATE VIEW retail.gross_sales_by_category AS
SELECT
    category,
    ROUND(SUM(units_sold * price), 2) AS total_gross_sales,
    ROUND(AVG(units_sold)::numeric, 2) AS avg_units_sold,
    ROUND(AVG(demand)::numeric, 2) AS avg_demand
FROM retail.sales_data_clean
GROUP BY category
ORDER BY total_gross_sales DESC;

CREATE VIEW retail.gross_sales_by_region AS
SELECT
    region,
    ROUND(SUM(units_sold * price), 2) AS total_gross_sales,
    ROUND(AVG(units_sold)::numeric, 2) AS avg_units_sold,
    ROUND(AVG(demand)::numeric, 2) AS avg_demand
FROM retail.sales_data_clean
GROUP BY region
ORDER BY total_gross_sales DESC;

SELECT
    date,
    epidemic,
    ROUND(SUM(units_sold * price),2) AS total_gross_sales
FROM retail.sales_data_clean
GROUP BY date, epidemic
ORDER BY date, epidemic;

SELECT
    promotion,
    ROUND(SUM(units_sold * price), 2) AS total_gross_sales,
    ROUND(AVG(units_sold * price), 2) AS avg_gross_sales,
	ROUND(AVG(discount), 2) AS avg_discount
FROM retail.sales_data_clean
GROUP BY promotion
ORDER BY promotion;

select *
from retail.sales_data_clean;