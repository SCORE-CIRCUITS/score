#!/usr/bin/env bash
# SCORE install for ucb-bar/hwacha (Decoupled Vector-Fetch Coprocessor).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RELATIVE_SUBMODULE_PATH="tools/hwacha"
TOOL_DIR="$PROJECT_ROOT/$RELATIVE_SUBMODULE_PATH"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_hwacha
source "$SCRIPT_DIR/common_simple_rtl.sh"

cd "$PROJECT_ROOT"

if [[ ! -d "$TOOL_DIR/src" ]]; then
    log_info "Cloning hwacha..."
    git clone --depth 1 https://github.com/ucb-bar/hwacha.git "$TOOL_DIR"
fi

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
log_success "hwacha ready at $TOOL_DIR ($COMMIT_ID)"
