# Part 3 — Python / SQL Analysis
## Pula Advisors Data Analyst Assessment

---

## How to Run

### 1. Install dependencies
```
pip install duckdb pandas matplotlib openpyxl
```

### 2. Place the dataset in this folder
```
X DATASET.xlsx   ← must be in the same folder as load.py
```

### 3. Load the data (run once)
```
python load.py
```

### 4. Run the full analysis
```
python run.py
```

All results print to the console. Charts are saved to `outputs/`.

---

## Project Structure

```
Part3_Project/
├── load.py              ← loads Excel into DuckDB (run once)
├── run.py               ← builds views, prints results, saves charts
├── analysis.duckdb      ← auto-created by load.py
├── sql/
│   ├── 00_stg_farmers.sql     ← cleaning layer (rename, fix typos, standardise)
│   ├── 01_int_enriched.sql    ← derived columns (trees/acre, change%, DQC flags)
│   ├── 05_q5_production.sql   ← Q5: production trends by district
│   ├── 06_q6_density.sql      ← Q6: farm size & tree density
│   ├── 07_q7_labour.sql       ← Q7: labour compliance flags
│   ├── 08_q8_variety.sql      ← Q8: arabica vs robusta distribution
│   └── 09_q9_cooperative.sql  ← Q9: cooperative membership comparison
└── outputs/
    ├── q5_production_trends.png
    ├── q6_density_by_district.png
    ├── q7_labour_compliance.png
    ├── q8_arabica_robusta.png
    └── q9_cooperative_comparison.png
```

---

## Design Approach

All business logic lives in `.sql` files — layered like a dbt project but with no framework overhead:

- **Staging (`00_`)** — raw column renames, district typo fix, yes/no standardisation
- **Intermediate (`01_`)** — derived columns and DQC flags built on top of staging
- **Mart queries (`05_`–`09_`)** — one SQL view per question, each referencing `int_enriched`

`run.py` contains zero analytical logic — it only builds the views, prints the tables, and renders charts. If you want to change any calculation, edit the relevant `.sql` file only.

---

## Key Assumptions Documented

| # | Assumption | Location |
|---|---|---|
| 1 | 'Nakeseke' is a misspelling of 'Nakaseke' | `00_stg_farmers.sql` |
| 2 | Yes/No fields standardised to lowercase | `00_stg_farmers.sql` |
| 3 | 520 records missing all 2022 production = new farmers enrolled in 2023 | `05_q5_production.sql` |
| 4 | Implausible density thresholds: <100 or >2,500 trees/acre | `06_q6_density.sql` |
| 5 | Arabica/Robusta fields are categorical bands, not numeric — prevents sum-to-100% check | `08_q8_variety.sql` |
