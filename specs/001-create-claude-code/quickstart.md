# Quick Start: Claude Code Short Commands

**Feature**: 001-create-claude-code
**Created**: 2025-09-26

## Overview

Four migrated short commands for familiar workflow patterns in Claude Code:

| Command | Original | Purpose | Usage |
|---------|----------|---------|-------|
| `/cc-ccc` | `ccc` | Context & Compact | Create context issue, compact conversation |
| `/cc-nnn` | `nnn` | Next/Planning | Smart planning workflow (analysis only) |
| `/cc-rrr` | `rrr` | Retrospective | Create detailed session retrospective |
| `/cc-gogogo` | `gogogo` | Execute Plan | Execute most recent implementation plan |

## Quick Setup

### Prerequisites
```bash
# Required tools
gh --version    # GitHub CLI
git --version   # Git

# Optional: Check Claude Code commands directory
ls .claude/commands/
```

### Installation
Commands will be available as `.claude/commands/cc-*.md` files once implemented.

## Usage Examples

### 1. Start New Feature (`/cc-ccc` → `/cc-nnn`)
```
/cc-ccc
# Creates context issue, compacts conversation

/cc-nnn
# Analyzes context, creates implementation plan
```

### 2. Execute Implementation (`/cc-gogogo`)
```
/cc-gogogo
# Finds recent plan issue, executes step-by-step
```

### 3. Document Session (`/cc-rrr`)
```
/cc-rrr
# Creates retrospective with timeline and learnings
```

## Smart Workflow Suggestions

The commands provide intelligent next-step suggestions:

### When to use `/cc-ccc`
- ✅ Git status shows uncommitted changes
- ✅ Conversation getting long or complex
- ✅ Starting new feature or investigation

### When to use `/cc-nnn`
- ✅ After `/cc-ccc` context creation
- ✅ New GitHub issue needs analysis
- ✅ Planning phase of development

### When to use `/cc-gogogo`
- ✅ After `/cc-nnn` planning complete
- ✅ Implementation plan issue exists
- ✅ Ready to execute code changes

### When to use `/cc-rrr`
- ✅ End of work session
- ✅ Major feature completion
- ✅ Learning documentation needed

## Command Chaining Examples

### Complete Feature Workflow
```bash
# 1. Context capture
/cc-ccc

# 2. Planning analysis
/cc-nnn

# 3. Implementation
/cc-gogogo

# 4. Session documentation
/cc-rrr
```

### Investigation Workflow
```bash
# 1. Capture investigation context
/cc-ccc

# 2. Analyze and plan research
/cc-nnn

# 3. Document findings
/cc-rrr
```

## Integration Notes

### GitHub Integration
- All commands create/update GitHub issues
- Issues tagged with appropriate labels
- Cross-references between context/plan issues

### Git Integration
- Respects git status and branch state
- Safe operations with confirmation prompts
- History preservation and safety checks

### Claude Code Integration
- Native `/command` invocation
- Follows existing .claude/commands patterns
- No conflicts with built-in commands

## Troubleshooting

### Common Issues

#### "gh not authenticated"
```bash
gh auth login
gh auth status
```

#### "Not a git repository"
```bash
git init
git remote add origin [repository-url]
```

#### "No recent context/plan found"
- Use `/cc-ccc` to create context first
- Use `/cc-nnn` to create implementation plan
- Check GitHub issues for existing context

### Getting Help
- Each command includes detailed usage in its description
- Use Claude Code's built-in help for command details
- Check .claude/commands/*.md for full documentation

## What's Next?

1. **Implementation**: Create the 4 command files in `.claude/commands/`
2. **Testing**: Verify each command works independently and in sequence
3. **Documentation**: Update main project docs with new command references
4. **Usage**: Start using commands in daily development workflow

This quick start gets you productive with the migrated short codes immediately while maintaining the familiar workflow patterns.