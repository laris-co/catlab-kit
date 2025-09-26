# Claude-Codex Orchestrator/Worker Architecture

## 🔴 CRITICAL SAFETY NOTICE
**This architecture uses `danger-full-access` which grants UNRESTRICTED system access.**
- Only use in isolated development environments
- Never use in production without proper security measures
- Consider implementing file path whitelisting and permission models
- All examples shown are for development/testing only

## Quick Start

### Safe Execution Pattern (Tested & Verified)
```bash
# 1. Generate timestamp for traceability
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME="your_task_description"

# 2. Define output file with bash ID placeholder
OUTPUT_FILE=".catlab/workers/${TIMESTAMP}_BASHID_${TASK_NAME}.md"

# 3. Execute in background (returns bash_id for tracking)
codex exec -s danger-full-access \
  -c model_reasoning_effort="low" \
  "Your task here. Save output to: ${OUTPUT_FILE}"

# Background execution in Claude Code:
# run_in_background: true → Returns bash_id
# Track with BashOutput tool using bash_id
```

## Architecture Overview

### Paradigm: Claude as Orchestrator, Codex as Workers

#### Claude (Orchestrator)
**Primary Role**: High-level planning and coordination
- 🧠 Strategic planning and decision making
- 📋 All GitHub operations (`gh` CLI)
- 🎛️ Spawning and monitoring Codex workers
- 📊 Progress tracking via `BashOutput`
- 🔄 Aggregating results from multiple workers
- 🔍 Quality control and review

#### Codex (Workers)
**Primary Role**: Execution and implementation
- ⚙️ Code execution and analysis
- 📁 File operations (read, write, edit)
- 🔧 Implementation of features and fixes
- 🚀 Parallel processing capability
- 📈 Deep code analysis tasks
- 🧪 Testing and validation

## File Organization & Naming Convention

### Directory Structure
```
.catlab/                             # Hidden directory for catlab outputs
├── docs/                           # Documentation files
│   ├── NAMING_CONVENTION.md        # Naming guide
│   └── WORKFLOW_SUMMARY.md         # Workflow documentation
├── workers/                        # Worker outputs and registry
│   ├── worker_registry.json        # Bash ID → output mapping
│   └── {timestamp}_{bash_id}_{task}.ext # Output files
└── researchs/                      # Research outputs (existing)
```

### Naming Pattern
```
{YYYYMMDD}_{HHMMSS}_{bash_id}_{task_name}.{ext}
```
Example: `20250926_153721_c1282f_readme_analysis.md`

### Worker Registry Format
```json
{
  "active_workers": [{
    "bash_id": "c1282f",
    "timestamp": "20250926_153738",
    "task": "readme_analysis",
    "output_file": ".catlab/workers/20250926_153738_c1282f_readme_analysis.md",
    "status": "running"
  }]
}
```

## Implementation Patterns

### Single Worker Pattern
```bash
# Simple task delegation
codex exec -s danger-full-access \
  -c model_reasoning_effort="low" \
  "Analyze codebase and save findings to ${OUTPUT_FILE}"
```

### Parallel Workers Pattern
```bash
# Launch multiple workers simultaneously
# Worker 1: Frontend analysis
TIMESTAMP1=$(date +"%Y%m%d_%H%M%S")
codex exec -s danger-full-access "Analyze frontend" &  # → bash_id_1

# Worker 2: Backend analysis
TIMESTAMP2=$(date +"%Y%m%d_%H%M%S")
codex exec -s danger-full-access "Analyze backend" &   # → bash_id_2

# Worker 3: Test coverage
TIMESTAMP3=$(date +"%Y%m%d_%H%M%S")
codex exec -s danger-full-access "Check tests" &       # → bash_id_3

# Monitor with BashOutput tool using bash IDs
```

### Research Worker Pattern (Web Search)
```bash
# Research with web search and full URL references
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME="research_topic"
OUTPUT_FILE=".catlab/research/${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md"

codex exec -s danger-full-access \
  -c 'tools.web_search=true' \
  -c model_reasoning_effort="medium" \
  "Research [TOPIC]. Create comprehensive report with:

## Research Report: [TOPIC]
### Executive Summary
### Key Findings
### Technical Specifications
### References & Sources
**CRITICAL**: Include FULL URLs for all sources:
- [Source](https://complete-url.com)

**INSTRUCTIONS**:
1. Replace PLACEHOLDER in '${OUTPUT_FILE}' with process ID
2. Include complete URLs starting with https://
3. Prioritize official documentation

Save output to: ${OUTPUT_FILE}"
```

## Reasoning Levels & Performance

| Level | Use Case | Execution Time | When to Use |
|-------|----------|----------------|-------------|
| `minimal` | File listing, simple searches | ~5-10s | Basic file operations |
| `low` | Code formatting, simple refactoring | ~10-15s | Straightforward changes |
| `medium` | Feature implementation, bug fixes | ~15-25s | Standard development |
| `high` | Complex analysis, architecture | ~30-60s+ | Deep reasoning needed |

## Best Practices

### Safety First
1. **Never use `-f` or `--force` flags**
2. Use `rm -i` instead of `rm -f`
3. Implement proper error handling
4. Validate operations before execution
5. Keep audit logs of all operations

### For Claude (Orchestrator)
1. **Plan before delegating** - Think through the task breakdown
2. **Use TodoWrite** - Track all worker tasks
3. **Batch operations** - Launch parallel workers when possible
4. **Handle all GitHub operations** - Only Claude uses `gh` CLI
5. **Monitor actively** - Use `BashOutput` to track progress
6. **Clean up stuck workers** - Use `KillShell` if needed

### For Codex (Workers)
1. **Focused tasks** - Give specific, well-defined objectives
2. **Appropriate reasoning** - Match level to task complexity
3. **Clear output instructions** - Always specify output location
4. **Structured output** - Use JSON/Markdown for easy parsing
5. **File-based communication** - Save outputs, don't rely on stdout

### Infrastructure Reuse
1. **ALWAYS check existing scripts first** - Avoid reinventing the wheel
2. **Leverage proven patterns** - Use `codex-research.sh` for research tasks
3. **Build upon existing tools** - Extend, don't duplicate functionality
4. **Example**: For comparative analysis (`compare-analyse`), use existing `codex-research.sh` for parallel research, then add synthesis worker
5. **Anti-pattern**: Writing duplicate research execution patterns when `codex-research.sh` exists

### Critical Distinction
- **Planning tasks (`nnn`)**: Include "DO NOT modify/implement/write files"
- **Implementation tasks (`gogogo`)**: Allow file modifications
- **Be explicit**: "Analyze and DESIGN ONLY" vs "Implement the following"

## Workflow Examples

### Example 1: Multi-Component Refactoring
```bash
# 1. Claude analyzes requirements
# 2. Claude spawns workers:
codex exec "Refactor components to ${OUTPUT1}" &
codex exec "Update tests to ${OUTPUT2}" &
codex exec "Update docs to ${OUTPUT3}" &
# 3. Monitor all workers via BashOutput
# 4. Aggregate results
# 5. Create PR with gh CLI
```

### Example 2: Bug Fix Workflow
```bash
# 1. Claude reads GitHub issue
# 2. Delegate investigation to Codex
codex exec "Find root cause and save to ${OUTPUT}"
# 3. Review findings
# 4. Delegate fix implementation
codex exec "Implement fix based on analysis"
# 5. Create PR and update issue
```

## Helper Scripts

### codex-exec.sh
Basic execution helper for quick tasks:
```bash
./codex-exec.sh low "Quick file listing"
./codex-exec.sh high "Complex refactoring"
```

### codex-worker-launcher.sh
Advanced launcher with timestamp and tracking support.

## Anti-Patterns to Avoid

1. ❌ **Codex doing GitHub operations** - Only Claude should use `gh`
2. ❌ **Claude doing file operations** - Delegate to Codex
3. ❌ **Serial execution when parallel possible** - Use workers
4. ❌ **Not monitoring workers** - Always track with BashOutput
5. ❌ **Reading shell output directly** - Wait for output files
6. ❌ **Using force flags** - Always use safe operations
7. ❌ **Nested directory structures** - Keep outputs flat
8. ❌ **Duplicating existing script functionality** - Always check for `codex-research.sh`, `codex-exec.sh`, etc. before writing new execution patterns

## Monitoring & Debugging

### Check Running Workers
```bash
ps aux | grep codex
```

### Monitor Worker Output
Use `BashOutput` tool with bash_id to check progress without reading stdout.

### Worker Registry
Check `.catlab/workers/worker_registry.json` for active workers and their outputs.

## Security Considerations

### Development Environment
- Current examples use `danger-full-access` for testing
- Suitable only for isolated development environments
- Full system access - handle with care

### Production Recommendations
1. Implement proper authentication and authorization
2. Use containerization for isolation
3. Create file path whitelists
4. Add confirmation prompts for destructive operations
5. Maintain audit logs
6. Regular security reviews
7. Never use `--ask-for-approval never` in production

## Performance Optimization

- **Parallel execution limit**: 5-10 concurrent workers
- **Monitor system resources**: Check CPU/memory usage
- **Use appropriate reasoning levels**: Don't over-reason simple tasks
- **Batch related operations**: Group similar tasks

## Migration from TMux Approach

### Key Advantages
1. **No timing issues** - No sleep/wait commands needed
2. **Clean output** - Direct file output without UI parsing
3. **Proper exit codes** - Better error handling
4. **Parallel execution** - True concurrent processing
5. **Scriptable** - Easy CI/CD integration

## Summary

The Claude-Codex orchestrator/worker pattern provides:
- Clear separation of responsibilities
- Parallel execution capabilities
- File-based communication with traceability
- Safety-first approach to operations
- Scalable architecture for complex tasks

**Remember**: Safety over speed. Always validate operations before execution.

---
**Last Updated**: 2025-09-26
**Version**: 3.0 (Production-Ready)
**Status**: Tested and Verified