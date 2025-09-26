# Manual Testing Procedures: Slash Commands Migration

**Feature**: 001-migrate-short-code
**Date**: 2025-09-26
**Purpose**: Comprehensive manual testing guide for migrated slash commands

## Overview

This document provides step-by-step testing procedures to verify that the new slash commands (`/context`, `/plan`, `/retrospective`) work correctly and maintain backward compatibility with existing short codes (`ccc`, `nnn`, `rrr`).

## Prerequisites

- Claude Code environment running
- Git repository context
- GitHub CLI authenticated (`gh auth status`)
- At least one GitHub issue available for testing

## Test Categories

### 1. Command Discovery Tests

#### Test 1.1: Auto-Complete Functionality
**Objective**: Verify slash commands appear in auto-complete

**Steps**:
1. Open Claude Code
2. Type `/` in the chat
3. Observe auto-complete suggestions

**Expected Results**:
- `/context` appears with description "Create GitHub context issue and compact conversation"
- `/plan` appears with description "Analyze GitHub issue and create implementation plan"
- `/retrospective` appears with description "Generate detailed session retrospective report"

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 1.2: Command Description Accuracy
**Objective**: Verify descriptions match command functionality

**Steps**:
1. Review each command description in auto-complete
2. Compare with expected functionality

**Expected Results**:
- Descriptions are under 80 characters
- Descriptions accurately reflect command purpose
- No spelling or grammar errors

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

### 2. Context Command Tests

#### Test 2.1: Basic /context Execution
**Objective**: Test basic `/context` command functionality

**Steps**:
1. Run `/context` command
2. Observe GitHub issue creation
3. Note conversation compacting

**Expected Results**:
- GitHub context issue created successfully
- Issue contains git status, recent commits, and session context
- Conversation is compacted after issue creation
- Issue number is provided for reference

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 2.2: /context --verbose Flag
**Objective**: Test verbose output functionality

**Steps**:
1. Run `/context --verbose`
2. Compare output with basic `/context`

**Expected Results**:
- Additional detailed git status output shown
- More comprehensive file listings displayed
- Verbose logging during issue creation
- All basic functionality still works

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 2.3: /context --dry-run Flag
**Objective**: Test dry-run preview functionality

**Steps**:
1. Run `/context --dry-run`
2. Verify no GitHub issue is created
3. Check that preview content is shown

**Expected Results**:
- No GitHub issue created
- Context issue content preview displayed
- Git information shown without side effects
- No conversation compacting occurs

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

### 3. Plan Command Tests

#### Test 3.1: Basic /plan Execution
**Objective**: Test basic `/plan` command functionality

**Steps**:
1. Run `/plan` command
2. Observe analysis and plan creation

**Expected Results**:
- Latest issue analyzed automatically
- Comprehensive implementation plan created
- Plan issue number provided
- Analysis includes codebase research

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 3.2: /plan with Issue Number
**Objective**: Test plan command with specific issue

**Steps**:
1. Choose existing issue number (e.g., #123)
2. Run `/plan 123`
3. Verify correct issue is analyzed

**Expected Results**:
- Specified issue is analyzed instead of latest
- Plan references the correct issue number
- Analysis is relevant to specified issue
- Plan creation works normally

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 3.3: /plan --dry-run Flag
**Objective**: Test plan preview functionality

**Steps**:
1. Run `/plan --dry-run`
2. Verify no plan issue is created

**Expected Results**:
- Analysis proceeds normally
- Plan content preview displayed
- No GitHub issue created
- All analysis information shown

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

### 4. Retrospective Command Tests

#### Test 4.1: Basic /retrospective Execution
**Objective**: Test basic retrospective functionality

**Steps**:
1. Make some changes and commits during session
2. Run `/retrospective` command
3. Check retrospective file creation

**Expected Results**:
- Retrospective file created in retrospectives/ directory
- All mandatory sections included (AI Diary, Honest Feedback)
- Session timeline and technical details documented
- File committed to git with appropriate message

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 4.2: /retrospective --verbose Flag
**Objective**: Test verbose retrospective mode

**Steps**:
1. Run `/retrospective --verbose`
2. Compare output with basic version

**Expected Results**:
- Detailed timeline with precise timestamps
- Comprehensive git change analysis
- Session metrics and statistics included
- Verbose logging during file creation

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

### 5. Backward Compatibility Tests

#### Test 5.1: Original Short Codes Still Work
**Objective**: Verify existing short codes remain functional

**Steps**:
1. Test original `ccc` command
2. Test original `nnn` command
3. Test original `rrr` command

**Expected Results**:
- `ccc` creates context issue and compacts conversation
- `nnn` analyzes issues and creates implementation plans
- `rrr` generates session retrospectives
- All function exactly as before migration

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 5.2: Mixed Usage in Same Session
**Objective**: Test using both old and new methods together

**Steps**:
1. Run `ccc` (old way)
2. Run `/plan 123` (new way)
3. Run `/retrospective` (new way)
4. Verify all work correctly

**Expected Results**:
- No conflicts between old and new methods
- Both approaches work seamlessly together
- Context is maintained between different command types
- No functional differences in output

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 5.3: Identical Functionality Verification
**Objective**: Ensure new commands produce identical results

**Steps**:
1. Run `ccc`, note output and behavior
2. Run `/context`, compare results
3. Repeat for `nnn` vs `/plan` and `rrr` vs `/retrospective`

**Expected Results**:
- GitHub issues created have identical content
- File outputs are identical
- Behavior is functionally equivalent
- Only difference is command invocation method

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

### 6. Flag Combination Tests

#### Test 6.1: Multiple Flags Together
**Objective**: Test combinations of flags

**Steps**:
1. Test `/context --verbose --dry-run`
2. Test `/plan --verbose --dry-run`
3. Test `/retrospective --verbose --dry-run`

**Expected Results**:
- Both flags work together correctly
- Verbose output shown in dry-run mode
- No side effects occur (no issues/files created)
- All information displayed properly

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

### 7. Error Handling Tests

#### Test 7.1: Invalid Arguments
**Objective**: Test error handling for invalid inputs

**Steps**:
1. Test `/plan abc` (invalid issue number)
2. Test `/plan #999999` (non-existent issue)
3. Test `/context extra-arg` (unexpected argument)

**Expected Results**:
- Clear error messages displayed
- Helpful suggestions provided
- Commands fail gracefully
- No partial execution occurs

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

#### Test 7.2: Missing Prerequisites
**Objective**: Test behavior when prerequisites missing

**Steps**:
1. Test commands outside git repository
2. Test when GitHub CLI not authenticated
3. Test when no internet connection available

**Expected Results**:
- Appropriate error messages shown
- Clear instructions for resolution provided
- Commands fail safely without corruption
- Recovery steps are actionable

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

## Performance Tests

### Test 8.1: Auto-Complete Response Time
**Objective**: Verify auto-complete performance

**Steps**:
1. Type `/` and measure response time
2. Record time for suggestions to appear
3. Test multiple times for consistency

**Expected Results**:
- Suggestions appear within 100ms
- Performance is consistent across attempts
- No noticeable delay compared to other commands

**Pass/Fail**: [ ] Pass [ ] Fail

**Performance**: _____ ms average

### Test 8.2: Command Execution Performance
**Objective**: Verify commands execute efficiently

**Steps**:
1. Time each command execution
2. Compare with original short code timing
3. Check resource usage during execution

**Expected Results**:
- Execution time similar to original short codes
- No significant CPU or memory increase
- Commands complete within reasonable time

**Pass/Fail**: [ ] Pass [ ] Fail

**Notes**:
_________________________________

## File Structure Validation

### Test 9.1: Verify Implementation Files
**Objective**: Confirm all required files exist and are correct

**Steps**:
1. Check `.claude/commands/` directory structure
2. Verify all three command files exist
3. Validate file content structure

**Expected Results**:
```
.claude/
├── commands/
│   ├── context.md      ✓
│   ├── plan.md         ✓
│   └── retrospective.md ✓
└── tests/
    └── manual-testing.md ✓
```

**Pass/Fail**: [ ] Pass [ ] Fail

### Test 9.2: Content Validation
**Objective**: Verify command files have required sections

**Steps**:
1. Check each file has Description, Arguments, Flags sections
2. Verify Usage Examples are present
3. Confirm Implementation and Backward Compatibility sections exist

**Expected Results**:
- All command files follow standard template
- Required sections are complete
- Examples are accurate and helpful
- Backward compatibility documented

**Pass/Fail**: [ ] Pass [ ] Fail

## Documentation Tests

### Test 10.1: CLAUDE.md Updates
**Objective**: Verify documentation is updated correctly

**Steps**:
1. Check Quick Reference section includes slash commands
2. Verify Core Commands section updated
3. Confirm backward compatibility noted

**Expected Results**:
- Both short codes and slash commands documented
- Clear usage examples provided
- Migration path explained
- Backward compatibility emphasized

**Pass/Fail**: [ ] Pass [ ] Fail

## Success Criteria Summary

**Overall Implementation Success**: [ ] Pass [ ] Fail

### Critical Requirements
- [ ] All three slash commands appear in auto-complete
- [ ] Each slash command produces identical output to short code
- [ ] Both old and new methods work simultaneously
- [ ] `--verbose` flag increases output detail
- [ ] `--dry-run` flag previews without execution
- [ ] Commands work in git repository context
- [ ] Commands fail gracefully outside git repository
- [ ] Implementation took <1 hour total
- [ ] No build or compilation steps required
- [ ] Documentation updated correctly

### Implementation Time Tracking
- Directory setup: _____ minutes
- Command file creation: _____ minutes
- Documentation updates: _____ minutes
- Testing completion: _____ minutes
- **Total time**: _____ minutes (Target: <60 minutes)

## Test Completion

**Tested by**: _________________
**Date**: _________________
**Total tests passed**: _____ / _____
**Overall result**: [ ] PASS [ ] FAIL

**Critical issues found**:
_________________________________
_________________________________

**Recommendations**:
_________________________________
_________________________________

---
**Testing Complete**: Implementation validated according to constitutional simplicity principles.