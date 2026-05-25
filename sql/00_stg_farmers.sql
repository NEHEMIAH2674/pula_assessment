-- ============================================================
-- 00_stg_farmers.sql
-- Staging layer: rename columns, fix typos, standardise values
-- ALL cleaning lives here — nothing is hidden inside Python
--
-- NOTE: All columns from raw_farmers are included here, not just
-- the ones used in Q5-Q9. Staging should always be a complete,
-- clean representation of the source — downstream models then
-- pick what they need.
-- ============================================================

CREATE OR REPLACE VIEW stg_farmers AS
SELECT
    -- ── Identifiers ───────────────────────────────────────────
    "Farmer_id"                                             AS farmer_id,
    "farmer_consent_form"                                   AS consent_form,

    -- ── Geography ─────────────────────────────────────────────
    -- ASSUMPTION: 'Nakeseke' (32 records) is a misspelling of 'Nakaseke'.
    -- No district called Nakeseke exists in Uganda.
    CASE WHEN "district" = 'Nakeseke'
         THEN 'Nakaseke'
         ELSE "district" END                                AS district,

    "gps_center_accuracy"                                   AS gps_accuracy,
    "gps_center_altitude"                                   AS gps_altitude,

    -- ── Farmer profile ────────────────────────────────────────
    "number_of_household_members"                           AS household_members,
    "number_of_coffee_farms_owned"                          AS farms_owned,
    "land_agri_or_forest"                                   AS land_type,
    "land_documents"                                        AS land_documents,

    CASE WHEN CAST("farmer_head_of_family" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("farmer_head_of_family" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS farmer_head_of_family,

    CASE WHEN CAST("farmer_has_mobile_money_wallet" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("farmer_has_mobile_money_wallet" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS has_mobile_money,

    CASE WHEN CAST("farmer_part_of_carbon_project" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("farmer_part_of_carbon_project" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS in_carbon_project,

    "carbon_project_name"                                   AS carbon_project_name,

    -- ── Cooperative ───────────────────────────────────────────
    CASE WHEN CAST("farmer_member_coffee_org" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("farmer_member_coffee_org" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS is_coop_member,

    "name_of_coffee_org"                                    AS coop_name,

    -- ── Farm characteristics ──────────────────────────────────
    "farm_size"                                             AS farm_size,
    "number_productive_trees"                               AS productive_trees,
    "coffee_trees_farmers_estimate"                         AS estimated_trees,
    "date_of_planting"                                      AS date_of_planting,
    "percent_Arabica_grown"                                 AS pct_arabica,
    "percent_Robusta_grown"                                 AS pct_robusta,
    "crops_grown"                                           AS crops_grown,
    "irrigation_method"                                     AS irrigation_method,
    "gap"                                                   AS gap_certified,

    -- ── Production volumes ────────────────────────────────────
    "2022_production_FAQ"                                   AS faq_2022,
    "2023_production_FAQ"                                   AS faq_2023,
    "2022_production_kiboko"                                AS kiboko_2022,
    "2023_production_kiboko"                                AS kiboko_2023,
    "2022_production_green_cherries"                        AS green_cherries_2022,
    "2023_production_green_cherries"                        AS green_cherries_2023,

    -- ── Supply chain ──────────────────────────────────────────
    "sell_coffee_to"                                        AS sell_coffee_to,
    "primary_buyer"                                         AS primary_buyer,

    -- ── Worker counts ─────────────────────────────────────────
    "male_workers"                                          AS male_workers,
    "female_workers"                                        AS female_workers,
    "temp_workers"                                          AS temp_workers,
    "permanent_workers"                                     AS permanent_workers,
    "local_workers"                                         AS local_workers,
    "immigrant_workers"                                     AS immigrant_workers,

    -- ── Labour compliance (boolean → explicit yes/no) ─────────
    -- ASSUMPTION: DuckDB reads these as BOOLEAN from CSV.
    -- true/false mapped explicitly to yes/no for consistency.
    -- LOWER(TRIM()) alone fails on booleans — CAST first required.
    CASE WHEN CAST("underage_workers" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("underage_workers" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS underage_workers,

    CASE WHEN CAST("workers_aware_of_rights" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("workers_aware_of_rights" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS workers_aware_of_rights,

    CASE WHEN CAST("workers_follow_schedule" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("workers_follow_schedule" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS workers_follow_schedule,

    CASE WHEN CAST("pay_min_wage" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("pay_min_wage" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS pay_min_wage,

    CASE WHEN CAST("pay_taxes" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("pay_taxes" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS pay_taxes,

    -- ── Environmental compliance ──────────────────────────────
    CASE WHEN CAST("protect_water_sources" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("protect_water_sources" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS protect_water_sources,

    CASE WHEN CAST("use_organic_waste" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("use_organic_waste" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS use_organic_waste,

    CASE WHEN CAST("harvest_wood_farm" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("harvest_wood_farm" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS harvest_wood_farm,

    -- ── Land & governance ─────────────────────────────────────
    CASE WHEN CAST("any_land_dispute" AS VARCHAR)
             IN ('true','True','yes','Yes') THEN 'yes'
         WHEN CAST("any_land_dispute" AS VARCHAR)
             IN ('false','False','no','No') THEN 'no'
         ELSE NULL END                                      AS any_land_dispute

FROM raw_farmers
WHERE "Farmer_id" IS NOT NULL;
