#!/bin/bash
# Research Script - Simplified Codex Research with Web Search
# Usage: ./research.sh "research topic"
# Example: ./research.sh "Next.js 15 performance improvements"

# Check if topic is provided
if [ $# -eq 0 ]; then
    echo "❌ Error: Please provide a research topic"
    echo "Usage: ./research.sh \"your research topic\""
    echo "Example: ./research.sh \"PostgreSQL vs MySQL comparison\""
    exit 1
fi

# Get research topic and sanitize for filename
RESEARCH_TOPIC="$1"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME=$(echo "$RESEARCH_TOPIC" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/__*/_/g' | sed 's/^_\|_$//g')
OUTPUT_FILE=".catlab/research/${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md"

# Create output directory if it doesn't exist
mkdir -p .catlab/research

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Codex Research Engine${NC}"
echo -e "${YELLOW}Topic: ${RESEARCH_TOPIC}${NC}"
echo -e "${GREEN}Output: ${OUTPUT_FILE}${NC}"
echo "----------------------------------------"

# Execute Codex research with structured prompt
codex exec -s danger-full-access \
  -c 'tools.web_search=true' \
  -c model_reasoning_effort="medium" \
  "Research: ${RESEARCH_TOPIC}

Create a comprehensive markdown report with the following structure:

## Research Report: ${RESEARCH_TOPIC}

### Executive Summary
[Brief overview of the research topic]

### Key Findings
- Main discoveries and insights
- Important trends or developments
- Critical information points

### Technical Specifications
- Version numbers, requirements
- Compatibility information
- Technical details and specifications

### References & Sources
**CRITICAL**: Include FULL URLs for all sources referenced:
- [Source Name](https://complete-url-here)
- [Documentation](https://full-documentation-url)
- [Official Site](https://complete-official-url)
- [GitHub/Repository](https://complete-repo-url)

### Conclusion
[Summary and recommendations based on research]

**IMPORTANT INSTRUCTIONS**:
1. Replace PLACEHOLDER in filename '${OUTPUT_FILE}' with your process ID
2. Always include complete, clickable URLs starting with https:// in References section
3. Verify all links are full URLs with domains
4. Include publication dates where available
5. Prioritize official documentation and authoritative sources
6. Use web search to get the most current information
7. Structure the content for easy scanning and reference

Save output to: ${OUTPUT_FILE}"

# Capture exit code
EXIT_CODE=$?

echo "----------------------------------------"
if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Research completed successfully${NC}"
    echo -e "${BLUE}📄 Check output in: ${OUTPUT_FILE}${NC}"
else
    echo -e "${RED}❌ Research failed with exit code: $EXIT_CODE${NC}"
fi

exit $EXIT_CODE