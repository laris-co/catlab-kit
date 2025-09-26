# Claude-Codex Orchestrator/Worker Workflow Summary

## Tested & Verified Workflow

### File Naming Convention
```
{YYYYMMDD}_{HHMMSS}_{bash_id}_{task_name}.{ext}
```

Example: `20250926_153721_c1282f_readme_analysis.md`

### Execution Pattern
```bash
# 1. Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 2. Define task and output file
TASK_NAME="your_task"
OUTPUT_FILE=".catlab/workers/${TIMESTAMP}_BASHID_${TASK_NAME}.ext"

# 3. Execute in background (captures bash_id)
codex exec -s danger-full-access \
  -c model_reasoning_effort="low" \
  "Task description. Save output to: ${OUTPUT_FILE}"
```

### Directory Structure
```
.catlab/
├── docs/                           # Documentation files
│   ├── NAMING_CONVENTION.md        # Naming guide
│   └── WORKFLOW_SUMMARY.md         # Workflow documentation
├── workers/                        # Worker outputs and registry
│   ├── worker_registry.json        # Bash ID tracking
│   └── 20250926_153721_c1282f_readme_analysis.md  # Example output
└── researchs/                      # Research outputs (existing)
```

## Key Benefits
1. **Organized structure** - Logical separation of docs and worker outputs
2. **Chronological sorting** - Files naturally sort by timestamp
3. **Bash ID tracking** - Links background process to output
4. **Self-documenting names** - Clear what each file contains

## Helper Scripts
- `codex-exec.sh` - Basic execution helper
- `codex-worker-launcher.sh` - Advanced launcher with tracking

## Registry Format
The `worker_registry.json` tracks:
- bash_id: Process identifier from background execution
- timestamp: When launched
- task: What the worker is doing
- expected_output: Where output will be saved
- status: running/completed

## Best Practices
1. Always use background execution with `run_in_background: true`
2. Include bash_id in filename for traceability
3. Wait for output files rather than monitoring shell output
4. Keep all outputs organized in `.catlab/workers/` directory
5. Update registry when launching new workers