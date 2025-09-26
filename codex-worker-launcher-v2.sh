#!/bin/bash
# Codex Worker Launcher v2 with Bash ID Integration
# Usage: ./codex-worker-launcher-v2.sh [reasoning_level] [output_type] "task description"

REASONING="${1:-low}"
OUTPUT_TYPE="${2:-workers}"  # workers, research, etc.
TASK="$3"

# Handle argument shifting
if [ $# -eq 2 ]; then
    REASONING="low"
    OUTPUT_TYPE="$1"
    TASK="$2"
elif [ $# -eq 1 ]; then
    REASONING="low"
    OUTPUT_TYPE="workers"
    TASK="$1"
fi

# Generate timestamp and temp filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TEMP_FILE=".catlab/${OUTPUT_TYPE}/${TIMESTAMP}_TEMP_codex_task.md"

echo "🚀 Launching Codex Worker v2"
echo "Reasoning: ${REASONING}"
echo "Output Type: ${OUTPUT_TYPE}"
echo "Task: ${TASK}"
echo "Temp file: ${TEMP_FILE}"

# Launch Codex in background and capture bash ID
echo "Launching background process..."
BASH_ID=$(bash -c "
codex exec -s danger-full-access -c model_reasoning_effort='${REASONING}' '${TASK}. Save output to: ${TEMP_FILE}' &
echo \$!
" 2>/dev/null | tail -1)

echo "📋 Background process started with bash ID: ${BASH_ID}"

# Create proper filename with real bash ID
FINAL_FILE=".catlab/${OUTPUT_TYPE}/${TIMESTAMP}_${BASH_ID}_codex_task.md"

# Wait for temp file to be created, then rename
echo "⏳ Waiting for output file creation..."
while [ ! -f "$TEMP_FILE" ]; do
    sleep 1
done

sleep 2  # Give it time to finish writing
mv "$TEMP_FILE" "$FINAL_FILE"

echo "✅ Task completed: ${FINAL_FILE}"