#!/usr/bin/env bash
# SCORE install for vproc/vicuna (Compact Embedded RISC-V Vector Coprocessor).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RELATIVE_SUBMODULE_PATH="tools/vicuna"
TOOL_DIR="$PROJECT_ROOT/$RELATIVE_SUBMODULE_PATH"

INSTALL_SYSTEM_DEPS=true
CHECK_ONLY=false
INSTALL_VERILATOR=true

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_vicuna
source "$SCRIPT_DIR/common_simple_rtl.sh"

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]
Initialize tools/vicuna (https://github.com/vproc/vicuna).
  --check-only        Verify directory and files without installing
  --no-system-deps    Skip system package installation
  --no-verilator      Skip Verilator installation
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) show_help; exit 0 ;;
        --check-only) CHECK_ONLY=true; shift ;;
        --no-system-deps) INSTALL_SYSTEM_DEPS=false; shift ;;
        --no-verilator) INSTALL_VERILATOR=false; shift ;;
        *) log_error "Unknown option: $1"; exit 1 ;;
    esac
done

cd "$PROJECT_ROOT"

if [[ "$CHECK_ONLY" == true ]]; then
    [[ -d "$TOOL_DIR/rtl" ]] || { log_error "Missing $TOOL_DIR/rtl"; exit 1; }
    log_success "vicuna OK"; exit 0
fi

[[ "$INSTALL_SYSTEM_DEPS" == true ]] && score_simple_install_host_deps "$INSTALL_VERILATOR" || true

if [[ ! -d "$TOOL_DIR/rtl" ]]; then
    log_info "Cloning vicuna..."
    git clone --depth 1 https://github.com/vproc/vicuna.git "$TOOL_DIR"
fi

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
log_success "vicuna ready at $TOOL_DIR ($COMMIT_ID)"
