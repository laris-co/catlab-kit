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
```markdown
---
description: Create context issue and compact conversation
---

## What this command does
- Check git status for current changes
- Create GitHub context issue with session state
- Run conversation compacting
- Provide next workflow suggestions
```

### cc-nnn (Next/Planning)
```markdown
---
description: Smart planning workflow - analysis only
---

## What this command does
- Check for recent context issue or analyze current state
- Perform codebase analysis and research
- Create GitHub implementation plan issue
- **CRITICAL**: NO file modifications - planning only
```

### cc-rrr (Retrospective)
```markdown
---
description: Create detailed session retrospective
---

## What this command does
- Collect session timeline and git changes
- Generate structured retrospective with required sections
- Export to retrospectives/ directory
- Link to relevant GitHub issues/PRs
```

### cc-gogogo (Execute Implementation)
```markdown
---
description: Execute most recent implementation plan
---

## What this command does
- Find most recent plan issue from cc-nnn
- Execute implementation step-by-step
- Allow file modifications and code changes
- Create commits and PRs as needed
```

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