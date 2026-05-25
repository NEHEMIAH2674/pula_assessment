"""
load.py
=======
Pula Advisors — Part 3 Analysis
Step 1: Run this ONCE to load the Excel into DuckDB.

HOW TO RUN:
    python load.py

After this, you only ever run run.py.
"""

import pandas as pd
import duckdb

# ── Load raw Excel ─────────────────────────────────────────────────────────
df = pd.read_excel(
    'X DATASET.xlsx',
    sheet_name='1. Data for Submission',
    header=2
)

# Drop blank / unnamed structural columns from multi-row header
df = df.loc[:, [
    c for c in df.columns
    if not str(c).startswith('Unnamed')
    and str(c).strip() not in ['', ' ', '.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8']
]].copy()

# Save as CSV so DuckDB can read it
df.to_csv('raw_farmers.csv', index=False)

# ── Register in DuckDB ─────────────────────────────────────────────────────
conn = duckdb.connect('analysis.duckdb')
conn.execute("""
    CREATE OR REPLACE VIEW raw_farmers AS
    SELECT * FROM read_csv_auto('raw_farmers.csv', header=true)
""")
conn.close()

print(f"Done — {len(df):,} rows loaded into analysis.duckdb")
print("Now run:  python run.py")
