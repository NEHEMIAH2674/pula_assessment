-- ============================================================
-- 09_q9_cooperative.sql
-- Q9: Cooperative members vs non-members comparison
--
-- NOTE: Cooperative members are only 5.1% of the sample (121 farmers).
-- All comparisons should be read with this sample size caveat in mind.
-- ============================================================

CREATE OR REPLACE VIEW q9_cooperative AS
SELECT
    is_coop_member                                      AS coop_status,
    COUNT(*)                                            AS farmer_count,

    ROUND(AVG(farm_size), 2)                            AS avg_farm_size_acres,
    ROUND(MEDIAN(farm_size), 2)                         AS median_farm_size,
    ROUND(AVG(productive_trees), 0)                     AS avg_productive_trees,
    ROUND(AVG(trees_per_acre), 1)                       AS avg_trees_per_acre,

    ROUND(AVG(faq_2022), 0)                             AS avg_faq_2022_kg,
    ROUND(AVG(faq_2023), 0)                             AS avg_faq_2023_kg,
    ROUND(AVG(kiboko_2022), 0)                          AS avg_kiboko_2022_kg,
    ROUND(AVG(kiboko_2023), 0)                          AS avg_kiboko_2023_kg

FROM int_enriched
WHERE is_coop_member IN ('yes', 'no')
GROUP BY is_coop_member
ORDER BY is_coop_member DESC;
