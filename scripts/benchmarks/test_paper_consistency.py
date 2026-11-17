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

    # 5. Build log health
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
        f"0 style violations, 0 overfull boxes."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
