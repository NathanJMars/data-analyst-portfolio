CREATE SCHEMA IF NOT EXISTS manufacturing;

DROP TABLE IF EXISTS manufacturing.blend_analysis_raw;

CREATE TABLE manufacturing.blend_analysis_raw (
 Name TEXT,
 Batch_ID TEXT,
 SAP_Part_ID TEXT,
 Blend_ID TEXT,
 Tank_size TEXT,
 Tank_ID TEXT,
 Area TEXT,
 Status TEXT,
 Additions TEXT,
 Date TEXT,
 Year TEXT,
 In_last_90 TEXT,
 Number_of_adjustments TEXT,
 Adjustment_count TEXT,
 Additions_flag TEXT,
 Duplicate_batch_count TEXT,
 Record_count TEXT,
 "Group" TEXT
 );

