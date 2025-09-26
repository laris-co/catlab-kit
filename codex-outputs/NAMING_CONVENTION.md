# Codex Output Naming Convention

## File Naming Pattern
```
{YYYYMMDD}_{HHMMSS}_{bash_id}_{description}.{ext}
```

## Examples
- `20250926_153327_17fb2b_file_count.txt`
- `20250926_153400_abc123_git_status.json`
- `20250926_153415_def456_analysis.md`

## Benefits
- **Flat structure**: All files in one directory (easy to find)
- **Chronological sorting**: Files naturally sort by creation time
- **Bash ID reference**: Direct link between process and output
- **Descriptive names**: Clear indication of content

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
OUTPUT_FILE="codex-outputs/${TIMESTAMP}_${BASH_ID}_description.ext"
```