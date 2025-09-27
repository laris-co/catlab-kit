#!/bin/bash
# /research Slash Command Implementation
# Advanced web research with Codex CLI, parallel execution, and GitHub integration
# Usage: ./slash-research.sh "topic" [--parallel N] [--worktree branch]

set -e

# Source Codex GitHub environment if available
if [ -f ".codex/.env.github" ]; then
  source .codex/.env.github
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Parse arguments
RESEARCH_TOPIC=""
PARALLEL_COUNT=1
WORKTREE_BRANCH=""
REASONING_LEVEL="medium"

while [[ $# -gt 0 ]]; do
  case $1 in
    --parallel)
      PARALLEL_COUNT="$2"
      shift 2
      ;;
    --worktree)
      WORKTREE_BRANCH="$2"
      shift 2
      ;;
    --reasoning)
      REASONING_LEVEL="$2"
      shift 2
      ;;
    *)
      if [ -z "$RESEARCH_TOPIC" ]; then
        RESEARCH_TOPIC="$1"
      fi
      shift
      ;;
  esac
done

# Validate input
if [ -z "$RESEARCH_TOPIC" ]; then
  echo -e "${RED}❌ Error: Please provide a research topic${NC}"
  echo "Usage: ./slash-research.sh \"topic\" [--parallel N] [--worktree branch]"
  exit 1
fi

# Setup environment
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME=$(echo "$RESEARCH_TOPIC" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/__*/_/g' | sed 's/^_\|_$//g')
RESEARCH_DIR=".catlab/research"
WORKERS_DIR=".catlab/workers"

# Create directories
mkdir -p "$RESEARCH_DIR"
mkdir -p "$WORKERS_DIR"

# Display configuration
echo -e "${CYAN}🚀 /research Command Initialized${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📚 Topic:${NC} $RESEARCH_TOPIC"
echo -e "${YELLOW}🔧 Parallel Workers:${NC} $PARALLEL_COUNT"
echo -e "${YELLOW}🧠 Reasoning Level:${NC} $REASONING_LEVEL"
if [ -n "$WORKTREE_BRANCH" ]; then
  echo -e "${YELLOW}🌳 Worktree Branch:${NC} $WORKTREE_BRANCH"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Initialize worker registry
REGISTRY_FILE="$WORKERS_DIR/worker_registry.json"
if [ ! -f "$REGISTRY_FILE" ]; then
  echo '{"research_workers": []}' > "$REGISTRY_FILE"
fi

# Function to launch research worker
launch_research_worker() {
  local WORKER_ID="$1"
  local TOPIC="$2"
  local WORKER_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  local WORKER_TASK=$(echo "$TOPIC" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]')
  local OUTPUT_FILE="$RESEARCH_DIR/${WORKER_TIMESTAMP}_BASHID_${WORKER_TASK}.md"

  echo -e "${GREEN}🔍 Launching Worker ${WORKER_ID}: ${TOPIC}${NC}" >&2

  # Research prompt with comprehensive structure
  local RESEARCH_PROMPT="Research: ${TOPIC}

Create a comprehensive markdown report with the following structure:

# Research Report: ${TOPIC}

## Executive Summary
Provide a 2-3 sentence overview of the key findings and implications.

## Key Findings
- List the most important discoveries
- Focus on actionable insights
- Include data points where relevant

## Detailed Analysis

### Core Concepts
Explain fundamental concepts and terminology.

### Current State
Describe the current landscape, trends, and adoption.

### Technical Specifications
Include versions, requirements, compatibility notes, and technical details.

### Comparative Analysis
Compare different approaches, tools, or solutions if applicable.

### Best Practices
List recommended practices and patterns.

### Common Pitfalls
Identify common mistakes and how to avoid them.

## Implementation Considerations

### Getting Started
Step-by-step guide for implementation.

### Integration Points
How this integrates with existing systems.

### Performance Implications
Performance characteristics and optimization tips.

## Real-World Examples
Include concrete examples and use cases.

## Future Outlook
Trends and future developments to watch.

## References & Sources
**CRITICAL REQUIREMENT**: Include FULL URLs for all sources.
- [Official Documentation](https://complete-url-here.com)
- [Research Paper/Article](https://full-url-with-domain.com)
- [Tutorial/Guide](https://exact-url-no-shortcuts.com)
- Include publication dates where available
- Prioritize official and authoritative sources

## Conclusion
Summarize findings and provide actionable recommendations.

**IMPORTANT INSTRUCTIONS**:
1. Replace BASHID in filename '${OUTPUT_FILE}' with your actual process/bash ID
2. All URLs must be complete and clickable (starting with https://)
3. Verify all technical claims with reliable sources
4. Focus on practical, actionable information
5. Use web search to find the most current information

Save your complete report to: ${OUTPUT_FILE}

**GITHUB INTEGRATION**:
After creating the research report:
1. Create a new git branch: codex-research-${WORKER_TIMESTAMP}
2. Add and commit the research file
3. Push to GitHub and create a PR with title: 'research: ${TOPIC}'
4. Include in PR description: 'AI-powered research report generated by Codex CLI'
Use these commands:
git checkout -b codex-research-${WORKER_TIMESTAMP}
git add ${OUTPUT_FILE}
git commit -m \"research: ${TOPIC}\"
git push -u origin codex-research-${WORKER_TIMESTAMP}
gh pr create --title \"Research: ${TOPIC}\" --body \"AI-powered research report\""

  # Execute Codex with web search (redirect all output to log file)
  LOG_FILE="$WORKERS_DIR/${WORKER_TIMESTAMP}_${WORKER_TASK}.log"
  codex exec -s danger-full-access \
    -c 'tools.web_search=true' \
    -c "model_reasoning_effort=${REASONING_LEVEL}" \
    "$RESEARCH_PROMPT" > "$LOG_FILE" 2>&1 &

  local BASH_ID=$!

  # Update worker registry
  local REGISTRY_ENTRY="{\"bash_id\": \"$BASH_ID\", \"timestamp\": \"$WORKER_TIMESTAMP\", \"topic\": \"$TOPIC\", \"status\": \"running\", \"output\": \"$OUTPUT_FILE\"}"

  # Add to registry (using jq if available, otherwise simple append)
  if command -v jq &> /dev/null; then
    jq ".research_workers += [$REGISTRY_ENTRY]" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp" && mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
  else
    # Simple append for systems without jq
    echo "$REGISTRY_ENTRY" >> "$REGISTRY_FILE.entries"
  fi

  echo -e "${CYAN}  └─ Worker PID: ${BASH_ID}${NC}" >&2
  echo -e "${CYAN}  └─ Output: ${OUTPUT_FILE}${NC}" >&2

  echo $BASH_ID
}

# Setup worktree if requested
if [ -n "$WORKTREE_BRANCH" ]; then
  echo -e "\n${MAGENTA}🌳 Setting up Git Worktree${NC}"
  WORKTREE_PATH=".catlab/worktrees/${WORKTREE_BRANCH}"

  # Check if worktree already exists
  if [ -d "$WORKTREE_PATH" ]; then
    echo -e "${YELLOW}  └─ Worktree exists, using existing${NC}"
  else
    git worktree add "$WORKTREE_PATH" -b "$WORKTREE_BRANCH" 2>/dev/null || \
    git worktree add "$WORKTREE_PATH" "$WORKTREE_BRANCH" 2>/dev/null || {
      echo -e "${RED}  └─ Failed to create worktree${NC}"
      WORKTREE_BRANCH=""
    }
    echo -e "${GREEN}  └─ Created worktree: ${WORKTREE_PATH}${NC}"
  fi
fi

# Launch main research task
echo -e "\n${BLUE}🚀 Launching Research Workers${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

MAIN_PID=$(launch_research_worker "MAIN" "$RESEARCH_TOPIC")

# Launch parallel workers if requested
declare -a WORKER_PIDS=("$MAIN_PID")

if [ $PARALLEL_COUNT -gt 1 ]; then
  echo -e "\n${YELLOW}🔀 Launching ${PARALLEL_COUNT} Parallel Workers${NC}"

  # Define different research aspects
  ASPECTS=(
    "technical implementation and architecture"
    "performance benchmarks and optimization"
    "community adoption and ecosystem"
    "comparison with alternatives"
    "best practices and patterns"
    "security considerations"
    "migration strategies"
    "cost analysis and ROI"
  )

  for ((i=1; i<$PARALLEL_COUNT && i<${#ASPECTS[@]}; i++)); do
    ASPECT="${ASPECTS[$i]}"
    SUB_TOPIC="${RESEARCH_TOPIC} - Focus: ${ASPECT}"
    SUB_PID=$(launch_research_worker "P$i" "$SUB_TOPIC")
    WORKER_PIDS+=($SUB_PID)
  done
fi

# Monitor progress
echo -e "\n${YELLOW}⏳ Research in Progress${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Monitoring ${#WORKER_PIDS[@]} workers...${NC}"
echo -e "${CYAN}Check progress with: tail -f ${RESEARCH_DIR}/*.md${NC}"

# Wait for all workers
COMPLETED=0
FAILED=0

for PID in "${WORKER_PIDS[@]}"; do
  if wait $PID 2>/dev/null; then
    ((COMPLETED++))
    echo -e "${GREEN}✅ Worker $PID completed successfully${NC}"
  else
    ((FAILED++))
    echo -e "${YELLOW}⚠️ Worker $PID finished with warnings${NC}"
  fi
done

echo -e "\n${GREEN}📊 Research Complete${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}✅ Completed: ${COMPLETED}${NC}"
if [ $FAILED -gt 0 ]; then
  echo -e "${YELLOW}⚠️ With Warnings: ${FAILED}${NC}"
fi

# Aggregate results if parallel execution
if [ $PARALLEL_COUNT -gt 1 ]; then
  echo -e "\n${MAGENTA}📑 Aggregating Parallel Research${NC}"
  AGGREGATE_FILE="$RESEARCH_DIR/${TIMESTAMP}_aggregate_${TASK_NAME}.md"

  {
    echo "# Aggregated Research Report: ${RESEARCH_TOPIC}"
    echo ""
    echo "**Generated**: $(date)"
    echo "**Workers**: ${PARALLEL_COUNT}"
    echo "**Reasoning Level**: ${REASONING_LEVEL}"
    echo ""
    echo "---"
    echo ""
  } > "$AGGREGATE_FILE"

  # Find and combine all research outputs
  for file in "$RESEARCH_DIR"/*_${TASK_NAME}*.md "$RESEARCH_DIR"/*parallel*.md 2>/dev/null; do
    if [ -f "$file" ] && [ "$file" != "$AGGREGATE_FILE" ]; then
      echo "## Section: $(basename $file .md)" >> "$AGGREGATE_FILE"
      echo "" >> "$AGGREGATE_FILE"
      cat "$file" >> "$AGGREGATE_FILE"
      echo -e "\n---\n" >> "$AGGREGATE_FILE"
    fi
  done

  echo -e "${GREEN}  └─ Aggregate report: ${AGGREGATE_FILE}${NC}"
fi

# Create PR if worktree was used
if [ -n "$WORKTREE_BRANCH" ]; then
  echo -e "\n${MAGENTA}🔀 Creating Pull Request${NC}"

  cd "$WORKTREE_PATH" || exit 1

  # Copy research files to worktree
  cp -r "../../$RESEARCH_DIR" ".catlab/" 2>/dev/null || mkdir -p ".catlab/research"

  # Commit changes
  git add -A
  git commit -m "research: ${RESEARCH_TOPIC}

- Comprehensive web research with ${PARALLEL_COUNT} worker(s)
- Full URL references included
- Reasoning level: ${REASONING_LEVEL}
- Generated by /research slash command

Co-Authored-By: Codex <noreply@anthropic.com>" || {
    echo -e "${YELLOW}  └─ No changes to commit${NC}"
  }

  # Push and create PR
  git push -u origin "$WORKTREE_BRANCH" 2>/dev/null && {
    gh pr create \
      --title "📚 Research: ${RESEARCH_TOPIC}" \
      --body "## Research Report

### Overview
Automated research conducted via \`/research\` slash command.

### Configuration
- **Topic**: ${RESEARCH_TOPIC}
- **Parallel Workers**: ${PARALLEL_COUNT}
- **Reasoning Level**: ${REASONING_LEVEL}
- **Timestamp**: ${TIMESTAMP}

### Files Generated
- Research reports in \`.catlab/research/\`
- Worker registry in \`.catlab/workers/\`

### Method
- Codex CLI with \`tools.web_search=true\`
- Parallel execution for comprehensive coverage
- Full URL citations for all sources

### Review Checklist
- [ ] All URLs are complete and functional
- [ ] Research covers requested topic comprehensively
- [ ] Sources are authoritative and current
- [ ] Conclusions are actionable

Generated with ❤️ by Claude + Codex" \
      --assignee "@me" || echo -e "${YELLOW}  └─ PR already exists or creation failed${NC}"

    echo -e "${GREEN}  └─ Pull request created/updated${NC}"
  }

  cd - > /dev/null
fi

# Final summary
echo -e "\n${GREEN}✨ /research Command Completed Successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}📁 Research outputs: ${RESEARCH_DIR}/${NC}"
echo -e "${CYAN}📊 Worker registry: ${WORKERS_DIR}/worker_registry.json${NC}"
if [ -n "$WORKTREE_BRANCH" ]; then
  echo -e "${CYAN}🌳 Worktree: .catlab/worktrees/${WORKTREE_BRANCH}${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${MAGENTA}💡 Next Steps:${NC}"
echo "1. Review research reports in ${RESEARCH_DIR}/"
echo "2. Check worker status: cat ${WORKERS_DIR}/worker_registry.json"
if [ -n "$AGGREGATE_FILE" ]; then
  echo "3. Read aggregate report: ${AGGREGATE_FILE}"
fi
if [ -n "$WORKTREE_BRANCH" ]; then
  echo "4. Review and merge PR for branch: ${WORKTREE_BRANCH}"
fi

exit 0