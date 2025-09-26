# Data Model: Simple Markdown Commands

**Feature**: 001-migrate-short-code
**Date**: 2025-09-26
**Version**: 1.0.0 (Simplified)

## Overview
This simplified data model uses markdown files for command definitions instead of complex TypeScript entities.

## Command File Structure

### Markdown Command File
Each command is defined as a single markdown file in `.claude/commands/`:

```markdown
# /command-name

**Description**: Brief description for auto-complete
**Arguments**: Optional or required arguments
**Flags**:
  - `--verbose`: Show detailed output
  - `--dry-run`: Preview without execution

## Usage Examples
```bash
/command-name
/command-name --verbose
/command-name --dry-run
```

## Implementation
Reference to existing short code functionality or direct implementation instructions.

## Backward Compatibility
This command replaces the `xyz` short code while maintaining backward compatibility.
```

### Command Mapping
Simple mapping between short codes and slash commands:

| Short Code | Slash Command | File Location |
|------------|---------------|---------------|
| `ccc` | `/context` | `.claude/commands/context.md` |
| `nnn` | `/plan` | `.claude/commands/plan.md` |
| `rrr` | `/retrospective` | `.claude/commands/retrospective.md` |

## File Organization

### Directory Structure
```
.claude/
├── commands/           # Command definitions
│   ├── context.md     # /context command
│   ├── plan.md        # /plan command
│   └── retrospective.md # /retrospective command
└── tests/             # Testing documentation
    └── manual-testing.md # Test procedures
```

### Metadata Format
Each command file contains:
- **Name**: Slash command name (e.g., `/context`)
- **Description**: Short description for auto-complete
- **Arguments**: List of supported arguments
- **Flags**: Standard flags (`--verbose`, `--dry-run`)
- **Examples**: Usage examples
- **Implementation**: How it works
- **Compatibility**: Reference to original short code

## Flag Definitions

### Standard Flags
All commands support these standard flags:

- `--verbose`: Increase output detail
- `--dry-run`: Preview action without execution

### Flag Behavior
- **Default**: Commands run normally
- **With --verbose**: Show additional information
- **With --dry-run**: Show what would happen without executing

## Validation Rules

### Command Names
- Must start with `/`
- Use lowercase with hyphens for multiple words
- Be descriptive and clear

### File Names
- Use lowercase with hyphens
- Match command name without `/`
- Use `.md` extension

### Documentation Requirements
- Every command must have a description
- Usage examples are mandatory
- Backward compatibility notes required

## Error Handling

### Simple Error Approach
- Clear error messages in command descriptions
- Reference existing error handling from short codes
- Document common error scenarios

### Error Documentation
Each command file should include:
- Common error scenarios
- How to resolve issues
- When to use each flag

## Relationships

### Command to Short Code
- Each slash command maps to exactly one short code
- Maintains identical functionality
- Both methods remain available

### Command to File
- One-to-one mapping between commands and markdown files
- File name matches command name (without `/`)
- Single source of truth per command

## Migration Strategy

### Phase 1: File Creation
1. Create `.claude/commands/` directory
2. Create three command markdown files
3. Follow standard template for each

### Phase 2: Documentation
1. Update CLAUDE.md with new commands
2. Document both slash commands and short codes
3. Provide migration guidance

### Phase 3: Testing
1. Manual testing of each command
2. Verify auto-complete functionality
3. Test backward compatibility

## Benefits of Simple Model

1. **No Complex Types**: Just markdown files
2. **No Compilation**: Direct editing and usage
3. **Self-Documenting**: Commands document themselves
4. **Version Control Friendly**: Text files in git
5. **Easy Maintenance**: No build process required

## Constitutional Alignment

### Simplicity First ✅
- Minimal complexity
- No unnecessary abstractions
- Clear, readable format

### Explicit Over Implicit ✅
- All information in markdown files
- Clear file paths and structure
- No hidden behaviors

### Incremental Development ✅
- Each command is independent
- Small, manageable files
- Easy to modify incrementally

---
**Data Model Complete**: Simple, clear structure ready for implementation.