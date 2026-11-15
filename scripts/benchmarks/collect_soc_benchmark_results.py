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
    "occamy",
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
        profile = doc.get("profile", "")
        if core in SOC_PLATFORMS or "soc" in profile:
            doc["_path"] = str(path.relative_to(ROOT))
            rows.append(doc)
    return rows


def main() -> None:
    rows = collect()
    payload = {
        "schema": "score.benchmark_aggregated.v1",
        "category": "Full SoC Platforms & Multi-Core Clusters",
        "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "count": len(rows),
        "results": rows,
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"Wrote {len(rows)} result(s) → {OUT}")


if __name__ == "__main__":
    main()
