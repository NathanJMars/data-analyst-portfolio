DROP TABLE IF EXISTS manufacturing.blend_analysis_clean;

CREATE TABLE manufacturing.blend_analysis_clean AS
SELECT
 Name::TEXT AS Name,
 Batch_ID::TEXT AS Batch_ID,
 SAP_Part_ID::TEXT AS SAP_Part_ID,
 Blend_ID::TEXT AS Blend_ID,
 Tank_size::FLOAT AS Blend_volume,
 Tank_ID::TEXT AS Tank_ID,
 Area::TEXT AS Area,
 Status::TEXT AS Status,
 Additions::TEXT AS Additions,
 Date::DATE AS Date,
 Year::INTEGER AS Year,
 In_last_90::BOOLEAN AS Last_90_days,
 Number_of_adjustments::INTEGER AS Adjustment_number,
 Adjustment_count::INTEGER AS Adjustment_count,
 Additions_flag::BOOLEAN AS Additions_flag,
 Duplicate_batch_count::BOOLEAN AS Duplicate_flag,
 Record_count::INTEGER AS Record_count,
 "Group"::TEXT As "Group"
 FROM manufacturing.blend_analysis_raw;


--Remove Null tank_id--
 SELECT * 
 FROM manufacturing.blend_analysis_clean
 WHERE tank_id IS NULL;

 SELECT * 
 FROM manufacturing.blend_analysis_clean
 WHERE name IS NULL;