# Part 3 — Findings & Interpretations
## Pula Advisors Data Analyst Assessment
**Dataset:** X DATASET.xlsx — 2,374 farmers across 4 Ugandan districts (Kayunga, Luwero, Mukono, Nakaseke)

---

## Q5 — FAQ Coffee Production Trends by District (2022 vs 2023)

| District | Farmers | Reporting 2022 | Total 2022 (kg) | Reporting 2023 | Total 2023 (kg) | Change (kg) | Change (%) |
|---|---|---|---|---|---|---|---|
| Kayunga | 1,198 | 1,188 | 1,342,495 | 1,198 | 1,194,091 | -148,404 | **-11.1%** |
| Luwero | 899 | 625 | 781,000 | 899 | 1,046,452 | +265,452 | **+34.0%** |
| Mukono | 15 | 9 | 8,800 | 9 | 8,960 | +160 | **+1.8%** |
| Nakaseke | 262 | 32 | 4,800 | 262 | 227,317 | +222,517 | **+4,636%** |

**Interpretation:**
Kayunga is the only district where a reliable year-on-year comparison is possible — 1,188 of 1,198 farmers reported in both years, showing a genuine 11.1% production decline. This is the headline finding for X's client and warrants further investigation into whether the cause is climatic, agronomic, or market-driven.

Luwero's apparent 34% growth is misleading — only 625 of 899 farmers reported 2022 production, meaning 274 additional farmers appear in the 2023 total with no 2022 baseline. The actual per-farm trend in Luwero cannot be determined from this data.

Nakaseke's 4,636% figure is a coverage artefact — only 32 of 262 farmers submitted 2022 data, most likely because Nakaseke farmers were newly enrolled in 2023. This number should not be reported to the client as a production trend.

**Recommendation:** For all client-facing production reporting, use Kayunga only for year-on-year comparisons. Flag Luwero and Nakaseke as requiring data completeness improvement before the next survey round.

---

## Q6 — Average Farm Size & Tree Density by District

| District | Farmers | Avg Farm (acres) | Median Farm | Avg Trees | Avg Trees/Acre | Implausible Density | Trees > Estimate |
|---|---|---|---|---|---|---|---|
| Kayunga | 1,198 | 1.48 | 1.10 | 895 | 1,285 | 236 | 4 |
| Luwero | 899 | 3.11 | 3.00 | 1,168 | 701 | 182 | 182 |
| Mukono | 15 | 2.22 | 0.81 | 922 | 1,286 | 1 | 0 |
| Nakaseke | 262 | 4.78 | 4.02 | 1,216 | 357 | 47 | 132 |

**Interpretation:**
Kayunga farmers have the smallest farms (avg 1.48 acres) but among the highest tree density at 1,285 trees/acre — at the upper end of the agronomic normal range of 400–1,600 trees/acre. This is most likely explained by farm size underreporting rather than genuinely extreme planting density.

Nakaseke shows the opposite profile — largest farms (4.78 acres avg) and lowest density (357 trees/acre), below the 400 trees/acre minimum threshold. This suggests more extensive, lower-intensity growing practices in Nakaseke, or that farm boundaries include non-coffee land.

Luwero has 182 records where productive trees exceed the farmer's own total estimate — a logical impossibility. These records are flagged as data quality issues and should be excluded from density calculations or followed up with enumerators.

**Recommendation:** Investigate the 318 farms with logical impossibilities (productive > estimated trees) across all districts. Consider adding GPS-verified farm boundary measurements in the next survey to resolve the farm size underreporting pattern.

---

## Q7 — Labour Compliance Flags by District

| District | Total Farms | Child Workers | Unaware of Rights | Not Following Schedule | % Unaware | % Schedule |
|---|---|---|---|---|---|---|
| Kayunga | 1,198 | 0 | 0 | 0 | 0.0% | 0.0% |
| Luwero | 899 | 0 | 51 | 22 | 5.7% | 2.4% |
| Mukono | 15 | 0 | 0 | 0 | 0.0% | 0.0% |
| Nakaseke | 262 | 0 | 33 | 22 | 12.6% | 8.4% |

**Interpretation:**
Zero farms across all four districts report the use of child workers — a strong positive finding for X's ESG positioning and a clean signal for any buyer due diligence process.

However, 84 farms (3.5% of the total) report workers who are unaware of their rights, and 44 farms (1.9%) report workers not following the required schedule. Both issues are geographically concentrated — entirely in Luwero and Nakaseke. Kayunga and Mukono are fully compliant on both measures.

Nakaseke's compliance gap is proportionally the most serious: 12.6% of its farms report workers unaware of rights, and 8.4% report schedule non-compliance. For a district of 262 farmers this is a significant ESG risk concentration.

The geographic clustering of compliance issues raises two possible explanations: genuine compliance gaps in these districts, or inconsistent enumerator training affecting how questions were asked and recorded. Both possibilities should be investigated before remediation is designed.

**Recommendation:** X should prioritise worker rights awareness training in Luwero and Nakaseke before pursuing ESG-linked buyer certifications or premium pricing. Enumerator consistency across districts should also be audited.

---

## Q8 — Arabica vs Robusta Distribution by District

| District | Dominant Profile | Farm Count | % of District |
|---|---|---|---|
| Kayunga | 0-25% Arabica / 75-100% Robusta | 1,198 | 100% |
| Luwero | 0-25% Arabica / 75-100% Robusta | 889 | 98.9% |
| Mukono | 0-25% Arabica / 75-100% Robusta | 9 | 100% |
| Nakaseke | 0-25% Arabica / 75-100% Robusta | 262 | 100% |

**DQC Flag:** 4 farms in Luwero report both Arabica and Robusta at 75-100% — agronomically impossible and flagged as data entry errors.

**Interpretation:**
This is an overwhelmingly Robusta supply chain. Across all four districts, 99.6% of farms report growing 75-100% Robusta and 0-25% Arabica. This is consistent with Uganda's established position as one of Africa's largest Robusta producers, with Arabica cultivation concentrated in the mountainous Mt. Elgon and Rwenzori regions — not the central districts in this dataset.

The variety fields are collected as categorical range bands (0-25%, 25-50%, 50-75%, 75-100%) rather than numeric percentages. This prevents a sum-to-100% data quality check — a farm reporting 75-100% of both varieties cannot be validated mathematically. The 4 impossible records in Luwero are only detectable through logic, not arithmetic.

**Recommendation:** Redesign the Arabica/Robusta fields as numeric inputs (e.g. "What % of your farm is Arabica?") in the next survey round. This enables proper validation, more precise variety profiling, and blending ratio calculations for buyers.

---

## Q9 — Cooperative Members vs Non-Members

| Status | Farmers | Avg Farm (acres) | Avg Trees/Acre | Avg FAQ 2022 (kg) | Avg FAQ 2023 (kg) |
|---|---|---|---|---|---|
| Coop Member | 121 (5.1%) | 4.10 | 397 | 794 | 850 |
| Non-Member | 2,251 (94.9%) | 2.38 | 991 | 1,167 | 1,056 |

**Relative difference (Coop vs Non-Member):**
- Farm size: **+72.8%** (larger)
- Tree density: **-59.9%** (much lower)
- FAQ production 2023: **-19.5%** (lower)

**Interpretation:**
Cooperative members have significantly larger farms on average (4.1 vs 2.4 acres, +72.8%) but are producing substantially less coffee per farmer in both years. This counterintuitive result is explained by tree density — cooperative members average only 397 trees/acre versus 991 for non-members (-59.9%). More land is not translating into more production.

There are two plausible explanations. First, cooperative membership may be correlated with older, more established farmers who have larger but less intensively planted farms. Second, cooperative members may be diversifying their land across multiple crops, with coffee occupying only a portion of the reported farm size.

The 5.1% membership rate is notably low for a supply chain that X is looking to aggregate. This either represents a significant untapped opportunity — most farmers are unorganised and potentially reachable through a new cooperative structure — or it signals that existing cooperatives are not delivering sufficient value to attract members.

**Recommendation:** Conduct qualitative follow-up interviews with both cooperative members and non-members in Luwero and Nakaseke (where farm sizes are largest) to understand the barriers to membership and whether a new X-supported cooperative model would be viable.

---

## Key Data Quality Issues — Summary

| Issue | Count | Affected Districts | Severity |
|---|---|---|---|
| Productive trees > farmer's own estimate | 318 | All | High — logical impossibility |
| Nakaseke 2022 coverage gap | 230 missing | Nakaseke | High — invalidates YoY comparison |
| Both varieties at 75-100% | 4 | Luwero | Medium — data entry error |
| Implausible tree density (<100 or >2,500/acre) | 466 | All | Medium — likely farm size error |
| District name typo (Nakeseke → Nakaseke) | 32 | Nakaseke | Low — corrected in staging |

---

*Analysis conducted using DuckDB + Python. All transformations documented in `sql/` folder. Charts in `outputs/`.*
