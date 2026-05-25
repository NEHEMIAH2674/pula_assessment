-- ============================================================
-- 01_int_enriched.sql
-- Intermediate layer: all derived / calculated columns
-- References stg_farmers — run after 00_stg_farmers.sql
-- ============================================================

CREATE OR REPLACE VIEW int_enriched AS
SELECT
    *,

    -- Trees per acre: guard against division by zero
    CASE WHEN farm_size > 0
         THEN ROUND(productive_trees / farm_size, 2)
         ELSE NULL END                                  AS trees_per_acre,

    -- Year-on-year FAQ production change
    (faq_2023 - faq_2022)                              AS faq_change_kg,

    CASE WHEN faq_2022 > 0
         THEN ROUND(((faq_2023 - faq_2022) / faq_2022) * 100, 1)
         ELSE NULL END                                  AS faq_change_pct,

    -- DQC flag: productive trees cannot exceed farmer's own total estimate
    CASE WHEN productive_trees > estimated_trees
         THEN true ELSE false END                       AS trees_exceed_estimate,

    -- DQC flag: both varieties at 75-100% is agronomically impossible
    CASE WHEN pct_arabica = '75-100%'
          AND pct_robusta  = '75-100%'
         THEN true ELSE false END                       AS impossible_variety_combo,

    -- New farmer flag: missing ALL 2022 production columns simultaneously
    CASE WHEN faq_2022 IS NULL
          AND kiboko_2022 IS NULL
         THEN true ELSE false END                       AS likely_new_farmer_2023

FROM stg_farmers;
