# CatLab-Kit Constitution
<!-- Version Change: 1.0.0 → 1.0.1 (PATCH: Safety principle clarification) -->
<!-- Modified principles: III. Safety First (clarified danger-full-access usage) -->
<!-- Templates requiring updates: ⚠ pending validation -->

## Core Principles

### I. Simplicity First
Start with the simplest solution that works. Complex features require explicit justification. Follow YAGNI (You Ain't Gonna Need It) principles. When in doubt, choose the simpler approach.

### II. User Choice & Control
Codex can be used as a background process, but the user decides when and how. Never assume user preferences - provide options and let them choose. Background execution should be optional, not mandatory.

### III. Safety First
All operations must be safe by default. The `danger-full-access` sandbox mode is approved for use in this project for maximum capability and flexibility. Never use force flags (`-f`, `--force`) without explicit user consent. Implement proper error handling and validation.

### IV. Infrastructure Reuse
Always check existing scripts first - avoid reinventing the wheel. Leverage proven patterns like `codex-research.sh` for research tasks. Build upon existing tools rather than duplicating functionality.

### V. Background Execution Support
Provide background execution capabilities for non-blocking operations. Use reference IDs for tracking multiple concurrent tasks. Status files must be available for progress monitoring. Support both foreground (`--fg`) and background (`--bg`) modes.

## Development Workflow

Tasks should be delegated to appropriate workers:
- Claude acts as orchestrator for planning and GitHub operations
- Codex workers handle implementation and file operations
- Use background execution for parallel processing
- Monitor workers via status files and reference IDs

## Quality Standards

All scripts must include:
- Proper error handling and exit codes
- Command-line argument parsing
- Background execution support where applicable
- Status tracking and reference ID generation
- Consistent output formatting with color codes

## Governance

This constitution supersedes all other practices. The user has final authority over all decisions - the system provides options and recommendations, but never overrides user choice.

Amendments require:
1. User approval for any principle changes
2. Version increment following semantic versioning
3. Update of dependent templates and documentation
4. Migration plan for breaking changes

**Version**: 1.0.1 | **Ratified**: 2025-09-26 | **Last Amended**: 2025-09-26