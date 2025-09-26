# Research Command (rrr)

Execute a Codex research task with web search and structured output.

## Usage
```
rrr "research topic"
```

## Example
```
rrr "Next.js 15 performance improvements"
rrr "Comparison between PostgreSQL and MySQL for web apps"
```

## What this command does

I will launch a Codex worker with web search enabled to research your topic and create a comprehensive markdown report with:

- **Executive Summary**: Brief overview
- **Key Findings**: Main discoveries
- **Technical Specifications**: Versions, requirements, etc.
- **References & Sources**: **CRITICAL** - Full URLs for all sources
- **Conclusion**: Summary and recommendations

The output will be saved to `.catlab/research/` with proper naming:
`YYYYMMDD_HHMMSS_ProcessID_codex_topic.md`

## Key Features

✅ **Web search enabled** - Gets latest information
✅ **Structured output** - Consistent report format
✅ **Full URL references** - Complete, clickable links
✅ **Process ID tracking** - Full traceability
✅ **Medium reasoning** - Balanced depth and speed

## Command executed
```bash
# Simple usage with codex-research script
./codex-research "your research topic"

# Or manually with full command
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME="${user_input_sanitized}"
OUTPUT_FILE=".catlab/research/${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md"

codex exec -s danger-full-access \
  -c 'tools.web_search=true' \
  -c model_reasoning_effort="medium" \
  "[Structured research prompt with mandatory URLs]"
```

## codex-research Script
The `codex-research` script simplifies research execution:

```bash
# Usage examples
./codex-research "Next.js 15 performance improvements"
./codex-research "PostgreSQL vs MySQL for web applications"
./codex-research "Docker container optimization best practices"
```

Features:
- ✅ Automatic topic sanitization for filenames
- ✅ Structured research prompt with mandatory URLs
- ✅ Color-coded output with progress indicators
- ✅ PLACEHOLDER → process ID replacement
- ✅ Automatic directory creation

Research results will include complete URLs for all sources referenced!