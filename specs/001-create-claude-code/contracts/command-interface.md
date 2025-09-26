# Command Interface Contract

**Created**: 2025-09-26
**Feature**: 001-create-claude-code

## Command Interface Specification

### Standard Command Structure

Each command MUST follow this interface:

```markdown
---
description: Single line command purpose
---

# Command Name (shortcode)

Brief explanation paragraph.

## Usage
```
/command-name [arguments]
```

## What this command does

Bulleted list of behaviors and outcomes.

## Key Features

- ✅ Feature descriptions
- 🔧 Technical capabilities
- 📊 Smart suggestions

## Architecture

Technical implementation notes.

## Command executed
```bash
# Implementation details
```
```

### Required Command Behaviors

#### 1. Error Handling
- MUST gracefully handle missing dependencies (git, gh)
- MUST provide clear error messages
- MUST suggest fallback actions when possible

#### 2. Smart Suggestions
- SHOULD analyze current project state
- SHOULD suggest next logical workflow step
- SHOULD explain reasoning for suggestions

#### 3. GitHub Integration
- MUST use `gh` CLI for issue/PR operations
- MUST handle authentication gracefully
- MUST create structured, searchable issues

#### 4. Git Integration
- MUST check git status before operations
- MUST handle non-git directories gracefully
- MUST preserve git history and safety

### Command-Specific Contracts

#### cc-ccc Contract
- **Input**: Current session state
- **Output**: GitHub context issue + conversation compact
- **Dependencies**: git, gh, conversation compacting
- **Side Effects**: Creates GitHub issue, resets conversation

#### cc-nnn Contract
- **Input**: Context issue or project state
- **Output**: GitHub implementation plan issue
- **Dependencies**: git, gh, codebase analysis
- **Side Effects**: Creates plan issue, NO file modifications
- **Constraint**: Analysis and planning ONLY

#### cc-rrr Contract
- **Input**: Session activity and git history
- **Output**: Structured retrospective document
- **Dependencies**: git history, session data
- **Side Effects**: Creates retrospective file, updates GitHub

#### cc-gogogo Contract
- **Input**: Most recent plan issue
- **Output**: Implementation execution
- **Dependencies**: git, file operations, plan parsing
- **Side Effects**: Code changes, commits, PR creation

### Interface Consistency Rules

#### Command Invocation
- All commands start with `/cc-`
- Optional arguments passed after command name
- Help available via standard Claude Code patterns

#### Output Format
- Clear success/failure indicators
- Structured progress updates
- Links to created artifacts (issues, files, PRs)

#### State Management
- Commands MUST be stateless between invocations
- Persistent state stored in GitHub issues or git
- Temporary state cleaned up after execution

### Integration Requirements

#### Claude Code Compatibility
- MUST work with existing Claude Code infrastructure
- MUST not conflict with existing commands
- MUST follow .claude/commands conventions

#### Workflow Integration
- SHOULD suggest next command in sequence
- SHOULD detect and prevent invalid workflow states
- SHOULD provide context for command chaining

This contract ensures consistent, reliable behavior across all migrated short code commands.