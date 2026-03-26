CREATE OR REPLACE VIEW manufacturing.blend_analysis_analysis_v AS
SELECT
    Name AS name,
    Batch_ID AS batch_id,
    SAP_Part_ID AS sap_part_id,
    Blend_ID AS blend_id,
    Tank_size AS tank_size,
    Tank_ID AS tank_id,
    Area AS area,
    Status AS status,
    Additions AS additions,
    Additions_flag AS additions_flag,
    Date AS production_date,
    DATE_TRUNC('month', Date) AS production_month,
    Year AS year_reported,
    Adjustment_count AS number_of_adjustments,
    "Group" AS product_group
FROM manufacturing.blend_analysis_clean;

--Group Ranking by Adjustment Rate--
WITH group_summary AS (
    SELECT
        product_group,
        COUNT(*) AS total_batches,
        SUM(number_of_adjustments) AS total_adjustments,
        SUM(CASE WHEN number_of_adjustments > 0 THEN 1 ELSE 0 END) AS adjusted_batches,
        AVG(number_of_adjustments) AS avg_adjustments_per_batch
    FROM manufacturing.blend_analysis_analysis_v
    GROUP BY product_group
)
SELECT
    product_group,
    total_batches,
    total_adjustments,
    adjusted_batches,
    ROUND(100.0 * adjusted_batches / NULLIF(total_batches, 0), 2) AS adjusted_batch_rate_pct,
    ROUND(avg_adjustments_per_batch, 2) AS avg_adjustments_per_batch,
    RANK() OVER (ORDER BY total_adjustments DESC) AS adjustment_rank
FROM group_summary
ORDER BY adjustment_rank, product_group;


--Ranked Tank Analysis by Adjustment Rate (overall)--
WITH tank_summary AS (
    SELECT
        tank_id,
        area,
        COUNT(*) AS total_batches,
        SUM(number_of_adjustments) AS total_adjustments,
        SUM(CASE WHEN number_of_adjustments > 0 THEN 1 ELSE 0 END) AS adjusted_batches,
        AVG(number_of_adjustments) AS avg_adjustments_per_batch
    FROM manufacturing.blend_analysis_analysis_v
	WHERE tank_id IS NOT NULL
    GROUP BY tank_id, area
)
SELECT
    tank_id,
    area,
    total_batches,
    total_adjustments,
    adjusted_batches,
    ROUND(100.0 * adjusted_batches / NULLIF(total_batches, 0), 2) AS adjusted_batch_rate_pct,
    ROUND(avg_adjustments_per_batch, 2) AS avg_adjustments_per_batch,
    RANK() OVER (ORDER BY total_adjustments DESC) AS total_adjustment_rank,
    RANK() OVER (
        ORDER BY 100.0 * adjusted_batches / NULLIF(total_batches, 0) DESC
    ) AS adjusted_batch_rate_rank
FROM tank_summary
WHERE total_batches >= 5
ORDER BY total_adjustment_rank, tank_id;


--Ranked Tank Analysis by Adjustment Rate (Volume specific)--
WITH tank_summary AS (
    SELECT
        tank_id,
        area,
        tank_size,
        COUNT(*) AS total_batches,
        SUM(number_of_adjustments) AS total_adjustments,
        SUM(CASE WHEN number_of_adjustments > 0 THEN 1 ELSE 0 END) AS adjusted_batches,
        AVG(number_of_adjustments) AS avg_adjustments_per_batch
    FROM manufacturing.blend_analysis_analysis_v
	WHERE tank_id IS NOT NULL
    GROUP BY tank_id, area, tank_size
)
SELECT
    tank_id,
    area,
    tank_size,
    total_batches,
    total_adjustments,
    adjusted_batches,
    ROUND(100.0 * adjusted_batches / NULLIF(total_batches, 0), 2) AS adjusted_batch_rate_pct,
    ROUND(avg_adjustments_per_batch, 2) AS avg_adjustments_per_batch,
    RANK() OVER (ORDER BY total_adjustments DESC) AS total_adjustment_rank,
    RANK() OVER (
        ORDER BY 100.0 * adjusted_batches / NULLIF(total_batches, 0) DESC
    ) AS adjusted_batch_rate_rank
FROM tank_summary
WHERE total_batches >= '5'
ORDER BY adjusted_batch_rate_rank,tank_id, tank_size;


--Ranked Area analysis by adjustment rate--
WITH area_summary AS (
    SELECT
        area,
        COUNT(*) AS total_batches,
        SUM(number_of_adjustments) AS total_adjustments,
        SUM(CASE WHEN number_of_adjustments > 0 THEN 1 ELSE 0 END) AS adjusted_batches,
        AVG(number_of_adjustments) AS avg_adjustments_per_batch
    FROM manufacturing.blend_analysis_analysis_v
    GROUP BY area
)
SELECT
    area,
    total_batches,
    total_adjustments,
    adjusted_batches,
    ROUND((100.0 * adjusted_batches / NULLIF(total_batches, 0))::numeric, 2) AS adjusted_batch_rate_pct,
    ROUND(avg_adjustments_per_batch::numeric, 2) AS avg_adjustments_per_batch,
    RANK() OVER (ORDER BY total_adjustments DESC) AS total_adjustment_rank,
    RANK() OVER (
        ORDER BY (100.0 * adjusted_batches / NULLIF(total_batches, 0)) DESC
    ) AS adjusted_batch_rate_rank
FROM area_summary
ORDER BY total_adjustment_rank, area;


--30 day Rolling Average of Adjustment Rate--
WITH daily_summary AS (
    SELECT
        production_date,
        COUNT(*) AS total_batches,
        SUM(tank_size) AS total_tank_size,
        SUM(number_of_adjustments) AS total_adjustments,
        SUM(CASE WHEN number_of_adjustments > 0 THEN 1 ELSE 0 END) AS adjusted_batches
    FROM manufacturing.blend_analysis_analysis_v
    GROUP BY production_date
)
SELECT
    production_date,
    total_batches,
    total_tank_size,
    total_adjustments,
    adjusted_batches,
    ROUND((100.0 * adjusted_batches / NULLIF(total_batches, 0))::numeric, 2) AS adjusted_batch_rate_pct,
    ROUND(AVG(total_tank_size) OVER (
        ORDER BY production_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    )::numeric, 2) AS rolling_30_day_avg_tank_size,
    ROUND(AVG(total_adjustments) OVER (
        ORDER BY production_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    )::numeric, 2) AS rolling_30_day_avg_adjustments,
    ROUND(AVG(100.0 * adjusted_batches / NULLIF(total_batches, 0)) OVER (
        ORDER BY production_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    )::numeric, 2) AS rolling_30_day_avg_adjusted_rate_pct
FROM daily_summary
ORDER BY production_date;


--Overview of Blend Metrics by Month--
WITH monthly_summary AS (
    SELECT
        DATE_TRUNC('month', production_date) AS production_month,
        COUNT(*) AS total_batches,
        SUM(tank_size) AS total_tank_size,
        SUM(number_of_adjustments) AS total_adjustments,
        SUM(CASE WHEN number_of_adjustments > 0 THEN 1 ELSE 0 END) AS adjusted_batches
    FROM manufacturing.blend_analysis_analysis_v
    GROUP BY DATE_TRUNC('month', production_date)
)
SELECT
    production_month,
    total_batches,
    total_tank_size,
    total_adjustments,
    adjusted_batches,
    ROUND((100.0 * adjusted_batches / NULLIF(total_batches, 0))::numeric, 2) AS adjusted_batch_rate_pct,
    LAG(total_adjustments) OVER (ORDER BY production_month) AS prior_month_adjustments,
    ROUND(
        (
            total_adjustments
            - LAG(total_adjustments) OVER (ORDER BY production_month)
        )::numeric,
        2
    ) AS adjustment_change_vs_prior_month,
    ROUND(
        (
            100.0 * (
                total_adjustments
                - LAG(total_adjustments) OVER (ORDER BY production_month)
            ) / NULLIF(LAG(total_adjustments) OVER (ORDER BY production_month), 0)
        )::numeric,
        2
    ) AS adjustment_pct_change_vs_prior_month
FROM monthly_summary
ORDER BY production_month;


--Pareto Breakdown: Ranked Group Analysis by Adjustment--
WITH group_summary AS (
    SELECT
        product_group,
        COUNT(*) AS total_batches,
        SUM(number_of_adjustments) AS total_adjustments
    FROM manufacturing.blend_analysis_analysis_v
    GROUP BY product_group
)
SELECT
    product_group,
    total_batches,
    total_adjustments,
    ROUND(
        (100.0 * total_adjustments / NULLIF(SUM(total_adjustments) OVER (), 0))::numeric,
        2
    ) AS adjustment_share_pct,
    ROUND(
        (
            100.0 * SUM(total_adjustments) OVER (
                ORDER BY total_adjustments DESC, product_group
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) / NULLIF(SUM(total_adjustments) OVER (), 0)
        )::numeric,
        2
    ) AS cumulative_adjustment_share_pct,
    RANK() OVER (ORDER BY total_adjustments DESC) AS adjustment_rank
FROM group_summary
ORDER BY total_adjustments DESC, product_group;


--Pareto Breakdown: Top 5 Adjusted tanks by volume--
WITH tank_size_summary AS (
    SELECT
        tank_id,
        tank_size,
        COUNT(*) AS total_batches,
        SUM(number_of_adjustments) AS total_adjustments
    FROM manufacturing.blend_analysis_analysis_v
	WHERE tank_id <> '13'
    GROUP BY tank_id, tank_size
),
ranked_tank_size AS (
    SELECT
        tank_id,
        tank_size,
        total_batches,
        total_adjustments,
        ROUND(
            (100.0 * total_adjustments / NULLIF(SUM(total_adjustments) OVER (), 0))::numeric,
            2
        ) AS adjustment_share_pct,
        ROUND(
            (
                100.0 * SUM(total_adjustments) OVER (
                    ORDER BY total_adjustments DESC, tank_id, tank_size
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                ) / NULLIF(SUM(total_adjustments) OVER (), 0)
            )::numeric,
            2
        ) AS cumulative_adjustment_share_pct,
        RANK() OVER (
            ORDER BY total_adjustments DESC
        ) AS adjustment_rank
    FROM tank_size_summary
)
SELECT
    tank_id,
    tank_size,
    total_batches,
    total_adjustments,
    adjustment_share_pct,
    cumulative_adjustment_share_pct,
    adjustment_rank
FROM ranked_tank_size
WHERE adjustment_rank <= 5
ORDER BY adjustment_rank, tank_id, tank_size;

