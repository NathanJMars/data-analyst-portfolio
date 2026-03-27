# Manufacturing Blend Adjustment Analysis

## Project Overview
This project analyzes QC blend adjustment activity in a manufacturing environment to identify where adjustment burden is concentrated and where process instability may be driving repeated operational intervention. The analysis focuses on product groups, tanks, tank-size contexts, areas, and time-based trends to determine which parts of the process contribute most to recurring adjustments.

This project was built as the flagship portfolio piece because it most closely reflects real analyst work in a manufacturing and quality setting. Excel was used for source validation, dashboarding, and stakeholder reporting, while SQL was used to clean the imported data, create an analysis layer, and generate ranked, rolling-average, and Pareto-style outputs.

## Dataset Summary
The dataset contains one row per blend record and includes fields related to:
- product name
- batch and blend identifiers
- SAP part number
- tank size and tank ID
- production area
- status
- additions information
- production date and year
- number of adjustments
- product group

The project uses three related source artifacts:
- `data/QC Data.xlsx` — raw source workbook
- `QC Blend Adjustment Monitoring.xlsx` — Excel dashboard and reporting workbook
- `QC Blend Adjustment Monitoring.csv` — CSV export used for SQL import

## Data Grain
The dataset is structured at the following grain:

**one row per blend record**

This allows the project to measure adjustment burden across multiple analytical cuts, including:
- product group
- tank ID
- tank-size context
- area
- production date

## Tools Used
- Microsoft Excel
- PostgreSQL
- Tableau
- PivotTables
- Excel formulas
- GitHub

## Workflow

### Source Validation and Dashboarding in Excel
The source workbook was reviewed and validated in Excel before SQL analysis. Excel was also used to structure the dashboard, KPI outputs, and stakeholder-facing summary materials.

### SQL Cleaning and Validation
SQL was used to:
- create a raw import table from the CSV export
- create a cleaned table for analysis
- remove rows with missing required values
- standardize tank identifiers
- normalize status values
- validate cleaned outputs using targeted review queries

### SQL Analysis Layer
A dedicated analysis view was created to remove unused helper columns and provide a cleaner base for downstream queries.

### Analytical Queries
SQL was used to generate:
- product group rankings
- tank rankings
- area rankings
- daily and monthly trend summaries
- rolling averages
- prior-period comparisons using `LAG()`
- Pareto / share-of-total analysis
- top tank / tank-size priority tables

### Presentation Layer
The final findings were presented through:
- the Excel dashboard workbook
- a stakeholder-facing written summary
- supporting SQL outputs used to guide final recommendations

## Key Findings
- Adjustment burden is highly concentrated by product group, with **Soaps & Detergents** and **Dressings** accounting for the majority of all recorded adjustments.
- The highest total adjustment burden and the highest adjustment-rate burden do not always point to the same tanks, indicating that some tanks create more total work while others are less reliable proportionally.
- A small number of tank / tank-size combinations account for a disproportionate share of total adjustments, showing that burden is concentrated in a limited set of operating contexts.
- The **Mezzanine** stands out as the strongest area-level hotspot, while the **Skirt** warrants review because of its limited size capacity combined with elevated adjustment burden.
- Rolling trend analysis shows that adjustment activity remains variable over time rather than demonstrating clear sustained improvement.

## Recommendations
- **High-burden product groups:** Review **Soaps & Detergents** and **Dressings** for recurring formulation or process issues, as these groups account for the largest share of total adjustment burden.
- **Tank 1:** Use Tank 1 for non-solvent blends only when operationally necessary. Where possible, reserve it for solvent-based production or safer-fit categories such as cleaners and degreasers.
- **Skirt Area:** Evaluate whether the Skirt area remains operationally necessary. Its limited maximum blend size, combined with elevated adjustment burden, may make it a comparatively inefficient use of manufacturing and lab resources.
- **Performance monitoring:** Use the 30-day rolling trend as an ongoing KPI to track whether adjustment burden is improving after operational changes are made.

## Excel Techniques Used
- workbook-based QA checks
- helper-column validation
- data standardization checks
- pivot tables
- ranked summary tables
- dashboard layout and KPI presentation
- stakeholder-facing summary development

## SQL Techniques Used
- raw table creation for CSV import
- cleaned analysis table creation
- row-removal logic for invalid records
- value standardization using `UPDATE` and `CASE`
- creation of a reusable analysis view
- layered CTEs for structured queries
- conditional aggregation
- ranking with window functions
- rolling averages with window functions
- prior-period comparison using `LAG()`
- Pareto / share-of-total analysis

## Technical Outputs
This project produced the following technical artifacts:
- Excel workbook dashboard
- stakeholder-facing written summary
- SQL cleaning and validation script
- SQL analysis queries for rankings, trends, and Pareto analysis

## Limitations
- Rankings identify where burden is concentrated, but do not by themselves determine root cause.
- Tank, area, and product-group performance should still be interpreted alongside operational context and production mix.
- Further review is needed to determine whether burden is driven primarily by equipment, formulation, scheduling, or other process factors.

## Repository Structure
- `SQL/01_create_raw_table.sql` — raw SQL import table creation
- `SQL/02_clean_validation.sql` — cleaning logic and validation checks
- `SQL/03_analysis.sql` — rankings, trends, rolling averages, and Pareto analysis
- `data/QC Data.xlsx` — raw source workbook
- 'tables/' - Tables for importing analysis queries into Tableau for visualization.
- `QC Blend Adjustment Monitoring Dashboard.xlsx` — Excel dashboard workbook
- `Manufacturing Presentation Summary.docx` — stakeholder-facing written summary
- `QC Blend Adjustment Monitoring-SQL import.csv` — CSV export used for SQL import

## Conclusion
This project shows how Excel and SQL can be used together to identify where manufacturing adjustment burden is concentrated and where targeted operational review is most likely to be useful. The final analysis highlights a small number of product groups, tanks, and operating contexts that account for a disproportionate share of total adjustments, making the project both analytically strong and operationally relevant.