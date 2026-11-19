#!/usr/bin/env python3
"""Audit SCORE benchmark aggregated_results.json files across Levels 1-4.

Verifies:
1. Canonical evidence_class provenance ('score_measured' vs 'literature_reported').
2. Non-empty workload identifiers and simulator provenance breakdown.
3. Deduplicated unique (target, config, workload) profile counts vs. archived runs.
4. Cross-commit cycle reproducibility when identical profiles exist across multiple commits.
Writes a machine-readable audit report to benchmarks/audit_summary.json.
"""

from __future__ import annotations

import json
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TIERS = ["core", "app", "vector", "soc"]
VALID_EVIDENCE = {"score_measured", "literature_reported", "literature_calibrated"}


def extract_cycles(metrics: dict) -> int | None:
    for k in (
        "total_cycles",
        "benchmark_cycles",
        "total_simulation_cycles",
        "simulation_cycles",
        "execution_cycles",
        "kernel_cycles",
    ):
        if metrics.get(k) is not None:
            try:
                return int(metrics[k])
            except (TypeError, ValueError):
                pass
    return None


def audit() -> tuple[dict, int]:
    summary: dict = {
        "schema": "score.benchmark_audit.v1",
        "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "tiers": {},
        "totals": {},
        "cross_commit_checks": [],
        "schema_issues": [],
    }

    total_runs = 0
    total_unique = 0
    total_measured = 0
    total_lit = 0
    all_sims: Counter[str] = Counter()

    for tier in TIERS:
        path = ROOT / "benchmarks" / tier / "aggregated_results.json"
        doc = json.loads(path.read_text())
        rows = doc.get("results", [])

        ev_counts: Counter[str] = Counter()
        sim_counts: Counter[str] = Counter()
        targets: set[str] = set()
        seen: dict[tuple[str, str, str], list[dict]] = {}

        for idx, r in enumerate(rows):
            target = str(r.get("soc") or r.get("core") or r.get("target") or "unknown")
            cfg = str(r.get("config") or (r.get("metrics") or {}).get("configuration") or "default")
            wl = r.get("workload") or r.get("benchmark")
            ec = r.get("evidence_class")
            m = r.get("metrics") or {}
            sim = str(r.get("simulator") or m.get("simulator") or "verilator")

            targets.add(target)
            ev_counts[str(ec)] += 1
            sim_counts[sim] += 1
            all_sims[sim] += 1

            if ec not in VALID_EVIDENCE:
                summary["schema_issues"].append(
                    f"{tier}[{idx}] ({target}/{wl}): non-canonical evidence_class={ec!r}"
                )
            if not wl:
                summary["schema_issues"].append(
                    f"{tier}[{idx}] ({target}): missing workload field"
                )

            key = (target, cfg, str(wl))
            seen.setdefault(key, []).append(
                {
                    "commit": r.get("upstream_commit"),
                    "cycles": extract_cycles(m),
                    "path": r.get("_path"),
                }
            )

        # Cross-commit bit-exact reproducibility verification
        for key, entries in sorted(seen.items()):
            if len(entries) > 1:
                cyc_vals = [e["cycles"] for e in entries if e["cycles"] is not None]
                bit_exact = len(set(cyc_vals)) <= 1 and len(cyc_vals) == len(entries)
                summary["cross_commit_checks"].append(
                    {
                        "tier": tier,
                        "profile": "/".join(key),
                        "occurrences": len(entries),
                        "commits": [e["commit"] for e in entries],
                        "cycles": cyc_vals,
                        "bit_exact_match": bit_exact,
                    }
                )

        summary["tiers"][tier] = {
            "archived_runs": len(rows),
            "unique_profiles": len(seen),
            "targets": len(targets),
            "evidence_class": dict(ev_counts),
            "simulators": dict(sim_counts),
        }

        total_runs += len(rows)
        total_unique += len(seen)
        total_measured += ev_counts.get("score_measured", 0)
        total_lit += ev_counts.get("literature_reported", 0) + ev_counts.get("literature_calibrated", 0)

    summary["totals"] = {
        "archived_runs": total_runs,
        "unique_profiles": total_unique,
        "score_measured_runs": total_measured,
        "literature_reported_runs": total_lit,
        "simulators": dict(all_sims),
        "schema_issue_count": len(summary["schema_issues"]),
        "cross_commit_bit_exact_matches": sum(
            1 for c in summary["cross_commit_checks"] if c["bit_exact_match"]
        ),
        "cross_commit_total_pairs": len(summary["cross_commit_checks"]),
    }

    out = ROOT / "benchmarks" / "audit_summary.json"
    out.write_text(json.dumps(summary, indent=2) + "\n")
    return summary, len(summary["schema_issues"])


def main() -> None:
    summary, n_issues = audit()
    t = summary["totals"]
    print(
        f"SCORE Benchmark Audit: {t['archived_runs']} archived runs "
        f"({t['unique_profiles']} unique profiles) | "
        f"score_measured={t['score_measured_runs']}, "
        f"literature_reported={t['literature_reported_runs']} | "
        f"cross_commit_exact={t['cross_commit_bit_exact_matches']}/{t['cross_commit_total_pairs']} | "
        f"schema_issues={n_issues}"
    )
    for tier, info in summary["tiers"].items():
        print(
            f"  {tier:6s}: {info['archived_runs']:3d} runs ({info['unique_profiles']:2d} unique) | "
            f"{info['targets']:2d} targets | ev={info['evidence_class']} | sims={info['simulators']}"
        )
    if n_issues:
        for iss in summary["schema_issues"]:
            print("  ISSUE:", iss)
        sys.exit(1)


if __name__ == "__main__":
    main()
