#!/bin/bash
# Codex Worker Launcher with Flat Output Structure
# Usage: ./codex-worker-launcher.sh [reasoning_level] "task description"

REASONING="${1:-low}"
TASK="${2:-$1}"

if [ $# -eq 1 ]; then
    REASONING="low"
fi

# Generate timestamp prefix
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Output will be saved with this prefix
OUTPUT_PREFIX=".catlab/workers/${TIMESTAMP}"

echo "🚀 Launching Codex Worker"
echo "Timestamp: ${TIMESTAMP}"
echo "Reasoning: ${REASONING}"
echo "Task: ${TASK}"
echo "Output prefix: ${OUTPUT_PREFIX}"

# The bash ID will be captured when running in background
# Files will be named: ${TIMESTAMP}_${BASH_ID}_output.txt