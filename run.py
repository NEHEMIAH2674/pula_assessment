"""
run.py
======
Pula Advisors — Part 3 Analysis
Step 2: Run this to execute all SQL, print results, and save charts.

HOW TO RUN:
    python run.py

Prerequisites:
    1. python load.py   (run once first)
    2. pip install duckdb pandas matplotlib openpyxl

All logic lives in sql/*.sql files.
This script only: builds views → prints tables → saves charts.
See Part3_Findings.md for full interpretation of results.
"""

import duckdb
import os
import glob
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

# ── Config ─────────────────────────────────────────────────────────────────
DB      = 'analysis.duckdb'
SQL_DIR = 'sql'
OUT_DIR = 'outputs'
BLUE    = '#1F4E79'
ORANGE  = '#E26B0A'
GREEN   = '#375623'
RED     = '#C00000'
SEP     = '\n' + '=' * 72 + '\n'

os.makedirs(OUT_DIR, exist_ok=True)
conn = duckdb.connect(DB)

# ── Step 1: Build all views from SQL files in order ────────────────────────
print("Building views from sql/ folder...")
for f in sorted(glob.glob(f'{SQL_DIR}/*.sql')):
    conn.execute(open(f).read())
    print(f"  ✓ {os.path.basename(f)}")

# ── Helper ─────────────────────────────────────────────────────────────────
def query(view):
    return conn.execute(f"SELECT * FROM {view}").fetchdf()

# ══════════════════════════════════════════════════════════════════════════
# Q5 — Production Trends by District
# ══════════════════════════════════════════════════════════════════════════
print(SEP + "Q5 — FAQ Coffee Production Trends by District (2022 vs 2023)" + SEP)

prod = query('q5_production')
print(prod.to_string(index=False))

grew     = prod[prod['change_pct'] > 0].sort_values('change_pct', ascending=False)
declined = prod[prod['change_pct'] < 0]
over100  = prod[prod['change_pct'].abs() > 100]

print(f"\nDistricts with GROWTH    : {list(grew['district'])}")
print(f"Districts with DECLINE   : {list(declined['district'])}")
print(f"Districts with >100% change: {len(over100)}")
if len(over100):
    print(over100[['district', 'change_pct', 'n_reporting_2022', 'n_reporting_2023']].to_string(index=False))
    print("NOTE: Nakaseke's extreme % is a coverage artefact, not real production growth.")

fig, axes = plt.subplots(1, 2, figsize=(14, 5))
fig.suptitle('Q5 — FAQ Production by District: 2022 vs 2023', fontsize=13, fontweight='bold', color=BLUE)

main = prod[prod['district'] != 'Nakaseke']
x = np.arange(len(main)); w = 0.35
axes[0].bar(x - w/2, main['total_2022_kg'] / 1000, w, label='2022', color=BLUE,   alpha=0.85)
axes[0].bar(x + w/2, main['total_2023_kg'] / 1000, w, label='2023', color=ORANGE, alpha=0.85)
axes[0].set_xticks(x); axes[0].set_xticklabels(main['district'])
axes[0].set_ylabel('Total FAQ (tonnes)'); axes[0].set_title('Kayunga, Luwero & Mukono')
axes[0].legend(); axes[0].grid(axis='y', alpha=0.3)

colors = [GREEN if v > 0 else RED for v in prod['change_pct'].fillna(0)]
axes[1].bar(prod['district'], prod['change_pct'], color=colors, alpha=0.85)
axes[1].axhline(0, color='black', linewidth=0.8)
axes[1].set_ylabel('Change (%)'); axes[1].set_title('% Change 2022 to 2023')
axes[1].grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.savefig(f'{OUT_DIR}/q5_production_trends.png', dpi=150, bbox_inches='tight')
plt.close()
print(f"[Chart saved: {OUT_DIR}/q5_production_trends.png]")
print("→ See Part3_Findings.md — Q5 for interpretation")

# ══════════════════════════════════════════════════════════════════════════
# Q6 — Farm Size & Tree Density
# ══════════════════════════════════════════════════════════════════════════
print(SEP + "Q6 — Average Farm Size & Tree Density by District" + SEP)

density = query('q6_density')
print(density.to_string(index=False))

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
fig.suptitle('Q6 — Farm Size & Tree Density by District', fontsize=13, fontweight='bold', color=BLUE)

axes[0].bar(density['district'], density['avg_farm_size_acres'], color=BLUE, alpha=0.85)
axes[0].set_ylabel('Average Farm Size (acres)'); axes[0].set_title('Average Farm Size')
axes[0].grid(axis='y', alpha=0.3)

axes[1].bar(density['district'], density['avg_trees_per_acre'], color=ORANGE, alpha=0.85)
axes[1].axhline(400,  color=GREEN, linestyle='--', linewidth=1.2, label='Normal min (400)')
axes[1].axhline(1600, color=RED,   linestyle='--', linewidth=1.2, label='Normal max (1600)')
axes[1].set_ylabel('Avg Trees per Acre'); axes[1].set_title('Tree Density by District')
axes[1].legend(fontsize=8); axes[1].grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.savefig(f'{OUT_DIR}/q6_density_by_district.png', dpi=150, bbox_inches='tight')
plt.close()
print(f"[Chart saved: {OUT_DIR}/q6_density_by_district.png]")
print("→ See Part3_Findings.md — Q6 for interpretation")

# ══════════════════════════════════════════════════════════════════════════
# Q7 — Labour Compliance
# ══════════════════════════════════════════════════════════════════════════
print(SEP + "Q7 — Labour Compliance Flags by District" + SEP)

labour = query('q7_labour')
print(labour.to_string(index=False))

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
fig.suptitle('Q7 — Labour Compliance by District', fontsize=13, fontweight='bold', color=BLUE)

x = np.arange(len(labour)); w = 0.28
axes[0].bar(x - w, labour['child_workers'],          w, label='Child Workers',          color=RED,    alpha=0.85)
axes[0].bar(x,     labour['unaware_of_rights'],      w, label='Unaware of Rights',      color=ORANGE, alpha=0.85)
axes[0].bar(x + w, labour['not_following_schedule'], w, label='Schedule Non-Compliance', color=BLUE,   alpha=0.85)
axes[0].set_xticks(x); axes[0].set_xticklabels(labour['district'])
axes[0].set_ylabel('Number of Farms'); axes[0].set_title('Flags by District')
axes[0].legend(fontsize=8); axes[0].grid(axis='y', alpha=0.3)

totals = [labour['child_workers'].sum(), labour['unaware_of_rights'].sum(), labour['not_following_schedule'].sum()]
labels = ['Child\nWorkers', 'Unaware\nof Rights', 'Schedule\nNon-Compliance']
axes[1].bar(labels, totals, color=[RED, ORANGE, BLUE], alpha=0.85)
axes[1].set_ylabel('Total Farms'); axes[1].set_title('Overall Totals')
for i, v in enumerate(totals):
    axes[1].text(i, v + 0.5, str(v), ha='center', fontsize=12, fontweight='bold')
axes[1].grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.savefig(f'{OUT_DIR}/q7_labour_compliance.png', dpi=150, bbox_inches='tight')
plt.close()
print(f"[Chart saved: {OUT_DIR}/q7_labour_compliance.png]")
print("→ See Part3_Findings.md — Q7 for interpretation")

# ══════════════════════════════════════════════════════════════════════════
# Q8 — Arabica vs Robusta Distribution
# ══════════════════════════════════════════════════════════════════════════
print(SEP + "Q8 — Arabica vs Robusta Distribution by District" + SEP)

variety = query('q8_variety')
print(variety.to_string(index=False))

arabica_counts = conn.execute("""
    SELECT pct_arabica, COUNT(*) AS n FROM int_enriched
    WHERE pct_arabica IS NOT NULL GROUP BY pct_arabica ORDER BY pct_arabica
""").fetchdf()
robusta_counts = conn.execute("""
    SELECT pct_robusta, COUNT(*) AS n FROM int_enriched
    WHERE pct_robusta IS NOT NULL GROUP BY pct_robusta ORDER BY pct_robusta
""").fetchdf()
impossible = conn.execute(
    "SELECT COUNT(*) AS n FROM int_enriched WHERE impossible_variety_combo"
).fetchone()[0]

print(f"\nDQC FLAG — Both varieties at 75-100% (logically impossible): {impossible} farms")

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
fig.suptitle('Q8 — Arabica vs Robusta Distribution', fontsize=13, fontweight='bold', color=BLUE)

cats      = ['0-25%', '25-50%', '50-75%', '75-100%']
arab_vals = [arabica_counts[arabica_counts['pct_arabica'] == c]['n'].values[0]
             if c in arabica_counts['pct_arabica'].values else 0 for c in cats]
robu_vals = [robusta_counts[robusta_counts['pct_robusta'] == c]['n'].values[0]
             if c in robusta_counts['pct_robusta'].values else 0 for c in cats]

x = np.arange(len(cats)); w = 0.35
axes[0].bar(x - w/2, arab_vals, w, label='Arabica', color=BLUE,   alpha=0.85)
axes[0].bar(x + w/2, robu_vals, w, label='Robusta', color=ORANGE, alpha=0.85)
axes[0].set_xticks(x); axes[0].set_xticklabels(cats)
axes[0].set_ylabel('Farms'); axes[0].set_title('Coverage Distribution')
axes[0].legend(); axes[0].grid(axis='y', alpha=0.3)

dominant = {
    'Predominantly\nRobusta (≥75%)': int(robu_vals[3]),
    'Mixed':                          int(sum(robu_vals[1:3])),
    'Predominantly\nArabica (≥75%)': int(arab_vals[3]),
}
axes[1].pie(
    dominant.values(), labels=dominant.keys(),
    colors=[ORANGE, '#888888', BLUE], autopct='%1.1f%%',
    startangle=140, textprops={'fontsize': 9}
)
axes[1].set_title('Dominant Variety Profile')

plt.tight_layout()
plt.savefig(f'{OUT_DIR}/q8_arabica_robusta.png', dpi=150, bbox_inches='tight')
plt.close()
print(f"[Chart saved: {OUT_DIR}/q8_arabica_robusta.png]")
print("→ See Part3_Findings.md — Q8 for interpretation")

# ══════════════════════════════════════════════════════════════════════════
# Q9 — Cooperative Membership
# ══════════════════════════════════════════════════════════════════════════
print(SEP + "Q9 — Cooperative Members vs Non-Members" + SEP)

coop    = query('q9_cooperative')
print(coop.to_string(index=False))

fig, axes = plt.subplots(1, 2, figsize=(13, 5))
fig.suptitle('Q9 — Cooperative Members vs Non-Members', fontsize=13, fontweight='bold', color=BLUE)

metrics  = ['avg_farm_size_acres', 'avg_productive_trees', 'avg_faq_2023_kg']
labels   = ['Farm Size\n(acres)', 'Productive\nTrees', '2023 FAQ\n(kg)']
yes_row  = coop[coop['coop_status'] == 'yes'].iloc[0]
no_row   = coop[coop['coop_status'] == 'no'].iloc[0]
yes_vals = [yes_row[m] for m in metrics]
no_vals  = [no_row[m]  for m in metrics]

x = np.arange(len(metrics)); w = 0.35
axes[0].bar(x - w/2, yes_vals, w, label='Coop Members', color=BLUE,   alpha=0.85)
axes[0].bar(x + w/2, no_vals,  w, label='Non-Members',  color=ORANGE, alpha=0.85)
axes[0].set_xticks(x); axes[0].set_xticklabels(labels)
axes[0].set_title('Key Metrics Comparison')
axes[0].legend(fontsize=9); axes[0].grid(axis='y', alpha=0.3)

all_metrics = ['avg_farm_size_acres', 'avg_productive_trees', 'avg_trees_per_acre',
               'avg_faq_2022_kg', 'avg_faq_2023_kg']
diffs   = [((yes_row[m] - no_row[m]) / no_row[m] * 100) if no_row[m] > 0 else 0
           for m in all_metrics]
mlabels = ['Farm Size', 'Productive Trees', 'Tree Density', 'FAQ 2022', 'FAQ 2023']
colors  = [GREEN if d > 0 else RED for d in diffs]
axes[1].barh(mlabels, diffs, color=colors, alpha=0.85)
axes[1].axvline(0, color='black', linewidth=0.8)
axes[1].set_xlabel('% Difference (Coop vs Non-Coop)')
axes[1].set_title('Relative Difference (%)')
axes[1].grid(axis='x', alpha=0.3)

plt.tight_layout()
plt.savefig(f'{OUT_DIR}/q9_cooperative_comparison.png', dpi=150, bbox_inches='tight')
plt.close()
print(f"[Chart saved: {OUT_DIR}/q9_cooperative_comparison.png]")
print("→ See Part3_Findings.md — Q9 for interpretation")

# ── Done ───────────────────────────────────────────────────────────────────
conn.close()
print(SEP + "PART 3 COMPLETE — all charts saved to outputs/" + SEP)
print("Full findings and interpretations: Part3_Findings.md")
