# Data Model: Claude Code Custom Commands

**Created**: 2025-09-26
**Feature**: 001-create-claude-code

## Command Structure

### Base Command Model
```markdown
---
description: Brief description of command purpose
---

# Command Name (shortcode)

Brief explanation of what this command does.

## Usage
```
shortcode [optional arguments]
```

## What this command does

Detailed explanation with bullet points and examples.

## Key Features

- Feature 1
- Feature 2
- Feature 3

## Architecture

Brief technical implementation notes.

## Command executed
```bash
# The actual implementation
```
```

### Command Data Entities

#### 1. Context Data (cc-ccc)
- **Git Status**: Uncommitted changes, current branch
- **Session State**: Recent commands, current focus
- **Issue Context**: Related GitHub issues, PRs
- **Conversation State**: Ready for compacting

#### 2. Planning Data (cc-nnn)
- **Context Issue**: Recent context or explicit issue number
- **Project State**: Current codebase analysis
- **Implementation Focus**: What needs to be built
- **Planning Mode**: Analysis only, no file modifications

#### 3. Retrospective Data (cc-rrr)
- **Session Timeline**: Start/end times, major events
- **Git Changes**: Files modified, commits made
- **Learning Artifacts**: Patterns, mistakes, discoveries
- **Export Format**: Structured markdown with required sections

#### 4. Implementation Data (cc-gogogo)
- **Plan Source**: Most recent plan issue
- **Execution Steps**: Sequential task breakdown
- **File Operations**: Allowed modifications
- **Progress Tracking**: Step completion status

### Smart Suggestions Data Model

#### Project State Context
```json
{
  "git": {
    "status": "clean|dirty",
    "branch": "main|feature/*",
    "uncommitted_changes": ["file1.js", "file2.md"]
  },
  "github": {
    "recent_issues": [{"number": 123, "type": "context|plan"}],
    "open_prs": [{"number": 45, "status": "draft|ready"}]
  },
  "workflow_state": {
    "last_command": "cc-ccc|cc-nnn|cc-rrr|cc-gogogo",
    "suggested_next": "command_name",
    "reasoning": "why this suggestion makes sense"
  }
}
```

### Command Dependencies

#### Shared Dependencies
- **GitHub CLI**: `gh` for issue/PR operations
- **Git**: Status checking, branch operations
- **File System**: .claude/commands structure

#### Command-Specific Dependencies
- **cc-ccc**: Conversation compacting capability
- **cc-nnn**: Codebase analysis tools
- **cc-rrr**: Session data collection
- **cc-gogogo**: File modification permissions

### Integration Points

#### Claude Code Integration
- **Location**: `.claude/commands/cc-*.md`
- **Invocation**: `/cc-ccc`, `/cc-nnn`, `/cc-rrr`, `/cc-gogogo`
- **Arguments**: Optional issue numbers, parameters

#### Existing Infrastructure
- **Pattern Reuse**: Based on compare-analyse.md structure
- **GitHub Integration**: Native `gh` CLI usage
- **Background Support**: Can delegate to scripts like codex-research.sh

### Error Handling Model

#### Common Error States
- **Git Not Available**: Graceful degradation
- **GitHub CLI Missing**: Clear error messages
- **Network Issues**: Offline mode suggestions
- **Permission Errors**: Safe fallback operations

#### Command-Specific Errors
- **cc-ccc**: No git changes to contextualize
- **cc-nnn**: No recent context available
- **cc-rrr**: No session data to retrospect
- **cc-gogogo**: No implementation plan found

### Data Persistence

#### Ephemeral Data
- **Command State**: In-memory during execution
- **Suggestions**: Calculated on-demand
- **Error States**: Logged but not persisted

#### Persistent Data
- **GitHub Issues**: Created context/plan issues
- **Git History**: Commits and changes
- **Command Files**: .claude/commands/*.md definitions

This simple data model supports the "going simple way" approach while providing clear structure for implementation.