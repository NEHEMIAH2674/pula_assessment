-- ============================================================
-- 07_q7_labour.sql
-- Q7: Labour compliance flags by district
--
-- Yes/No values already standardised to lowercase in stg_farmers.
-- Without that standardisation, 'Yes' and 'yes' count separately
-- and all compliance totals are wrong.
-- ============================================================

CREATE OR REPLACE VIEW q7_labour AS
SELECT
    district,
    COUNT(*)                                                        AS total_farms,

    SUM(CASE WHEN underage_workers        = 'yes' THEN 1 ELSE 0 END) AS child_workers,
    SUM(CASE WHEN workers_aware_of_rights = 'no'  THEN 1 ELSE 0 END) AS unaware_of_rights,
    SUM(CASE WHEN workers_follow_schedule = 'no'  THEN 1 ELSE 0 END) AS not_following_schedule,

    ROUND(100.0 *
        SUM(CASE WHEN workers_aware_of_rights = 'no' THEN 1 ELSE 0 END)
        / COUNT(*), 1)                                              AS pct_unaware,

    ROUND(100.0 *
        SUM(CASE WHEN workers_follow_schedule = 'no' THEN 1 ELSE 0 END)
        / COUNT(*), 1)                                              AS pct_schedule_noncompliant

FROM int_enriched
GROUP BY district
ORDER BY district;
