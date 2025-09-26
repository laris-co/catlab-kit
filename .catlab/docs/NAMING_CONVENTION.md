# Agent Output Naming Convention

## File Naming Pattern
```
{YYYYMMDD}_{HHMMSS}_{bash_id}_{agent_name}_{description}.{ext}
```

## Examples
- `20250926_153327_17fb2b_codex_file_count.txt`
- `20250926_153400_abc123_claude_git_status.json`
- `20250926_161324_85499d_codex_pocketbase_research.md`

## Directory Structure
```
.catlab/
├── research/           # Research outputs from agents
├── workers/           # General worker outputs
└── docs/             # Documentation files
```

## Benefits
- **Agent attribution**: Clear identification of which agent generated output
- **Organized structure**: Logical separation by output type
- **Chronological sorting**: Files naturally sort by creation time
- **Bash ID reference**: Direct link between process and output
- **Descriptive names**: Clear indication of content and agent

## Bash ID Mapping
The `worker_registry.json` maintains the mapping between:
- Bash ID (from background execution)
- Timestamp
- Output file path
- Task description
- Status

## Best Practice
When launching a worker:
```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
# After getting bash_id from background execution
OUTPUT_FILE=".catlab/workers/${TIMESTAMP}_${BASH_ID}_description.ext"
```