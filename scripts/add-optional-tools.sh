#!/usr/bin/env bash
#
# Add or initialize optional RTL generation and HLS tools as submodules
# Repositories cover HLS frameworks, Meta-HDLs, and specialized register generators.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging add-optional-tools

# List of optional RTL generation tools:
# Format: "name primary_url fallback_url local_path category"
TOOLS_REGISTRY=(
    # High-Level Synthesis (HLS) Tools
    "xls https://github.com/SCORE-CIRCUITS/xls.git https://github.com/google/xls.git tools/xls HLS"
    "aha https://github.com/SCORE-CIRCUITS/aha.git https://github.com/StanfordAHA/aha.git tools/aha HLS"
    "bambu https://github.com/SCORE-CIRCUITS/PandA-bambu.git https://github.com/ferrandi/PandA-bambu.git tools/bambu HLS"
    "pipelinec https://github.com/SCORE-CIRCUITS/PipelineC.git https://github.com/JulianKemmerer/PipelineC.git tools/pipelinec HLS"

    # Hardware Construction Languages (Meta-HDLs)
    "amaranth https://github.com/SCORE-CIRCUITS/amaranth.git https://github.com/amaranth-lang/amaranth.git tools/amaranth Meta-HDL"
    "chisel https://github.com/SCORE-CIRCUITS/chisel.git https://github.com/chipsalliance/chisel.git tools/chisel Meta-HDL"
    "spinalhdl https://github.com/SCORE-CIRCUITS/SpinalHDL.git https://github.com/SpinalHDL/SpinalHDL.git tools/spinalhdl Meta-HDL"
    "myhdl https://github.com/SCORE-CIRCUITS/myhdl.git https://github.com/myhdl/myhdl.git tools/myhdl Meta-HDL"
    "pymtl3 https://github.com/SCORE-CIRCUITS/pymtl3.git https://github.com/pymtl/pymtl3.git tools/pymtl3 Meta-HDL"

    # Specialized RTL Generators
    "peakrdl https://github.com/SCORE-CIRCUITS/PeakRDL.git https://github.com/SystemRDL/PeakRDL.git tools/peakrdl Generator"
    "rggen https://github.com/SCORE-CIRCUITS/rggen.git https://github.com/rggen/rggen.git tools/rggen Generator"
)

SHALLOW=true
STATUS_ONLY=false
SELECTED_TARGETS=()

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [tool1 tool2 ...]

Manages and initializes optional RTL generation, HLS, and Meta-HDL tools.

Supported tools:
  HLS:          xls, aha, bambu, pipelinec
  Meta-HDLs:    amaranth, chisel, spinalhdl, myhdl, pymtl3
  Generators:   peakrdl, rggen

Options:
  -h, --help       Show this help message
  --no-shallow     Perform full git history clone instead of shallow (--depth 1)
  --status         Only display current checkout status of optional tools

Examples:
  $(basename "$0")                     # Add/init all optional tools (shallow)
  $(basename "$0") amaranth pipelinec  # Add/init only specific tools
  $(basename "$0") --status            # Show checkout status table
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        --no-shallow) SHALLOW=false; shift ;;
        --status) STATUS_ONLY=true; shift ;;
        -*) log_error "Unknown option: $1"; usage; exit 1 ;;
        *) SELECTED_TARGETS+=("$1"); shift ;;
    esac
done

if [[ "$STATUS_ONLY" == "true" ]]; then
    echo "=========================================================================================="
    printf "%-12s %-10s %-18s %-45s\n" "TOOL" "CATEGORY" "STATUS" "COMMIT / PATH"
    echo "=========================================================================================="
    for entry in "${TOOLS_REGISTRY[@]}"; do
        read -r NAME PRIMARY_URL FALLBACK_URL LOCAL_PATH CATEGORY <<< "$entry"
        ABS_PATH="$PROJECT_ROOT/$LOCAL_PATH"
        if [[ -d "$ABS_PATH" && -e "$ABS_PATH/.git" ]]; then
            COMMIT="$(git -C "$ABS_PATH" rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
            printf "%-12s %-10s \033[0;32m%-18s\033[0m %-45s\n" "$NAME" "$CATEGORY" "Initialized" "[$COMMIT] $LOCAL_PATH"
        elif [[ -d "$ABS_PATH" ]]; then
            printf "%-12s %-10s \033[0;33m%-18s\033[0m %-45s\n" "$NAME" "$CATEGORY" "Dir exists (no git)" "$LOCAL_PATH"
        else
            printf "%-12s %-10s \033[0;90m%-18s\033[0m %-45s\n" "$NAME" "$CATEGORY" "Not checked out" "$LOCAL_PATH"
        fi
    done
    echo "=========================================================================================="
    exit 0
fi

is_selected() {
    local target="$1"
    if [[ ${#SELECTED_TARGETS[@]} -eq 0 ]]; then
        return 0
    fi
    for s in "${SELECTED_TARGETS[@]}"; do
        if [[ "$s" == "$target" ]]; then
            return 0
        fi
    done
    return 1
}

log_info "Evaluating optional RTL generation tools..."

SUCCESS_COUNT=0
SKIPPED_COUNT=0
FAILURE_COUNT=0

for entry in "${TOOLS_REGISTRY[@]}"; do
    read -r NAME PRIMARY_URL FALLBACK_URL LOCAL_PATH CATEGORY <<< "$entry"

    if ! is_selected "$NAME"; then
        continue
    fi

    ABS_PATH="$PROJECT_ROOT/$LOCAL_PATH"

    if [[ -d "$ABS_PATH" && -e "$ABS_PATH/.git" ]]; then
        COMMIT="$(git -C "$ABS_PATH" rev-parse --short HEAD 2>/dev/null || echo 'HEAD')"
        log_success "[$CATEGORY] $NAME is already initialized at $LOCAL_PATH ($COMMIT)"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi

    log_info "[$CATEGORY] Adding submodule for $NAME -> $LOCAL_PATH"

    CLONE_OPTS=("-f")
    if [[ "$SHALLOW" == "true" ]]; then
        CLONE_OPTS+=("--depth" "1")
    fi

    # Try primary SCORE-CIRCUITS URL, fallback to upstream if unreachable
    ADD_OK=false
    if git -C "$PROJECT_ROOT" submodule add "${CLONE_OPTS[@]}" "$PRIMARY_URL" "$LOCAL_PATH"; then
        ADD_OK=true
    else
        log_warning "Primary URL failed; attempting upstream fallback: $FALLBACK_URL"
        if git -C "$PROJECT_ROOT" submodule add "${CLONE_OPTS[@]}" "$FALLBACK_URL" "$LOCAL_PATH"; then
            ADD_OK=true
        fi
    fi

    if [[ "$ADD_OK" == "true" ]]; then
        COMMIT="$(git -C "$ABS_PATH" rev-parse --short HEAD 2>/dev/null || echo 'HEAD')"
        log_success "[$CATEGORY] Successfully added $NAME ($COMMIT)"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        log_error "[$CATEGORY] Failed to add $NAME"
        FAILURE_COUNT=$((FAILURE_COUNT + 1))
    fi
done

echo ""
log_info "Optional Tools Summary: $SUCCESS_COUNT added, $SKIPPED_COUNT already present, $FAILURE_COUNT failed."
