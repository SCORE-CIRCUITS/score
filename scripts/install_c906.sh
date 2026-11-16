#!/usr/bin/env bash
# SCORE install for T-head-Semi/openc906 — Alibaba XuanTie C906 RV64GCV application core.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RELATIVE_SUBMODULE_PATH="tools/c906"
TOOL_DIR="$PROJECT_ROOT/$RELATIVE_SUBMODULE_PATH"
UPSTREAM_URL="https://github.com/T-head-Semi/openc906.git"
INSTALL_SYSTEM_DEPS=true
CHECK_ONLY=false
INSTALL_VERILATOR=true

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_c906
source "$SCRIPT_DIR/common_submodule_bootstrap.sh"
source "$SCRIPT_DIR/common_simple_rtl.sh"

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]
Initialize tools/c906 (https://github.com/T-head-Semi/openc906).
  --check-only  --no-system-deps  --no-verilator
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) show_help; exit 0 ;;
        --check-only) CHECK_ONLY=true; shift ;;
        --no-system-deps) INSTALL_SYSTEM_DEPS=false; shift ;;
        --no-verilator) INSTALL_VERILATOR=false; shift ;;
        *) log_error "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

cd "$PROJECT_ROOT"
if [[ "$CHECK_ONLY" == true ]]; then
    [[ -d "$TOOL_DIR/C906_RTL_FACTORY/gen_rtl" ]] || { log_error "Missing $TOOL_DIR/C906_RTL_FACTORY/gen_rtl"; exit 1; }
    log_success "c906 present: $(git -C "$TOOL_DIR" rev-parse --short HEAD 2>/dev/null || echo '?')"
    exit 0
fi

if [[ "$INSTALL_SYSTEM_DEPS" == true ]]; then
    score_simple_install_host_deps "$INSTALL_VERILATOR" || log_warning "Host deps install had errors; continuing"
else
    log_info "Skipping system deps"
fi

if [[ ! -d "$TOOL_DIR/.git" ]]; then
    log_info "Cloning XuanTie C906…"
    git clone --depth 1 "$UPSTREAM_URL" "$TOOL_DIR"
else
    score_prepare_tool_checkout "$PROJECT_ROOT" "$RELATIVE_SUBMODULE_PATH" || true
fi

[[ -d "$TOOL_DIR/C906_RTL_FACTORY/gen_rtl" ]] || { log_error "gen_rtl missing after checkout"; exit 1; }
[[ -d "$TOOL_DIR/smart_run" ]] || { log_error "smart_run missing after checkout"; exit 1; }
log_success "c906 ready at $TOOL_DIR ($(git -C "$TOOL_DIR" rev-parse --short HEAD))"
