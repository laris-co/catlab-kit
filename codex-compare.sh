#!/bin/bash
# Codex Compare-Analyse Engine
# Provides comparative analysis via codex-research workers and synthesis.
# Supports foreground/background execution, reference tracking, and status monitoring.

set -o pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Globals initialised later
COMPARISON_TOPIC=""
REFERENCE_ID=""
TIMESTAMP=""
TASK_NAME=""
OUTPUT_FILE=""
STATUS_FILE=""
LOG_FILE=""
ITEM_A=""
ITEM_B=""
RUN_MODE="fg"
STATUS_MODE="fg"
USER_SUPPLIED_REF=false
CURRENT_PID=$$
LAST_STATUS=""

escape_json() {
    local input="$1"
    input="${input//\\/\\\\}"
    input="${input//\"/\\\"}"
    input="${input//$'\n'/\\n}"
    input="${input//$'\r'/\\r}"
    echo "$input"
}

write_status() {
    local status="$1"
    local message="${2:-}"
    local override_pid="$3"

    [ -n "$STATUS_FILE" ] || return 0

    local timestamp=$(date +"%Y-%m-%dT%H:%M:%S%z")
    local safe_message=$(escape_json "$message")
    local safe_topic=$(escape_json "$COMPARISON_TOPIC")
    local safe_item_a=$(escape_json "$ITEM_A")
    local safe_item_b=$(escape_json "$ITEM_B")
    local safe_output=$(escape_json "$OUTPUT_FILE")
    local safe_log=$(escape_json "$LOG_FILE")
    local pid_value

    if [ -n "$override_pid" ]; then
        pid_value="$override_pid"
    else
        pid_value="$CURRENT_PID"
    fi

    cat >"$STATUS_FILE" <<EOF
{
  "reference_id": "$REFERENCE_ID",
  "status": "$status",
  "message": "$safe_message",
  "timestamp": "$timestamp",
  "pid": $pid_value,
  "mode": "$STATUS_MODE",
  "topic": "$safe_topic",
  "items": {
    "item_a": "$safe_item_a",
    "item_b": "$safe_item_b"
  },
  "output_file": "$safe_output",
  "log_file": "$safe_log"
}
EOF

    LAST_STATUS="$status"
}

handle_exit() {
    local exit_code=$?
    trap - EXIT
    if [ $exit_code -ne 0 ] && [ -n "$STATUS_FILE" ] && [ "$LAST_STATUS" != "FAILED" ]; then
        write_status "FAILED" "Comparison terminated unexpectedly (exit code $exit_code)"
    fi
    exit $exit_code
}

handle_signal() {
    local signal="$1"
    if [ -n "$STATUS_FILE" ]; then
        write_status "FAILED" "Comparison interrupted by signal $signal"
    fi
    exit 130
}

trap 'handle_exit' EXIT
trap 'handle_signal INT' INT
trap 'handle_signal TERM' TERM

show_help() {
    cat <<'USAGE'
Usage: ./codex-compare.sh "Item A vs Item B" [options]

Options:
  --bg             Run comparison in background mode (non-blocking)
  --fg             Run comparison in foreground mode (default)
  --ref-id ID      Use existing reference ID (CMP_YYYYMMDD_HHMMSS_XXXX)
  -h, --help       Show this help message and exit

Examples:
  ./codex-compare.sh "PostgreSQL vs MySQL" --bg
  ./codex-compare.sh "React vs Vue" --fg
USAGE
}

parse_args() {
    local args=()
    while [ $# -gt 0 ]; do
        case "$1" in
            --bg)
                RUN_MODE="bg"
                shift
                ;;
            --fg)
                RUN_MODE="fg"
                shift
                ;;
            --ref-id)
                if [ -z "${2:-}" ]; then
                    echo "❌ Error: --ref-id requires an argument" >&2
                    exit 1
                fi
                REFERENCE_ID="$2"
                USER_SUPPLIED_REF=true
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            --)
                shift
                while [ $# -gt 0 ]; do
                    args+=("$1")
                    shift
                done
                ;;
            -*)
                echo "❌ Error: Unknown option $1" >&2
                exit 1
                ;;
            *)
                args+=("$1")
                shift
                ;;
        esac
    done

    if [ ${#args[@]} -eq 0 ]; then
        echo "❌ Error: Please provide comparison topic" >&2
        echo "Usage: ./codex-compare.sh \"Item A vs Item B\"" >&2
        exit 1
    fi

    COMPARISON_TOPIC="${args[*]}"
}

validate_topic() {
    if [[ "$COMPARISON_TOPIC" != *" vs "* ]]; then
        echo "❌ Error: Please use 'Item A vs Item B' format" >&2
        exit 1
    fi

    ITEM_A=${COMPARISON_TOPIC%% vs *}
    ITEM_B=${COMPARISON_TOPIC#* vs }
    ITEM_A=$(echo "$ITEM_A" | sed 's/^ *//;s/ *$//')
    ITEM_B=$(echo "$ITEM_B" | sed 's/^ *//;s/ *$//')

    if [ -z "$ITEM_A" ] || [ -z "$ITEM_B" ]; then
        echo "❌ Error: Unable to parse comparison items" >&2
        exit 1
    fi
}

generate_reference_id() {
    if [ "$USER_SUPPLIED_REF" = true ]; then
        if [[ ! "$REFERENCE_ID" =~ ^CMP_[0-9]{8}_[0-9]{6}_[A-Z0-9]{4}$ ]]; then
            echo "❌ Error: Invalid reference ID format" >&2
            exit 1
        fi
        local ref_body=${REFERENCE_ID#CMP_}
        TIMESTAMP=${ref_body%_*}
    else
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        local random_suffix
        random_suffix=$(head /dev/urandom | tr -dc 'A-Z0-9' | head -c 4)
        REFERENCE_ID="CMP_${TIMESTAMP}_${random_suffix}"
    fi
}

prepare_paths() {
    TASK_NAME=$(echo "$COMPARISON_TOPIC" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/__*/_/g' | sed 's/^_\|_$//g')
    OUTPUT_FILE=".catlab/research/${TIMESTAMP}_${REFERENCE_ID}_codex_comparison_${TASK_NAME}.md"
    STATUS_FILE=".catlab/workers/${REFERENCE_ID}_status.json"

    if [ -n "${CODEX_COMPARE_LOG_FILE:-}" ]; then
        LOG_FILE="$CODEX_COMPARE_LOG_FILE"
    else
        LOG_FILE=".catlab/logs/${REFERENCE_ID}.log"
    fi

    mkdir -p .catlab/research .catlab/workers .catlab/logs
}

print_header() {
    echo -e "${BLUE}🔍 Codex Compare-Analyse Engine${NC}"
    echo -e "${YELLOW}Topic:${NC} ${COMPARISON_TOPIC}"
    echo -e "${YELLOW}Item A:${NC} ${ITEM_A}"
    echo -e "${YELLOW}Item B:${NC} ${ITEM_B}"
    echo -e "${GREEN}Output:${NC} ${OUTPUT_FILE}"
    echo -e "${GREEN}Reference ID:${NC} ${REFERENCE_ID}"
    echo -e "${GREEN}Status File:${NC} ${STATUS_FILE}"
    if [ "$STATUS_MODE" = "bg" ]; then
        echo -e "${GREEN}Log:${NC} ${LOG_FILE}"
    fi
    echo "----------------------------------------"
}

run_research_workers() {
    echo "📊 Launching parallel research workers..."
    write_status "RESEARCHING" "Running codex-research workers"

    if [ ! -x ./codex-research.sh ]; then
        echo -e "${RED}❌ Error: ./codex-research.sh not found or not executable${NC}"
        write_status "FAILED" "codex-research.sh not found or not executable"
        return 1
    fi

    ./codex-research.sh "$ITEM_A" &
    local pid_a=$!
    ./codex-research.sh "$ITEM_B" &
    local pid_b=$!

    echo "⏳ Waiting for research completion..."
    wait $pid_a
    local status_a=$?
    wait $pid_b
    local status_b=$?

    if [ $status_a -ne 0 ] || [ $status_b -ne 0 ]; then
        echo -e "${RED}❌ Error: One or both research tasks failed${NC}"
        write_status "FAILED" "Research worker failure"
        return 1
    fi

    return 0
}

synthesize_comparison() {
    echo "🔄 Synthesizing comparison analysis..."
    write_status "SYNTHESIZING" "Synthesizing comparison output"

    codex exec -s danger-full-access \
      -c model_reasoning_effort="high" \
      "Create comprehensive comparison analysis: ${COMPARISON_TOPIC}

Based on research outputs in .catlab/research/ for '${ITEM_A}' and '${ITEM_B}', create:

# Comparative Analysis: ${ITEM_A} vs ${ITEM_B}

## Executive Summary
[Key differences and recommendations]

## Side-by-Side Comparison
| Feature | ${ITEM_A} | ${ITEM_B} |
|---------|-----------|-----------|
[Feature comparison table]

## Detailed Analysis

### ${ITEM_A}
[Strengths, weaknesses, use cases]

### ${ITEM_B}
[Strengths, weaknesses, use cases]

## Decision Matrix
[Scoring across key criteria]

## Recommendations
[When to use each option]

## References & Sources
[Direct URLs only - no markdown titles]

**INSTRUCTIONS**:
1. Use DIRECT URLs only in references (no markdown titles)
2. Create a balanced, evidence-backed comparison
3. Highlight scenarios favoring each option
4. Save output to: ${OUTPUT_FILE}"

    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}❌ Comparison synthesis failed with exit code: ${exit_code}${NC}"
        write_status "FAILED" "Synthesis failed with exit code ${exit_code}"
        return $exit_code
    fi

    return 0
}

run_comparison() {
    print_header
    write_status "STARTING" "Preparing comparison"

    if ! run_research_workers; then
        return 1
    fi

    if ! synthesize_comparison; then
        return 1
    fi

    echo "----------------------------------------"
    echo -e "${GREEN}✅ Comparison analysis completed${NC}"
    echo -e "${BLUE}📄 Check output: ${OUTPUT_FILE}${NC}"
    write_status "COMPLETED" "Comparison analysis completed successfully"
    return 0
}

launch_background_worker() {
    : >"$LOG_FILE"

    export CODEX_COMPARE_STATUS_MODE="bg"
    export CODEX_COMPARE_LOG_FILE="$LOG_FILE"

    nohup "$0" "$COMPARISON_TOPIC" --fg --ref-id "$REFERENCE_ID" >>"$LOG_FILE" 2>&1 &
    local bg_pid=$!
    disown $bg_pid 2>/dev/null || true

    write_status "STARTING" "Background comparison worker launched" "$bg_pid"

    echo -e "${GREEN}🚀 Background comparison launched${NC}"
    echo -e "${GREEN}Reference ID:${NC} ${REFERENCE_ID}"
    echo -e "${GREEN}Worker PID:${NC} ${bg_pid}"
    echo -e "${GREEN}Status File:${NC} ${STATUS_FILE}"
    echo -e "${GREEN}Log:${NC} ${LOG_FILE}"
    echo -e "${GREEN}Output (when ready):${NC} ${OUTPUT_FILE}"
}

main() {
    parse_args "$@"

    STATUS_MODE="${CODEX_COMPARE_STATUS_MODE:-$RUN_MODE}"

    validate_topic
    generate_reference_id
    prepare_paths

    if [ "$RUN_MODE" = "bg" ] && [ -z "${CODEX_COMPARE_STATUS_MODE:-}" ]; then
        launch_background_worker
        return 0
    fi

    run_comparison
}

main "$@"
