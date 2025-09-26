# Research Report: Migrate Short Codes to Slash Commands

**Feature**: 001-migrate-short-code
**Date**: 2025-09-26
**Status**: Complete

## Executive Summary
This research documents the technical decisions for migrating existing short codes (`ccc`, `nnn`, `rrr`) to Claude Code slash commands while maintaining backward compatibility.

## Research Findings

### 1. Claude Code Command System
**Decision**: Use markdown-based command definitions in `.claude/commands/`
**Rationale**:
- Claude Code already supports this directory structure
- Markdown files allow rich documentation
- Auto-discovery mechanism built-in
**Alternatives Considered**:
- JSON configuration files (less readable)
- TypeScript plugins (overcomplicated for this use case)
- External configuration (breaks encapsulation)

### 2. Short Code Implementation Analysis
**Decision**: Extract workflow logic from existing CLAUDE.md patterns
**Rationale**:
- `ccc`: Creates GitHub context issues and compacts conversation
- `nnn`: Analyzes issues and creates implementation plans
- `rrr`: Generates session retrospectives
- All follow similar GitHub CLI integration patterns
**Alternatives Considered**:
- Complete rewrite (loses proven patterns)
- Direct code copy (misses improvement opportunities)

### 3. Command Registration Mechanism
**Decision**: Leverage Claude Code's SlashCommand API
**Rationale**:
- Native integration with auto-complete
- Built-in command discovery via `/` prefix
- Standard error handling pipeline
**Alternatives Considered**:
- Custom command parser (reinventing the wheel)
- Keyboard shortcuts (less discoverable)
- Context menu items (not text-based)

### 4. Auto-complete Integration
**Decision**: Provide command descriptions and argument hints
**Rationale**:
- Users can discover commands by typing `/`
- Descriptions explain what each command does
- Argument hints guide proper usage
**Alternatives Considered**:
- No descriptions (poor UX)
- Separate help system (fragmented experience)
- Dynamic suggestions (overcomplicated)

### 5. Backward Compatibility Strategy
**Decision**: Dual support - both short codes and slash commands work
**Rationale**:
- No breaking changes for existing users
- Gradual migration path
- Users can choose their preferred method
**Alternatives Considered**:
- Deprecation with warnings (disrupts workflows)
- Complete removal (breaks existing documentation)
- Versioned commands (complexity overhead)

### 6. Flag Implementation
**Decision**: Standard `--verbose` and `--dry-run` flags
**Rationale**:
- Industry-standard flag names
- Clear, predictable behavior
- Easy to implement and test
**Alternatives Considered**:
- Short flags only (`-v`, `-d`) - less clear
- Custom flag names - breaks conventions
- No flags - limits functionality

### 7. Error Handling Architecture
**Decision**: Structured errors with {code, message, remedy}
**Rationale**:
- Machine-readable for automation
- Human-friendly messages
- Actionable remedies guide resolution
**Alternatives Considered**:
- Simple string errors (not structured)
- Error codes only (not user-friendly)
- Verbose stack traces (too technical)

## Technical Specifications

### Command File Format
```markdown
# /command-name

**Description**: Brief description for auto-complete
**Arguments**: Optional arguments description
**Flags**:
  - `--verbose`: Detailed output
  - `--dry-run`: Preview without execution

## Implementation
[Command logic here]
```

### Error Response Structure
```typescript
interface ErrorResponse {
  code: string;        // e.g., "ERR_NO_GIT"
  message: string;     // User-friendly description
  remedy: string;      // How to fix the issue
}
```

### Command Registry Interface
```typescript
interface SlashCommand {
  name: string;
  description: string;
  handler: (args: string[], flags: Flags) => Promise<void>;
}
```

## Implementation Recommendations

1. **Phase Implementation**:
   - Start with core command structure
   - Add basic functionality (no flags)
   - Implement flags in second pass
   - Add comprehensive error handling last

2. **Testing Strategy**:
   - Unit tests for each command
   - Integration tests for backward compatibility
   - Manual testing in Claude Code environment
   - Auto-complete verification

3. **Documentation Updates**:
   - Update CLAUDE.md with new commands
   - Create command-specific help
   - Add migration guide for users

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Command name conflicts | High | Check existing commands first |
| Breaking changes | High | Maintain dual support |
| Performance impact | Low | Lazy load command handlers |
| Discovery issues | Medium | Clear descriptions in auto-complete |

## Next Steps
1. Create data model for command entities
2. Define API contracts
3. Generate test scenarios
4. Create quickstart guide

---
**Research Complete**: All technical unknowns resolved, ready for Phase 1 design.