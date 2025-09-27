#!/bin/bash
# /research slash command implementation
# This file is executed when user types /research

# Get the research topic from command arguments
RESEARCH_TOPIC="$*"

# Create timestamp for log file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE=".catlab/workers/research_${TIMESTAMP}.log"

# Ensure directories exist
mkdir -p .catlab/research .catlab/workers

# Execute the main research script in background with all output redirected
nohup ./slash-research.sh "$RESEARCH_TOPIC" > "$LOG_FILE" 2>&1 &

# Get the background job ID
BASH_ID=$!

# Provide immediate feedback
echo "🚀 Research launched in background (PID: $BASH_ID)"
echo "📁 Output will be saved to: .catlab/research/"
echo "📋 Log file: $LOG_FILE"
echo "💡 Monitor with: tail -f .catlab/research/*.md"
echo ""
echo "📚 Research topic: $RESEARCH_TOPIC"
echo "⏳ This will run in background and save results when complete."