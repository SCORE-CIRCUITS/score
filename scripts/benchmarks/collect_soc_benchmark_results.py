#!/usr/bin/env python3
"""Collect score.benchmark_results.v1 JSON files for full SoC platforms into benchmarks/soc/aggregated_results.json."""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DATASETS = ROOT / "datasets"
OUT = ROOT / "benchmarks" / "soc" / "aggregated_results.json"
SOC_PLATFORMS = {
    "cheshire",
    "cheshire-ihp130-o",
    "cheshire_ihp130_o",
    "mempool",
    "croc",
    "pulpissimo",
    "hero",
    "openpiton",
    "snitch-cluster",
    "snitch_cluster",
    "araxl",
    "iob-soc",
    "iob_soc",
    "carfield",
    "astral",
    "occamy",
    "safety-island",
    "safety_island",
    "pulp-cluster",
    "pulp_cluster",
    "pulp-soc",
    "pulp_soc",
    "chimera",
    "magia",
    "picobello",
    "opentitan",
    "soc-automation",
    "soc_automation",
    "auteur",
    "rv-tracer",
    "rv_tracer",
}


def collect() -> list[dict]:
    rows: list[dict] = []
    if not DATASETS.is_dir():
        return rows
    for path in sorted(DATASETS.glob("*/**/benchmarks/*.json")):
        try:
            doc = json.loads(path.read_text())
        except json.JSONDecodeError:
            continue
        if doc.get("schema") != "score.benchmark_results.v1":
            continue
        core = doc.get("core", "")
        soc = doc.get("soc", "")
        profile = doc.get("profile", "")
        parent_soc = path.parts[-4] if len(path.parts) >= 4 else ""
        if (
            core in SOC_PLATFORMS
            or soc in SOC_PLATFORMS
            or parent_soc in SOC_PLATFORMS
            or "soc" in profile
        ):
            if not doc.get("soc") and parent_soc:
                doc["soc"] = parent_soc
            if not doc.get("workload"):
                doc["workload"] = path.stem
            # Normalize legacy/omitted evidence_class into canonical schema enum
            ec = doc.get("evidence_class")
            if ec in (None, "", "simulated", "empirical_simulation"):
                m = doc.get("metrics") or {}
                has_cycles = any(
                    m.get(k) is not None
                    for k in ("execution_cycles", "total_simulation_cycles", "simulation_cycles")
                )
                has_wall = m.get("wall_time_s") is not None or m.get("wall_time_sec") is not None
                if has_cycles and has_wall:
                    doc["evidence_class"] = "score_measured"
            doc["_path"] = str(path.relative_to(ROOT))
            rows.append(doc)
    return rows


def main() -> None:
    rows = collect()
    unique_keys = {
        (r.get("soc") or r.get("core") or "", r.get("config") or "", r.get("workload") or "")
        for r in rows
    }
    payload = {
        "schema": "score.benchmark_aggregated.v1",
        "category": "Full SoC Platforms & Multi-Core Clusters",
        "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "count": len(rows),
        "unique_count": len(unique_keys),
        "results": rows,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"Wrote {len(rows)} result(s) ({len(unique_keys)} unique) → {OUT}")


if __name__ == "__main__":
    main()
