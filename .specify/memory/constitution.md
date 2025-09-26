<!--
Sync Impact Report
Version Change: 0.0.0 → 1.0.0 (Initial constitution creation)
Modified Principles: New constitution established
Added Sections: All sections newly defined
Removed Sections: None
Templates Requiring Updates:
  - .specify/templates/plan-template.md (⚠ pending - needs alignment with simplicity principle)
  - .specify/templates/spec-template.md (⚠ pending - needs scope alignment)
  - .specify/templates/tasks-template.md (⚠ pending - needs task categorization update)
Follow-up TODOs:
  - RATIFICATION_DATE: To be determined once officially adopted
-->

# Catlab-Kit Constitution

## Core Principles

### I. Simplicity First
Start with the simplest possible solution that works. Complexity must be justified by demonstrable need.
All features begin as minimal implementations, then iterate based on actual usage patterns.
YAGNI (You Aren't Gonna Need It) is the default position - prove necessity before adding complexity.

### II. Safety by Default
NEVER use force flags (`-f`, `--force`) in any commands or operations.
All operations must be reversible or have explicit confirmation steps.
Prefer interactive confirmation over automatic execution for destructive operations.
Use safe defaults: read-only first, explicit write permissions, verbose logging.

### III. Incremental Development
Break all work into small, testable increments that can be completed in under 1 hour.
Each increment must be independently valuable and deployable.
Complex features are delivered through multiple small phases, not monolithic implementations.

### IV. Orchestrator-Worker Pattern
Claude acts as orchestrator: planning, coordination, GitHub operations, monitoring.
Codex workers handle execution: file operations, code changes, analysis tasks.
Clear separation of concerns with file-based communication between components.
Parallel execution preferred when tasks are independent.

### V. Explicit Over Implicit
All file paths must be absolute, not relative.
All output locations must be specified explicitly.
Configuration and parameters must be visible and auditable.
No hidden side effects or magical behaviors.

## Development Workflow

### Task Management
- Use TodoWrite to track all work items and maintain visibility
- One task in progress at a time to maintain focus
- Mark tasks complete immediately upon finishing
- Break complex work into manageable subtasks

### Code Changes
- Read before editing - understand context first
- Preserve existing patterns and conventions
- Test changes before committing
- Document non-obvious decisions

### Communication
- File-based outputs for all worker results
- Structured formats (JSON/Markdown) for machine parsing
- Clear naming conventions with timestamps and task identifiers
- Progress monitoring through BashOutput, not direct stdout

## Safety Guidelines

### Command Execution
- Interactive confirmation for deletions (`rm -i` instead of `rm -rf`)
- No force-push to git repositories
- Validate operations before execution
- Maintain audit logs of all operations

### File Operations
- Check existence before creating directories
- Verify paths before operations
- Use safe file operations that can be reversed
- Never overwrite without explicit confirmation

### System Resources
- Monitor resource usage for parallel operations
- Limit concurrent workers to 5-10
- Use appropriate reasoning levels for task complexity
- Clean up stuck processes promptly

## Governance

The constitution supersedes all other project practices and guidelines.

Amendments require:
1. Documented rationale for change
2. Impact assessment on existing workflows
3. Migration plan for affected components
4. Explicit approval before implementation

All development must verify compliance with constitutional principles.
Complexity additions must demonstrate clear value over simpler alternatives.
Use CLAUDE.md for runtime development guidance and specific workflows.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): To be determined | **Last Amended**: 2025-09-26