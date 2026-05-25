-- ============================================================
-- 05_q5_production.sql
-- Q5: FAQ production trends by district, 2022 vs 2023
--
-- ASSUMPTION: 520 records missing all 2022 production columns
-- are treated as new farmers enrolled in 2023.
-- They are counted in 2023 totals but excluded from 2022 totals.
-- n_reporting_2022 makes this explicit and auditable.
-- ============================================================

CREATE OR REPLACE VIEW q5_production AS
SELECT
    district,
    COUNT(*)                                            AS n_farmers,
    COUNT(faq_2022)                                     AS n_reporting_2022,
    ROUND(SUM(faq_2022), 0)                             AS total_2022_kg,
    COUNT(faq_2023)                                     AS n_reporting_2023,
    ROUND(SUM(faq_2023), 0)                             AS total_2023_kg,
    ROUND(SUM(faq_2023) - SUM(faq_2022), 0)            AS change_kg,
    CASE WHEN SUM(faq_2022) > 0
         THEN ROUND(
                ((SUM(faq_2023) - SUM(faq_2022)) / SUM(faq_2022)) * 100
              , 1)
         ELSE NULL END                                  AS change_pct

FROM int_enriched
GROUP BY district
ORDER BY district;
