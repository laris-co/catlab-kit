# Command Template for Claude Code Slash Commands

**Purpose**: Standard template for creating new slash commands
**Version**: 1.0.0 (Simplified)
**Date**: 2025-09-26

## Template Structure

Use this template for all new slash command markdown files:

```markdown
# /command-name

**Description**: [Brief description for auto-complete - max 80 characters]
**Arguments**: [None | Optional: argument-name | Required: argument-name]
**Flags**:
  - `--verbose`: Show detailed output
  - `--dry-run`: Preview without execution

## Usage Examples

### Basic Usage
```bash
/command-name
```

### With Flags
```bash
/command-name --verbose
/command-name --dry-run
/command-name --verbose --dry-run
```

### With Arguments (if applicable)
```bash
/command-name argument-value
/command-name argument-value --verbose
```

## Implementation

### What This Command Does
[Clear explanation of the command's purpose and functionality]

### Original Short Code Reference
This command replaces the `[xyz]` short code and maintains identical functionality:
- [List key behaviors]
- [Reference original implementation]

### Command Logic
[Step-by-step description of what happens when command runs]
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Flag Behavior

### --verbose Flag
When used, this flag will:
- [Specific verbose behavior 1]
- [Specific verbose behavior 2]

### --dry-run Flag
When used, this flag will:
- Show what would be executed
- Not perform any actual operations
- Display preview of results

## Error Handling

### Common Errors
- **Error**: [Description of error condition]
  **Solution**: [How to resolve]

- **Error**: [Another error condition]
  **Solution**: [How to resolve]

### Prerequisites
This command requires:
- [Prerequisite 1]
- [Prerequisite 2]

## Backward Compatibility

### Original Short Code
The original `[xyz]` short code continues to work exactly as before.

### Migration Path
Users can:
1. Continue using the original short code
2. Start using the new slash command
3. Mix both approaches as needed

## Testing

### Manual Test Cases
1. **Basic functionality**: Test `/command-name` executes correctly
2. **Verbose mode**: Test `--verbose` flag shows additional output
3. **Dry run**: Test `--dry-run` shows preview without execution
4. **Auto-complete**: Verify command appears in suggestion list
5. **Backward compatibility**: Test original short code still works

### Expected Results
- [Result 1]
- [Result 2]
- [Result 3]

## Notes

### Development Guidelines
- Keep implementation simple
- Reference existing short code logic
- Maintain backward compatibility
- Document all behaviors clearly

### Future Enhancements
[Optional: note any planned improvements or considerations]
```

## Template Usage Instructions

### Step 1: Copy Template
1. Copy the template structure above
2. Save as `.claude/commands/[command-name].md`
3. Replace all placeholders with actual values

### Step 2: Fill in Details
- Replace `[command-name]` with actual command name
- Replace `[xyz]` with actual short code
- Fill in all bracketed placeholders
- Customize examples for your specific command

### Step 3: Validate
- Ensure all required sections are complete
- Verify examples work correctly
- Test auto-complete functionality
- Confirm backward compatibility

## Quality Checklist

Before completing a command file, verify:
- [ ] Description is clear and under 80 characters
- [ ] All usage examples are accurate
- [ ] Flag behaviors are documented
- [ ] Error handling is covered
- [ ] Backward compatibility is maintained
- [ ] Testing instructions are complete

## Command-Specific Templates

### For Context Command (/context)
```markdown
# /context

**Description**: Create GitHub context issue and compact conversation
**Arguments**: None
**Flags**:
  - `--verbose`: Show detailed git status and file listings
  - `--dry-run`: Preview context issue content without creating

[Continue with template...]
```

### For Plan Command (/plan)
```markdown
# /plan

**Description**: Analyze GitHub issue and create implementation plan
**Arguments**: Optional: issue-number
**Flags**:
  - `--verbose`: Show detailed analysis steps
  - `--dry-run`: Preview plan content without creating issue

[Continue with template...]
```

### For Retrospective Command (/retrospective)
```markdown
# /retrospective

**Description**: Generate detailed session retrospective report
**Arguments**: None
**Flags**:
  - `--verbose`: Include detailed timeline and metrics
  - `--dry-run`: Preview retrospective content without saving

[Continue with template...]
```

---
**Template Complete**: Ready for creating simple, consistent command definitions.