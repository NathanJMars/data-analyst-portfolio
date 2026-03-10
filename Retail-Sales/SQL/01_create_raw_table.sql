CREATE SCHEMA IF NOT EXISTS retail;

DROP TABLE IF EXISTS retail.sales_data_raw;

CREATE TABLE retail.sales_data_raw (
    date TEXT,
    store_id TEXT,
    product_id TEXT,
    category TEXT,
    region TEXT,
    inventory_level TEXT,
    units_sold TEXT,
    units_ordered TEXT,
    price TEXT,
    discount TEXT,
    weather_condition TEXT,
    promotion TEXT,
    competitor_pricing TEXT,
    seasonality TEXT,
    epidemic TEXT,
    demand TEXT
);