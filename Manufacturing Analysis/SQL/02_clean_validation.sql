DROP TABLE IF EXISTS manufacturing.blend_analysis_clean;

CREATE TABLE manufacturing.blend_analysis_clean AS
SELECT
 Name::TEXT AS Name,
 Batch_ID::TEXT AS Batch_ID,
 SAP_Part_ID::TEXT AS SAP_Part_ID,
 Blend_ID::TEXT AS Blend_ID,
 Tank_size::FLOAT AS Tank_size,
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

-- Delete Rows that fail required  --
DELETE FROM manufacturing.blend_analysis_clean
WHERE
    "Group" IS NULL
    OR TRIM("Group") = ''
    OR UPPER(TRIM("Group")) = 'NOT FOUND'
    OR Name IS NULL
    OR TRIM(Name) = ''
    OR UPPER(TRIM(Name)) = 'NOT FOUND'
    OR Tank_size IS NULL
	OR Tank_size <= 0;

--Validate Row deletion--
SELECT
    (SELECT COUNT(*) FROM manufacturing.blend_analysis_raw) AS raw_row_count,
    (SELECT COUNT(*) FROM manufacturing.blend_analysis_clean) AS clean_row_count,
    (SELECT COUNT(*) FROM manufacturing.blend_analysis_raw)
      - (SELECT COUNT(*) FROM manufacturing.blend_analysis_clean) AS removed_row_count;
	  
--Validate tank size deletion--
SELECT *
FROM manufacturing.blend_analysis_clean
WHERE Tank_size IS NULL
   OR Tank_size <= 0;

--Clean Tank_ID. Allowing Null Values due to significant instances already in dataset--
UPDATE manufacturing.blend_analysis_clean
SET Tank_ID = UPPER(TRIM(Tank_ID))
WHERE Tank_ID IS NOT NULL;

UPDATE manufacturing.blend_analysis_clean
SET Tank_ID = CASE
	WHEN Tank_ID IN ('8A','8B','8L','8R') THEN '8'
	WHEN Tank_ID IN ('D','DRUM') THEN 'DRUM'
	WHEN Tank_ID IN ('GAL','GALLON') THEN 'GALLON'
	WHEN Tank_ID IN ('tote') THEN 'TOTE'
	WHEN Tank_ID IN ('`1', '1`') THEN '1'
	WHEN Tank_ID IN ('11 #^') THEN '11'
	WHEN Tank_ID IN ('4T') THEN '4'
	WHEN Tank_ID IN ('110','330','55','660','ETHEL','#?  #?') THEN NULL
	WHEN Tank_ID IN ('PAIL','JUG') THEN 'GALLON'
	WHEN Tank_ID IN ('9') and Status = 'Skirt' THEN NULL
	WHEN Area = 'Powders' THEN NULL
	ELSE Tank_ID
END;

--Clean Area. Moving tank_ids into correct area based on # of blends--
UPDATE manufacturing.blend_analysis_clean
SET Area = CASE
	WHEN Tank_id IN ('1','2','3','4','5','6') THEN 'Mezzanine'
	WHEN Tank_id IN ('7','8') THEN 'Skirt'
	WHEN Tank_id IN ('9','10') THEN 'Acid/Corrosive'
	WHEN Tank_id IN ('11','12','13') THEN 'Polish'
	ELSE Area
END;

	
--Clean Status. Intermediate statuses pushed ahead based on date--
UPDATE manufacturing.blend_analysis_clean
SET Status = CASE
	WHEN Status = '✔' THEN 'complete'
	WHEN (
		Status IN ('Add','WIP')
		OR Status IS NULL
		)
		AND date < CURRENT_DATE - INTERVAL '14 days' THEN 'complete'
	WHEN Status IN ('Quarantine','Stuck','X')
		AND date < CURRENT_DATE - INTERVAL '14 days' THEN 'scrap'
	ELSE Status
END;

--Validate Status Clean--
SELECT
    Status,
    COUNT(*) AS row_count
FROM manufacturing.blend_analysis_clean
GROUP BY Status
ORDER BY row_count DESC, Status;

