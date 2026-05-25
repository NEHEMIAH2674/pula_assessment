-- ============================================================
-- 08_q8_variety.sql
-- Q8: Arabica vs Robusta distribution by district
--
-- DQC NOTE: Both fields are categorical range bands
-- ('0-25%', '25-50%', '50-75%', '75-100%'), not numeric values.
-- This prevents mean/median/std and sum-to-100% validation.
-- This is a survey design flaw — flagged as a recommendation
-- to redesign these as numeric fields in the next survey round.
-- ============================================================

CREATE OR REPLACE VIEW q8_variety AS
SELECT
    district,
    pct_arabica,
    pct_robusta,
    COUNT(*)                                            AS farm_count,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY district)
    , 1)                                               AS pct_of_district,

    -- DQC flag: impossible combination (both at 75-100%)
    SUM(CASE WHEN impossible_variety_combo THEN 1 ELSE 0 END) AS impossible_combo_count

FROM int_enriched
WHERE pct_arabica IS NOT NULL
GROUP BY district, pct_arabica, pct_robusta
ORDER BY district, farm_count DESC;
