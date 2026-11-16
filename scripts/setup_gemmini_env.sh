#!/bin/bash
# Gemmini Environment Setup Script
# Source this script to set up the Gemmini development environment:
#   source scripts/setup_gemmini_env.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOLS_DIR="$PROJECT_ROOT/tools"
GEMMINI_DIR="$TOOLS_DIR/gemmini"
WORKSHOP_DIR="${SCORE_GEMMINI_WORKSHOP:-$PROJECT_ROOT/datasets/gemmini/workshop}"
CHIPYARD_DIR="$WORKSHOP_DIR/chipyard"

# Chipyard env expects `conda` on PATH (install_gemmini.sh may install Miniconda here).
if [[ -x "$WORKSHOP_DIR/chipyard/.conda-env/bin/conda" ]]; then
    export PATH="$WORKSHOP_DIR/chipyard/.conda-env/bin:$PATH"
elif [[ -x "$WORKSHOP_DIR/miniconda3/bin/conda" ]]; then
    export PATH="$WORKSHOP_DIR/miniconda3/bin:$PATH"
fi

echo "Setting up Gemmini development environment..."

# Set Gemmini environment variables
export GEMMINI_ROOT="$GEMMINI_DIR"

# Add local bin to PATH
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Add Verilator to PATH if installed locally
if [[ -d "$TOOLS_DIR/verilator-install/bin" ]]; then
    export PATH="$TOOLS_DIR/verilator-install/bin:$PATH"
fi

# Add SBT to PATH if installed locally
if [[ -d "$TOOLS_DIR/sbt/bin" ]]; then
    export PATH="$TOOLS_DIR/sbt/bin:$PATH"
fi

# Source Chipyard environment if available
export RISCV="${RISCV:-}"
if [[ -f "$CHIPYARD_DIR/env.sh" ]]; then
    echo "Loading Chipyard environment..."
    cd "$CHIPYARD_DIR"
    source "env.sh"
    # Spike / libgemmini expect RISCV; Chipyard installs collateral under CONDA_PREFIX/riscv-tools.
    if [[ -z "${RISCV:-}" && -n "${CONDA_PREFIX:-}" && -d "${CONDA_PREFIX}/riscv-tools/include" ]]; then
        export RISCV="${CONDA_PREFIX}/riscv-tools"
    fi
    # Prefer system Java 11 over conda JVM
    if [[ -d "/usr/lib/jvm/java-11-openjdk" ]]; then
        export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
        export PATH="$JAVA_HOME/bin:/usr/local/bin:$PATH"
    fi
    cd "$PROJECT_ROOT"
else
    echo "⚠️  Chipyard environment not found at: $CHIPYARD_DIR/env.sh"
fi

echo ""
echo "=== Gemmini Environment Status ==="

# Check Gemmini availability
if [[ -d "$GEMMINI_DIR" && -f "$GEMMINI_DIR/build.sbt" ]]; then
    echo "✅ Gemmini: Available in $GEMMINI_DIR"
    if [[ -f "$GEMMINI_DIR/build.sbt" ]]; then
        gemmini_version=$(grep 'version := ' "$GEMMINI_DIR/build.sbt" | sed 's/.*"\(.*\)".*/\1/')
        echo "  Version: $gemmini_version"
    fi
else
    echo "❌ Gemmini: Not found or not initialized"
fi

# Check Chipyard availability
if [[ -d "$CHIPYARD_DIR" && -f "$CHIPYARD_DIR/env.sh" ]]; then
    echo "✅ Chipyard: Available in $CHIPYARD_DIR"
else
    echo "⚠️  Chipyard: Not found in workshop directory"
fi

# Check tools
if command -v java >/dev/null 2>&1; then
    java_version=$(java -version 2>&1 | head -1)
    echo "✅ Java: $java_version"
else
    echo "❌ Java: Not found"
fi

if command -v sbt >/dev/null 2>&1; then
    sbt_version=$(/usr/local/bin/sbt --version 2>/dev/null | grep "sbt version" | awk '{print $4}' || echo "installed")
    echo "✅ SBT: $sbt_version"
else
    echo "❌ SBT: Not found"
fi

if command -v verilator >/dev/null 2>&1; then
    verilator_version=$(verilator --version 2>/dev/null | head -1)
    echo "✅ Verilator: $verilator_version"
else
    echo "⚠️  Verilator: Not found (optional)"
fi

echo ""
if [[ -d "$GEMMINI_DIR" ]] && command -v java >/dev/null 2>&1 && command -v sbt >/dev/null 2>&1; then
    echo "🎉 Gemmini environment ready!"
    echo "You can now run: ./scripts/generate_gemmini.sh"
else
    echo "⚠️  Gemmini environment incomplete. Run: ./scripts/install_gemmini.sh"
fi
