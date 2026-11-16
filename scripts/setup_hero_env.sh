#!/bin/bash
# HERO Environment Setup Script
# Source this script to set up the HERO development environment:
#   source scripts/setup_hero_env.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOLS_DIR="$PROJECT_ROOT/tools"
HERO_DIR="$TOOLS_DIR/hero"

echo "Setting up HERO development environment..."

# Set HERO environment variables
export HERO_INSTALL="$TOOLS_DIR/hero-install"
export HERO_ROOT="$HERO_DIR"

# Add Rust and Cargo to PATH
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# Add local bin to PATH
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Add Verilator to PATH if installed locally
if [[ -d "$TOOLS_DIR/verilator-install/bin" ]]; then
    export PATH="$TOOLS_DIR/verilator-install/bin:$PATH"
fi

# Add HERO install directory to PATH
if [[ -d "$HERO_INSTALL/bin" ]]; then
    export PATH="$HERO_INSTALL/bin:$PATH"
fi

echo ""
echo "=== HERO Environment Status ==="

# Check HERO availability
if [[ -d "$HERO_DIR" && -f "$HERO_DIR/Makefile" ]]; then
    echo "✅ HERO: Available in $HERO_DIR"
    echo "  HERO_INSTALL: $HERO_INSTALL"
else
    echo "❌ HERO: Not found or not initialized"
fi

# Check tools
if command -v bender >/dev/null 2>&1; then
    bender_version=$(bender --version 2>/dev/null || echo "unknown")
    echo "✅ Bender: $bender_version"
else
    echo "❌ Bender: Not found"
fi

if command -v verilator >/dev/null 2>&1; then
    verilator_version=$(verilator --version 2>/dev/null | head -1)
    echo "✅ Verilator: $verilator_version"
else
    echo "⚠️  Verilator: Not found (optional)"
fi

if command -v rustc >/dev/null 2>&1; then
    rust_version=$(rustc --version)
    echo "✅ Rust: $rust_version"
else
    echo "❌ Rust: Not found (required for Bender)"
fi

echo ""
if [[ -d "$HERO_DIR" ]] && command -v bender >/dev/null 2>&1; then
    echo "🎉 HERO environment ready!"
    echo "You can now run: ./scripts/generate_hero.sh"
else
    echo "⚠️  HERO environment incomplete. Run: ./scripts/install_hero.sh"
fi
