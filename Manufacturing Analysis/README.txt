# QC Blend Adjustment Monitoring with Excel

## Project Overview
This project analyzes QC blend adjustment activity in a manufacturing environment using Excel for data consolidation, validation, KPI reporting, and presentation-ready summary outputs.

## Dataset Summary
The workbook contains historical QC batch records across multiple source tabs. Key fields include:

- batch number
- SAP part number
- product name
- product group
- tank size
- tank number
- area
- status
- additions
- date

These fields support both operational and performance-oriented analysis, including adjustment frequency, affected blend volume, group-level comparison, and time-based trend analysis.

## Data Grain
The dataset is structured at the following grain:

one row per batch record

This grain was important to validate early, as duplicate batch identifiers, missing fields, and inconsistent manual entry needed to be distinguished from expected operational structure.

## Tools Used
- Microsoft Excel
- PivotTables
- Excel formulas
- GitHub

## Workflow

### Data Consolidation
Year-specific source data was consolidated into a single master table for analysis.

This included:
- combining inherited source records into QC Master Data
- standardizing product name and product group fields through lookup logic
- organizing the workbook into source, lookup, QA, and KPI layers

### Validation
Before analysis, the master table was checked for structural and logical consistency.

Validation checks included:
- missing SAP part number
- missing date
- missing product name
- missing product group
- duplicate batch number
- invalid tank size
- missing area
- missing tank number
- incomplete status conditions
- dates outside expected range

These checks were surfaced through a dedicated QA Checks tab rather than treated as background issues.

### Analytical Preparation
Helper columns were added to support repeatable summary logic and KPI reporting.

This included:
- year extraction
- adjusted batch flag
- adjustment count logic
- duplicate batch count logic
- rolling date-window helper fields
- record count support for summary reporting

### KPI and Summary Development
The final workbook was structured to support a presentation-facing KPI tab.

Outputs included:
- top-line KPI summary
- group-level adjustment summary
- yearly summary
- chart comparing blend volume and adjustment rate over time
- chart comparing blend volume and adjustment rate by product group

## Excel Techniques Used
- XLOOKUP for product enrichment and group mapping
- helper-column logic for analytical flags and counts
- COUNTIF / COUNTIFS for validation and grouped metrics
- SUMIFS / SUMPRODUCT for KPI calculations
- PivotTables for grouped aggregation
- charting for time-based and category-based comparison
- structured table references for formula consistency

## Technical Outputs
This project produced the following technical outputs:

- source-year QC data tabs
- lookup and enrichment tables
- consolidated master data table
- QA validation tab
- KPI summary tab
- grouped summary tables
- Excel charts comparing adjustment burden by month and by product group

## Limitations
The retained workbook snapshot includes data through August 2021, which reflects the latest available version used for this project. The workbook structure was designed as a repeatable monitoring tool rather than a one-time static report.

Because the data originated from real operational records, some fields contain manual-entry issues, incomplete values, and duplicate identifiers. These limitations were explicitly measured through the QA layer and considered during interpretation.
