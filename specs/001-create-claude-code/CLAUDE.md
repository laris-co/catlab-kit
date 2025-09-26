# Claude Code Short Command Migration - Agent Guidelines

**Feature**: 001-create-claude-code
**Created**: 2025-09-26

## Overview

This feature migrates 4 familiar short codes from CLAUDE.md patterns to native Claude Code custom commands:
- `cc-ccc` - Context & Compact workflow
- `cc-nnn` - Smart planning (analysis only)
- `cc-rrr` - Session retrospectives
- `cc-gogogo` - Implementation execution

## Implementation Approach: Simple & Proven

Following the user's directive "we still going simple way":
- **Markdown-based commands** in `.claude/commands/`
- **Proven patterns** from existing compare-analyse.md
- **No complex infrastructure** - file-based, straightforward
- **Native Claude Code integration** - standard `/command` syntax

## Command Implementations

### cc-ccc (Context & Compact)
- **Preconditions**: Git repo available; `git` and `gh` authenticated; conversational context ready to summarise; optional flags `--title`, `--labels`, `--no-compact`.
- **Execution Steps**:
  1. Parse arguments and establish defaults (title = `Context: <branch> (<YYYY-MM-DD>)`, label = `context`).
  2. Collect repo snapshot (`git status --porcelain`, `git rev-parse --abbrev-ref HEAD`, `git log -5`).
  3. Summarise conversation focus, blockers, and next intentions.
  4. Publish GitHub context issue with structured markdown sections (Session Snapshot, Uncommitted Files, Conversation Focus, Next Intentions, Suggested Commands).
  5. Invoke `/compact` unless skipped, then emit smart follow-up suggestions.
- **Outputs**: Context issue URL, compact status, recommended next command.
- **Failure Modes**: Missing git repo, unauthenticated `gh`, network/write failure (issue body saved for retry).

### cc-nnn (Next/Planning)
- **Preconditions**: Context issue exists (auto-detected or provided via `#123` argument); repo readable; analysis-only contract enforced.
- **Execution Steps**:
  1. Resolve context source via argument or latest open `context` issue.
  2. Pull context body plus referenced artifacts for research.
  3. Inspect codebase read-only (tree scan, dependency review, targeted file reads).
  4. Draft plan sections (Summary, Research & Insights, Implementation Strategy, Task Breakdown, Testing & Validation, Risks & Mitigations, Next Commands).
  5. Publish `Plan:` GitHub issue with labels (`plan`, components) and link back to context.
- **Outputs**: Plan issue URL, ordered phases, recommendation to run `/cc-gogogo`.
- **Failure Modes**: No context found, invalid issue reference, repository unreadable.

### cc-rrr (Retrospective)
- **Preconditions**: Session produced meaningful work (commits/diffs); repo history accessible; `retrospectives/` writable; optional `--issue` argument.
- **Execution Steps**:
  1. Gather evidence (session window, `git log main...HEAD`, `git diff --name-only`).
  2. Populate mandatory sections (Session Summary & Timeline, Technical Details, AI Diary, What Went Well / Could Improve, Honest Feedback, Lessons Learned, Next Steps, Blockers/Resolutions if relevant).
  3. Write timestamped file under `retrospectives/YYYY/MM/` (UTC filename, GMT+7 display times).
  4. Stage & commit retrospective; optionally comment on linked issue with path + highlights.
  5. Suggest follow-on commands (often `/cc-ccc` or `/cc-nnn`).
- **Outputs**: Retrospective file path, commit reference, optional GitHub comment.
- **Failure Modes**: No activity detected, write permissions missing, mandatory sections incomplete.

### cc-gogogo (Execute Implementation)
- **Preconditions**: Latest `/cc-nnn` plan issue exists and is open; tooling installed; working tree ready for changes.
- **Execution Steps**:
  1. Resolve plan issue (argument or newest open plan) and parse phases, dependencies, acceptance criteria.
  2. Prepare workspace (branch checkout/creation, dependency setup) per plan instructions.
  3. Execute tasks sequentially (respect `[P]` markers for parallel opportunities) with TDD emphasis and per-step validation.
  4. Group and commit changes referencing plan issue, updating plan checkboxes/progress after each step.
  5. Create or update PR, attach testing evidence, surface blockers or deviations, and run final verification.
- **Outputs**: Commit range, PR link, updated plan status, recommended `cc-rrr` follow-up.
- **Failure Modes**: Missing plan issue, plan schema unreadable, task execution error (halt + diagnostics), git conflicts.
## Smart Workflow Suggestions

Each command analyzes current project state to suggest next steps:

### Context-Aware Suggestions
- **Git changes present** → Suggest `cc-ccc` first
- **Recent context issue exists** → Suggest `cc-nnn` for planning
- **Plan issue ready** → Suggest `cc-gogogo` for implementation
- **Session ending** → Suggest `cc-rrr` for documentation

### Workflow Chain Detection
Commands detect and prevent invalid states:
- `cc-nnn` checks for context before planning
- `cc-gogogo` validates plan exists before executing
- `cc-rrr` ensures session has meaningful activity

## Integration Notes

### GitHub Integration
- All commands use `gh` CLI for issue management
- Issues tagged appropriately for filtering
- Cross-references between context/plan issues maintained

### Git Safety
- Status checks before operations
- Confirmation prompts for destructive actions
- History preservation and rollback capability

### Claude Code Compatibility
- Follows `.claude/commands/*.md` conventions
- Uses frontmatter descriptions
- Standard documentation format
- No conflicts with existing commands

## Constitutional Compliance

### ✅ Simplicity First
Simple markdown files, no complex infrastructure

### ✅ User Choice & Control
Commands are optional, user controls invocation

### ✅ Safety First
cc- prefix prevents conflicts, confirmations for destructive actions

### ✅ Infrastructure Reuse
Leverages proven .claude/commands patterns, existing GitHub/git tooling

### ✅ Background Execution Support
Can delegate to existing background-capable scripts when needed

## Development Guidelines

### File Structure
```
.claude/commands/
├── cc-ccc.md       # Context & Compact
├── cc-nnn.md       # Next/Planning
├── cc-rrr.md       # Retrospective
└── cc-gogogo.md    # Execute Implementation
```

### Implementation Priority
1. **cc-ccc** - Foundation for other commands
2. **cc-nnn** - Planning workflow (analysis only)
3. **cc-gogogo** - Implementation execution
4. **cc-rrr** - Session documentation

### Testing Strategy
- Manual testing with Claude Code CLI
- Verify each command works independently
- Test workflow sequences (ccc → nnn → gogogo → rrr)
- Validate GitHub integration and git safety

## Success Criteria

### Functional Requirements Met
- All 4 commands work as native Claude Code commands
- cc- prefix prevents conflicts
- Smart suggestions provide workflow guidance
- Original functionality preserved and enhanced

### User Experience Goals
- Familiar workflow patterns maintained
- Clear error messages and fallback suggestions
- Seamless integration with existing development process
- Simple invocation via `/cc-*` commands

This agent guide ensures consistent implementation following the "simple way" approach while maintaining all required functionality.