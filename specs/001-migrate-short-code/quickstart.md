# Quickstart: Simple Markdown Slash Commands

**Feature**: Simplified Slash Command Migration
**Version**: 2.0.0 (Simplified)
**Prerequisites**: Claude Code environment

## Overview
This guide demonstrates the simplified approach to migrating short codes (`ccc`, `nnn`, `rrr`) to slash commands using simple markdown files.

## Quick Implementation Test

### 1. Directory Setup
```bash
# Check if .claude directory exists
ls -la .claude/

# If not, create the structure:
mkdir -p .claude/commands
mkdir -p .claude/tests
```

### 2. Test Command Creation
```bash
# Create a simple test command
cat > .claude/commands/test.md << 'EOF'
# /test

**Description**: Test command for validation
**Arguments**: None
**Flags**:
  - `--verbose`: Show detailed output
  - `--dry-run`: Preview without execution

## Usage Examples
```bash
/test
/test --verbose
/test --dry-run
```

## Implementation
This is a simple test command to verify the markdown approach works.

## Backward Compatibility
This is a new command for testing purposes.
EOF
```

### 3. Verify Auto-Complete
```bash
# In Claude Code, type:
/test

# Expected: Command appears in auto-complete with description
# "Test command for validation"
```

## Manual Testing Procedures

### Test 1: Command Discovery
**Objective**: Verify commands appear in auto-complete

**Steps**:
1. Open Claude Code
2. Type `/`
3. Look for migrated commands in suggestion list

**Expected Results**:
- `/context` appears with description
- `/plan` appears with description
- `/retrospective` appears with description

### Test 2: Context Command
**Objective**: Test `/context` replaces `ccc`

**Steps**:
1. Run traditional command: `ccc`
2. Note the behavior and output
3. Run new command: `/context`
4. Compare results

**Expected Results**:
- Both commands produce identical GitHub issues
- Both trigger conversation compacting
- No differences in functionality

### Test 3: Plan Command
**Objective**: Test `/plan` replaces `nnn`

**Steps**:
1. Choose a test issue number (e.g., #123)
2. Run traditional command: `nnn #123`
3. Note the behavior and output
4. Run new command: `/plan 123`
5. Compare results

**Expected Results**:
- Both commands analyze the same issue
- Both create implementation plan issues
- Argument parsing works correctly

### Test 4: Retrospective Command
**Objective**: Test `/retrospective` replaces `rrr`

**Steps**:
1. Run traditional command: `rrr`
2. Note the behavior and output
3. Run new command: `/retrospective`
4. Compare results

**Expected Results**:
- Both commands generate session retrospectives
- Both save to retrospectives/ directory
- File formats are identical

### Test 5: Flag Functionality
**Objective**: Test `--verbose` and `--dry-run` flags

**Steps**:
1. Test verbose: `/context --verbose`
2. Test dry-run: `/context --dry-run`
3. Test combined: `/context --verbose --dry-run`

**Expected Results**:
- Verbose shows additional output
- Dry-run previews without execution
- Combined flags work together

## Implementation Validation

### File Structure Check
```bash
# Verify correct file structure
tree .claude/
# Expected:
# .claude/
# ├── commands/
# │   ├── context.md
# │   ├── plan.md
# │   └── retrospective.md
# └── tests/
#     └── manual-testing.md
```

### File Content Validation
```bash
# Check each command file has required sections
grep -n "**Description**" .claude/commands/*.md
grep -n "## Usage Examples" .claude/commands/*.md
grep -n "## Implementation" .claude/commands/*.md
grep -n "## Backward Compatibility" .claude/commands/*.md
```

## Backward Compatibility Tests

### Test 1: Short Codes Still Work
```bash
# Verify original short codes function
ccc     # Should create context issue
nnn #456 # Should analyze issue 456
rrr     # Should generate retrospective
```

### Test 2: Mixed Usage
```bash
# Test using both methods in same session
ccc                    # Old way
/plan 789             # New way
/retrospective        # New way
```

### Test 3: Documentation Update
```bash
# Verify CLAUDE.md documents both methods
grep -A 5 -B 5 "ccc\|/context" CLAUDE.md
grep -A 5 -B 5 "nnn\|/plan" CLAUDE.md
grep -A 5 -B 5 "rrr\|/retrospective" CLAUDE.md
```

## Performance Validation

### Speed Test
```bash
# Time command discovery
# Type "/" and measure auto-complete response
# Expected: <100ms for suggestion list to appear
```

### Resource Usage
```bash
# Monitor resource usage during command execution
# No significant CPU or memory increase expected
```

## Error Handling Tests

### Test 1: Invalid Arguments
```bash
/plan abc     # Should show helpful error
/plan         # Should work without arguments
```

### Test 2: Missing Prerequisites
```bash
# Test outside git repository
cd /tmp
/context      # Should show appropriate error message
```

### Test 3: Network Issues
```bash
# Test when GitHub CLI unavailable
# Should show clear error with remedy
```

## Success Criteria Checklist

- [ ] All three slash commands appear in auto-complete
- [ ] Each slash command produces identical output to short code
- [ ] Both old and new methods work simultaneously
- [ ] `--verbose` flag increases output detail
- [ ] `--dry-run` flag previews without execution
- [ ] Commands work in git repository context
- [ ] Commands fail gracefully outside git repository
- [ ] Implementation takes <1 hour total
- [ ] No build or compilation steps required
- [ ] Documentation updated in CLAUDE.md

## Troubleshooting

### Commands Not Appearing
**Issue**: Slash commands don't show in auto-complete
**Solution**:
1. Verify `.claude/commands/` directory exists
2. Check file names match command names
3. Restart Claude Code if needed

### Backward Compatibility Broken
**Issue**: Original short codes stop working
**Solution**:
1. Verify CLAUDE.md maintains both methods
2. Check for conflicts in command names
3. Test in clean environment

### Performance Issues
**Issue**: Slow auto-complete or command execution
**Solution**:
1. Check file sizes (should be small)
2. Verify no complex processing in markdown
3. Monitor system resources

## Implementation Time Tracking

**Target**: Complete in under 1 hour

**Breakdown**:
- [ ] Directory setup: 5 minutes
- [ ] Create context.md: 10 minutes
- [ ] Create plan.md: 10 minutes
- [ ] Create retrospective.md: 10 minutes
- [ ] Update CLAUDE.md: 15 minutes
- [ ] Manual testing: 10 minutes

**Total**: ~60 minutes (constitutional compliance ✅)

---
**Quick Test Duration**: ~15 minutes
**Full Validation Duration**: ~45 minutes
**Total Implementation**: ~60 minutes