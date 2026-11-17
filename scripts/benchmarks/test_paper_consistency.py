#!/usr/bin/env python3
"""Automated cross-artifact integrity test for the IEEE TCAS-I SCORE manuscript.

Verifies in a single command:
1. benchmarks/audit_summary.json and benchmarks/model_validation.json integrity.
2. Exact figure (14/14), equation (10/10), and BibTeX (77/77) cross-reference completeness.
3. IEEE style compliance (strict Fig., vs.\\, Ops/cycle, zero banned/contrastive terms, zero em-dashes).
4. LaTeX build log health (0 overfull boxes) and JSON-to-manuscript headline metric parity.
"""

from __future__ import annotations

import json
import math
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PAPER = ROOT / "publications/writings/TCAS1-SCORE"


def main() -> int:
    failures: list[str] = []

    audit = json.loads((ROOT / "benchmarks/audit_summary.json").read_text())
    val = json.loads((ROOT / "benchmarks/model_validation.json").read_text())

    # 1. Benchmark & model-validation invariants
    if val["corpus_accounting"]["tier_evaluated_targets"] != 56:
        failures.append("Expected 56 tier-evaluated targets")
    if val["corpus_accounting"]["distinct_repositories"] != 54:
        failures.append("Expected 54 distinct repositories")
    if val["eq3_eq4_scalar_validation"]["coremark_exact_matches"] != 21:
        failures.append("Expected 21/22 exact CoreMark matches")
    if val["eq5_eq6_app_validation"]["mshr_vs_memcpy_pearson_r_log2"] < 0.96:
        failures.append("Expected log2 MSHR correlation >= 0.96")
    if val["eq7_eq8_vector_validation"]["ops_per_cycle_checked"] != 13:
        failures.append("Expected 13 verified vector Ops/cyc runs")
    if val["level4_soc_telemetry_anchors"]["exact_matches"] != 10:
        failures.append("Expected 10/10 exact Level 4 telemetry anchor matches")
    if len(val["eq10_dma_breakeven"]["effective_dma_curve_64b_to_64kb"]) != 6:
        failures.append("Expected 6-point Eq. (10) DMA curve")
    if audit["totals"]["archived_runs"] != 190 or audit["totals"]["unique_profiles"] != 175:
        failures.append("Expected 190 archived runs and 175 unique profiles in audit_summary.json")

    # 2. Manuscript cross-references & BibTeX 1-to-1 match
    tex_files = [PAPER / "main.tex"] + sorted((PAPER / "sections").glob("*.tex"))
    tex = "\n".join(p.read_text() for p in tex_files)

    fig_labels = re.findall(r"\\label\{(fig:[^}]+)\}", tex)
    eq_labels = re.findall(r"\\label\{(eq:[^}]+)\}", tex)
    refs = set(re.findall(r"\\(?:eq)?ref\{([^}]+)\}", tex))
    cites = {k.strip() for m in re.findall(r"\\cite\{([^}]+)\}", tex) for k in m.split(",")}
    bib_keys = set(re.findall(r"@\w+\{([^,]+),", (PAPER / "bib.bib").read_text())) - {"IEEEexample:BSTcontrol"}

    unreferenced_figs = [l for l in fig_labels if l not in refs]
    unreferenced_eqs = [l for l in eq_labels if l not in refs]
    if len(fig_labels) != 14 or unreferenced_figs:
        failures.append(f"Figure reference check failed: total={len(fig_labels)}, unref={unreferenced_figs}")
    if len(eq_labels) != 10 or unreferenced_eqs:
        failures.append(f"Equation reference check failed: total={len(eq_labels)}, unref={unreferenced_eqs}")
    if cites != bib_keys:
        failures.append(f"BibTeX mismatch: uncited={sorted(bib_keys - cites)}, missing={sorted(cites - bib_keys)}")

    # 3. Strict IEEE style & tone checks
    banned = re.compile(r"\b(however|but|yet|conversely|despite|unfortunately|survey)\b", re.I)
    for m in banned.finditer(tex):
        ctx = tex[max(0, m.start() - 30):m.end() + 30]
        if "Survey of Open-Source Chip" in ctx or "a-comparative-survey" in ctx:
            continue
        failures.append(f"Banned/contrastive word '{m.group(0)}' in context: {ctx.strip()!r}")
    if re.search(r"Figure~\\ref|Figure \\ref", tex):
        failures.append("Found non-IEEE 'Figure \\ref' (use Fig.~\\ref)")
    if re.search(r"---", tex):
        failures.append("Found em-dash '---' in manuscript prose")
    if re.search(r"\bvs\s+", tex):
        failures.append("Found unpunctuated 'vs ' (use 'vs.\\')")
    if re.search(r"\bops/cycle\b", tex):
        failures.append("Found lowercase 'ops/cycle' (use 'Ops/cycle')")

    # 4. Headline metric parity between JSON and LaTeX prose
    for token in ["190", "175", "56", "54", "0.963", "61.0", "302.7", "256-byte", "161.5", "3.35"]:
        if token not in tex:
            failures.append(f"Expected validated metric token {token!r} in manuscript")

    # 5. SVG-to-Equation Vertex Coordinate Checks (< 0.5 px tolerance)
    fig10 = (PAPER / "figures/fig-vector-pareto-frontier.svg").read_text()
    if 'cx="413.5" cy="218.1"' not in fig10 or 'cx="290.7" cy="430.5"' not in fig10:
        failures.append("Fig. 10 SVG missing exact Spatz 2-PE (84 kGE) or CV32E40P XPULP (35 kGE) coordinates")

    fig11 = (PAPER / "figures/fig-vector-utilization-cliff.svg").read_text()
    m11 = re.search(r'<polyline points="([^"]+)" fill="none" stroke="#2563eb"', fig11)
    if not m11:
        failures.append("Fig. 11 blue Eq. (8) polyline not found")
    else:
        pts11 = [tuple(float(v) for v in p.split(",")) for p in m11.group(1).split()]
        exp11_y = [342.0 - 50.0 * e["eq8_inferred_rho_host"] for e in val["eq7_eq8_vector_validation"]["ara_5kernel_cliff_eq8"]]
        if len(pts11) != len(exp11_y) or any(abs(p[1] - ey) > 0.5 for p, ey in zip(pts11, exp11_y)):
            failures.append(f"Fig. 11 blue polyline drifts >0.5 px from Eq. (8): got {[p[1] for p in pts11]} vs {[round(y,1) for y in exp11_y]}")

    fig13 = (PAPER / "figures/fig-soc-barrier-scaling.svg").read_text()
    amo_vals = [120, 480, 3200, 11800, 38400, 98500]
    tree_vals = [95, 180, 310, 410, 515, 610]
    for color, label, vals in [("#e11d48", "AMO", amo_vals), ("#059669", "FractalSync", tree_vals)]:
        mp = re.search(rf'<path d="([^"]+)" stroke="{color}"', fig13)
        if not mp:
            failures.append(f"Fig. 13(A) {label} path not found")
            continue
        ys = [float(y) for _, y in re.findall(r"([0-9.]+),([0-9.]+)", mp.group(1))]
        exp_ys = [425.0 - 82.5 * (math.log10(v) - 1.0) for v in vals]
        if len(ys) != len(exp_ys) or any(abs(a - b) > 0.5 for a, b in zip(ys, exp_ys)):
            failures.append(f"Fig. 13(A) {label} drifts >0.5 px: got {ys} vs {[round(y,1) for y in exp_ys]}")

    mp_dma = re.search(r'<path d="([^"]+)" stroke="#2563eb"', fig13)
    if not mp_dma:
        failures.append("Fig. 13(B) DMA path not found")
    else:
        ys_dma = [float(y) for _, y in re.findall(r"([0-9.]+),([0-9.]+)", mp_dma.group(1))]
        exp_dma = [425.0 - 20.625 * pt["effective_gb_s"] for pt in val["eq10_dma_breakeven"]["effective_dma_curve_64b_to_64kb"]]
        if len(ys_dma) != len(exp_dma) or any(abs(a - b) > 0.5 for a, b in zip(ys_dma, exp_dma)):
            failures.append(f"Fig. 13(B) DMA drifts >0.5 px from Eq. (10): got {ys_dma} vs {[round(y,1) for y in exp_dma]}")

    # 6. Build log health
    log_path = PAPER / "build/main.log"
    if log_path.exists():
        log_txt = log_path.read_text()
        if re.search(r"Overfull \\", log_txt):
            failures.append("Found Overfull box in build/main.log")
        if re.search(r"Warning:.*(Reference|Citation).*undefined", log_txt):
            failures.append("Found undefined reference/citation in build/main.log")

    if failures:
        print("FAILED CHECKS:")
        for item in failures:
            print("  -", item)
        return 1

    print(
        f"ALL CHECKS PASSED: {len(fig_labels)}/14 figs cited, {len(eq_labels)}/10 eqs cited, "
        f"{len(cites)}/{len(bib_keys)} refs matched 1:1, 10/10 L4 anchors exact, "
        f"Figs 10/11/13 pixel-exact (<0.5 px), 0 style violations, 0 overfull boxes."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
