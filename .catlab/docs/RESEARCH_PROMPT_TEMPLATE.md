# Research Prompt Template for Codex Workers

## Standard Research Prompt Pattern

```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME="research_topic"
OUTPUT_FILE=".catlab/research/${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md"

codex exec -s danger-full-access \
  -c 'tools.web_search=true' \
  -c model_reasoning_effort="medium" \
  "Research [TOPIC] using web search. Create a comprehensive markdown report with the following structure:

## Research Report: [TOPIC]

### Executive Summary
[2-3 sentence overview]

### Key Findings
[Main discoveries with bullet points]

### Detailed Analysis
[In-depth analysis of findings]

### Technical Specifications
[If applicable - versions, requirements, etc.]

### References & Sources
**CRITICAL**: Include FULL URLs for all sources referenced:
- [Source Title](https://full-url-here.com)
- [Another Source](https://complete-url-with-domain.com)
- [Documentation](https://official-docs-url.com)

### Conclusion
[Summary and recommendations]

**IMPORTANT INSTRUCTIONS**:
1. Replace PLACEHOLDER in filename '${OUTPUT_FILE}' with your process ID
2. Always include complete, clickable URLs in References section
3. Verify all links are full URLs starting with https://
4. Include publication dates where available
5. Prioritize official documentation and authoritative sources

Save output to: ${OUTPUT_FILE}"
```

## Example Usage

### Research Example 1: Technology Research
```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME="pocketbase_latest"
OUTPUT_FILE=".catlab/research/${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md"

codex exec -s danger-full-access \
  -c 'tools.web_search=true' \
  -c model_reasoning_effort="medium" \
  "Research the latest version of PocketBase database. Create a comprehensive markdown report with:

## Research Report: PocketBase Latest Version

### Executive Summary
[Brief overview of current state]

### Key Findings
- Current version and release date
- Major features and improvements
- Breaking changes or migration notes
- Performance benchmarks

### Technical Specifications
- System requirements
- Supported databases
- API endpoints and features
- Configuration options

### References & Sources
**CRITICAL**: Include FULL URLs:
- [Official PocketBase Site](https://full-url)
- [GitHub Repository](https://complete-github-url)
- [Documentation](https://docs-url)
- [Release Notes](https://releases-url)

**IMPORTANT**: Replace PLACEHOLDER in '${OUTPUT_FILE}' with your process ID and include complete URLs for all sources.

Save output to: ${OUTPUT_FILE}"
```

### Research Example 2: Comparative Analysis
```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TASK_NAME="database_comparison"
OUTPUT_FILE=".catlab/research/${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md"

codex exec -s danger-full-access \
  -c 'tools.web_search=true' \
  -c model_reasoning_effort="high" \
  "Compare SQLite, PocketBase, and Supabase for small to medium applications. Research and create report with:

## Comparative Analysis: SQLite vs PocketBase vs Supabase

### Executive Summary
[Comparison overview and recommendations]

### Feature Comparison Matrix
| Feature | SQLite | PocketBase | Supabase |
|---------|--------|------------|----------|
| [Feature] | [Details] | [Details] | [Details] |

### Use Case Recommendations
[When to use each option]

### References & Sources
**CRITICAL**: Include FULL URLs for all sources:
- [SQLite Official](https://complete-sqlite-url)
- [PocketBase Docs](https://full-pocketbase-url)
- [Supabase Documentation](https://complete-supabase-url)
- [Performance Benchmarks](https://benchmark-study-url)

**IMPORTANT**: Replace PLACEHOLDER in '${OUTPUT_FILE}' with process ID and verify all URLs are complete.

Save output to: ${OUTPUT_FILE}"
```

## Key Requirements for All Research

### Mandatory Reference Format
```markdown
### References & Sources
**CRITICAL**: All URLs must be complete and clickable:

✅ CORRECT:
- [PocketBase Official Site](https://pocketbase.io/)
- [GitHub Repository](https://github.com/pocketbase/pocketbase)
- [Documentation](https://pocketbase.io/docs/)

❌ INCORRECT:
- [PocketBase](pocketbase.io) - Missing https://
- [GitHub](github.com/pocketbase) - Incomplete URL
- [Docs](docs page) - No URL provided
```

### Quality Standards
1. **Complete URLs**: Every reference must have full https:// URL
2. **Authoritative Sources**: Prioritize official documentation
3. **Recent Information**: Include publication/update dates
4. **Verification**: Test that URLs are accessible
5. **Context**: Brief description of what each source provides

### File Naming Reminder
- Use PLACEHOLDER pattern: `${TIMESTAMP}_PLACEHOLDER_codex_${TASK_NAME}.md`
- Codex will replace PLACEHOLDER with actual process ID
- Final format: `20250926_161324_3465387_codex_research_topic.md`