-- ============================================================
-- 06_q6_density.sql
-- Q6: Average farm size & tree density by district
--
-- Plausibility thresholds based on Uganda UCDA smallholder norms:
--   Normal range: 400–1,600 trees/acre
--   Flagged range: <100 or >2,500 trees/acre (self-report tolerance)
-- ============================================================

CREATE OR REPLACE VIEW q6_density AS
SELECT
    district,
    COUNT(*)                                            AS farmer_count,
    ROUND(AVG(farm_size), 2)                            AS avg_farm_size_acres,
    ROUND(MEDIAN(farm_size), 2)                         AS median_farm_size,
    ROUND(AVG(productive_trees), 0)                     AS avg_productive_trees,
    ROUND(AVG(trees_per_acre), 1)                       AS avg_trees_per_acre,
    ROUND(MEDIAN(trees_per_acre), 1)                    AS median_trees_per_acre,

    -- Implausible density flags
    SUM(CASE WHEN trees_per_acre < 100
              OR  trees_per_acre > 2500
             THEN 1 ELSE 0 END)                         AS implausible_density_count,

    -- Logical impossibility: productive > total estimate
    SUM(CASE WHEN trees_exceed_estimate THEN 1 ELSE 0 END) AS trees_exceed_estimate_count

FROM int_enriched
GROUP BY district
ORDER BY district;
