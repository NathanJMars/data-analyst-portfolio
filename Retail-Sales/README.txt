# Retail Sales Analysis with PostgreSQL and Tableau

## Project Overview
This project analyzes multi-store retail sales data using PostgreSQL for data preparation, validation, and query development, with Tableau used to build presentation-ready dashboards.

## Dataset Summary
The dataset contains daily retail sales records across multiple stores and product categories. Key fields include:

- date
- store and product identifiers
- category and region
- inventory, units sold, and units ordered
- price and discount
- promotion status
- competitor pricing
- seasonality
- epidemic status
- demand

These fields support both operational and performance-oriented analysis, including time-based trends, store and category segmentation, and contextual analysis around promotions, seasonality, and epidemic conditions.

## Data Grain
The dataset is structured at the following grain:

**one row per date, store_id, and product_id**

This grain was important to validate early, as it was determined during validation that product_id was not a primary key to relate data between stores. Based on pricing information, a given product_id relates to a different product based on the store_id.

## Tools Used
- PostgreSQL
- pgAdmin
- Tableau Public
- GitHub

## Workflow

### Validation
Before analysis, the cleaned table was checked for structural and logical consistency.

Validation checks included:

- confirming the expected row count after import
- checking for NULL values and negative numeric values
- checking categorical consistency in text fields
- validating continuity between related identifiers and attributes
  - `store_id -> region`
  - `store_id + product_id -> category`
- checking for duplicate rows at the expected grain
- validating expected business bounds such as discount thresholds and zero-inventory sales cases
- confirming seasonality values aligned with the calendar date



### Analytical Query Development
SQL queries were developed to answer business-facing questions around:
- sales performance over time
- category and store-level revenue contribution
- promotion effects
- epidemic and seasonal context

These queries were also used to prepare analysis-ready outputs for dashboarding.

###SQL Techniques Used

Raw CSV ingestion into a PostgreSQL landing table
- Data type conversion and cleaning into an analysis-ready table
- Grain validation at the date, store_id, product_id level
- Data quality checks for nulls, negatives, duplicates, and category consistency
- GROUP BY aggregations for revenue, discount, and sales summaries
- CASE logic for promotion, epidemic, and seasonal comparisons
- Date-based trend analysis for time series reporting
- Export of summary tables for Tableau dashboarding

### Dashboard Creation
The final outputs were visualized in Tableau Public through two dashboards:
- a high-level sales overview dashboard
- a drivers/context dashboard focused on promotion, epidemic status, and seasonality


## Technical Outputs
This project produced the following technical outputs:

- raw SQL table creation script
- cleaned table creation and type conversion script
- validation query set
- analytical SQL query set
- Tableau dashboards built from final analytical outputs