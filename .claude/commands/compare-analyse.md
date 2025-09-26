# Compare-Analyse Command (cca)

Execute a Codex comparative analysis task using existing codex-research.sh for parallel research.

## Usage
```
cca "PostgreSQL vs MySQL for web apps"
cca "React vs Vue performance comparison"
```

## What this command does

I will use the existing codex-research.sh script to research both items in parallel, then synthesize a comprehensive comparison report with:

- **Side-by-Side Comparison**: Feature-by-feature analysis table
- **Detailed Analysis**: Strengths, weaknesses, use cases for each
- **Decision Matrix**: Scoring across key criteria  
- **Recommendations**: When to use each option
- **References & Sources**: Direct URLs only (no markdown titles)

The output will be saved to .catlab/research/ with proper naming.

## Key Features

✅ **Parallel research** - Simultaneous analysis using codex-research.sh
✅ **Structured comparison** - Side-by-side analysis format  
✅ **Direct URL citations** - Clean URLs without markdown titles
✅ **Process ID tracking** - Full traceability
✅ **Medium reasoning** - Balanced depth and speed

## Architecture

Uses existing codex-research.sh for parallel research + synthesis worker:
```bash
# Research both items in parallel using existing script
./codex-research.sh "Item A" &
./codex-research.sh "Item B" &
wait

# Then synthesize comparison
```

## Command executed
```bash
# Will be handled by codex-compare.sh script
./codex-compare.sh "PostgreSQL vs MySQL for web apps"
```
