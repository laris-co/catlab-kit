# Quickstart: Migrated Slash Commands

**Feature**: Slash Command Migration
**Version**: 1.0.0
**Prerequisites**: Claude Code environment with git repository

## Overview
This guide demonstrates the migrated slash commands that replace the original short codes (`ccc`, `nnn`, `rrr`) while maintaining backward compatibility.

## Quick Test Scenarios

### 1. Test Command Discovery
```bash
# In Claude Code, type:
/

# Expected: Auto-complete menu shows:
# - /context - Create GitHub context issue and compact
# - /plan - Analyze issue and create implementation plan
# - /retrospective - Generate session retrospective
```

### 2. Test Context Command (`/context` replaces `ccc`)
```bash
# Traditional way (still works):
ccc

# New slash command way:
/context

# With verbose flag:
/context --verbose

# Dry run (preview mode):
/context --dry-run

# Expected outcomes:
# - GitHub issue created with session context
# - Conversation compacted
# - Both methods produce identical results
```

### 3. Test Plan Command (`/plan` replaces `nnn`)
```bash
# Traditional way with issue number:
nnn #123

# New slash command way:
/plan 123

# With verbose output:
/plan 123 --verbose

# Preview without creating issue:
/plan 123 --dry-run

# Expected outcomes:
# - Issue #123 analyzed
# - Implementation plan created
# - Plan issue created in GitHub
```

### 4. Test Retrospective Command (`/retrospective` replaces `rrr`)
```bash
# Traditional way:
rrr

# New slash command way:
/retrospective

# With detailed output:
/retrospective --verbose

# Preview retrospective:
/retrospective --dry-run

# Expected outcomes:
# - Session retrospective generated
# - File created in retrospectives/
# - GitHub issue/PR updated with reference
```

## Error Handling Verification

### Test Missing Git Repository
```bash
# Navigate to non-git directory
cd /tmp
/context

# Expected error:
{
  "code": "ERR_NO_GIT",
  "message": "Not in a git repository",
  "remedy": "Run 'git init' or navigate to a git repository"
}
```

### Test Invalid Arguments
```bash
/plan abc

# Expected error:
{
  "code": "ERR_INVALID_ARGS",
  "message": "Invalid issue number: abc",
  "remedy": "Provide a valid issue number (e.g., /plan 123)"
}
```

### Test Missing GitHub CLI
```bash
# If gh CLI not installed:
/context

# Expected error:
{
  "code": "ERR_NO_GH_CLI",
  "message": "GitHub CLI not found",
  "remedy": "Install GitHub CLI: https://cli.github.com"
}
```

## Backward Compatibility Tests

### Verify Both Methods Work
```bash
# Test 1: Context creation
ccc                    # Old way
/context               # New way
# Both should create identical context issues

# Test 2: Planning with arguments
nnn #456               # Old way
/plan 456              # New way
# Both should analyze same issue and create plan

# Test 3: Retrospective generation
rrr                    # Old way
/retrospective         # New way
# Both should generate identical retrospectives
```

## Flag Functionality Tests

### Verbose Flag Test
```bash
# Run with verbose flag
/context --verbose

# Expected additional output:
# - Detailed git status
# - Full file listings
# - Complete command execution logs
# - Timing information
```

### Dry Run Flag Test
```bash
# Preview without execution
/plan 789 --dry-run

# Expected behavior:
# - Shows what would be done
# - No GitHub issues created
# - No files modified
# - Preview of issue content displayed
```

## Integration Test Checklist

- [ ] All three slash commands appear in auto-complete
- [ ] `/context` creates GitHub issue successfully
- [ ] `/plan` analyzes issues and creates plans
- [ ] `/retrospective` generates session summary
- [ ] Old short codes (`ccc`, `nnn`, `rrr`) still work
- [ ] `--verbose` flag provides detailed output
- [ ] `--dry-run` flag previews without execution
- [ ] Error messages include code, message, and remedy
- [ ] Commands work in git repository context
- [ ] Commands fail gracefully outside git repository

## Performance Validation

### Command Discovery Speed
```bash
# Type "/" and measure auto-complete response
# Expected: <100ms for suggestion list
```

### Command Execution Time
```bash
# Measure basic command execution
time /context --dry-run

# Expected times:
# - Parsing: <10ms
# - Validation: <20ms
# - Dry run execution: <100ms
# - Full execution: <2s (including GitHub API calls)
```

## Troubleshooting

### Command Not Found
If slash commands don't appear:
1. Verify Claude Code is updated
2. Check `.claude/commands/` directory exists
3. Restart Claude Code if needed

### Short Codes Not Working
If backward compatibility broken:
1. Check alias mappings in registry
2. Verify both code paths maintained
3. Check for regression in recent changes

### Auto-complete Issues
If suggestions don't appear:
1. Type `/` and wait briefly
2. Check command descriptions are set
3. Verify command registration succeeded

## Success Criteria

✅ **Migration Complete When**:
1. All slash commands discoverable via auto-complete
2. Each command executes its original workflow
3. Both old and new methods work identically
4. Flags enhance functionality without breaking defaults
5. Errors provide clear guidance for resolution
6. Performance meets or exceeds original implementation

---
**Quick Test Duration**: ~10 minutes
**Full Validation Duration**: ~30 minutes