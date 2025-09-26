# Tasks: Migrate Short Codes to Simple Markdown Slash Commands

**Input**: Design documents from `/specs/001-migrate-short-code/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → Extract: simplified markdown approach, no TypeScript
2. Load design documents:
   → data-model.md: Simple markdown file structure
   → contracts/: Command template for consistency
   → quickstart.md: Manual testing procedures
3. Generate simple tasks by category:
   → Setup: directory creation
   → Core: markdown file creation (one per command)
   → Integration: documentation updates
   → Polish: manual testing
4. Apply simplified task rules:
   → Different files = mark [P] for parallel
   → Simple markdown files can all be created in parallel
5. Number tasks sequentially (T001, T002...)
6. Validate simplicity: no complex dependencies
7. Return: SUCCESS (simple tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Single project**: `.claude/` at repository root for Claude Code commands
- **Markdown files**: `.claude/commands/` for command definitions
- **Tests**: Manual testing only, no automated test framework
- Paths shown below follow simplified markdown structure from plan.md

## Phase 3.1: Setup
- [x] T001 Create .claude/commands/ directory structure
- [x] T002 Create .claude/tests/ directory for manual testing documentation

## Phase 3.2: Core Implementation (Simple Markdown Files)

### Command File Creation
- [x] T003 [P] Create /context command definition in .claude/commands/context.md
- [x] T004 [P] Create /plan command definition in .claude/commands/plan.md
- [x] T005 [P] Create /retrospective command definition in .claude/commands/retrospective.md

## Phase 3.3: Integration & Documentation

### Documentation Updates
- [x] T006 Update CLAUDE.md with new slash command documentation
- [x] T007 Create manual testing procedures in .claude/tests/manual-testing.md

## Phase 3.4: Validation

### Manual Testing
- [x] T008 Execute quickstart.md validation scenarios
- [x] T009 Verify backward compatibility (both short codes and slash commands work)

## Dependencies
- Setup (T001-T002) before all other tasks
- Command files (T003-T005) can all run in parallel
- Documentation (T006-T007) after command files are created
- Testing (T008-T009) after all implementation complete

## Parallel Example
```bash
# Phase 3.2 - Create all command files simultaneously:
Task: "Create /context command definition in .claude/commands/context.md"
Task: "Create /plan command definition in .claude/commands/plan.md"
Task: "Create /retrospective command definition in .claude/commands/retrospective.md"
```

## Detailed Task Specifications

### T001: Create .claude/commands/ directory structure
**File Path**: `.claude/commands/`
**Description**: Create the directory structure for Claude Code slash commands
**Actions**:
1. Check if `.claude/` directory exists at repository root
2. Create `.claude/commands/` directory
3. Verify directory is created and accessible

### T002: Create .claude/tests/ directory for manual testing
**File Path**: `.claude/tests/`
**Description**: Create directory for manual testing documentation
**Actions**:
1. Create `.claude/tests/` directory
2. Verify directory structure matches plan.md expectations

### T003: Create /context command definition
**File Path**: `.claude/commands/context.md`
**Description**: Create markdown file for /context slash command
**Template**: Use contracts/command-template.md as base
**Content Requirements**:
- Command name: `/context`
- Description: "Create GitHub context issue and compact conversation"
- Arguments: None
- Flags: `--verbose`, `--dry-run`
- Implementation: Reference to existing `ccc` short code functionality
- Backward compatibility: Document that `ccc` continues to work

### T004: Create /plan command definition
**File Path**: `.claude/commands/plan.md`
**Description**: Create markdown file for /plan slash command
**Template**: Use contracts/command-template.md as base
**Content Requirements**:
- Command name: `/plan`
- Description: "Analyze GitHub issue and create implementation plan"
- Arguments: Optional issue number
- Flags: `--verbose`, `--dry-run`
- Implementation: Reference to existing `nnn` short code functionality
- Backward compatibility: Document that `nnn` continues to work

### T005: Create /retrospective command definition
**File Path**: `.claude/commands/retrospective.md`
**Description**: Create markdown file for /retrospective slash command
**Template**: Use contracts/command-template.md as base
**Content Requirements**:
- Command name: `/retrospective`
- Description: "Generate detailed session retrospective report"
- Arguments: None
- Flags: `--verbose`, `--dry-run`
- Implementation: Reference to existing `rrr` short code functionality
- Backward compatibility: Document that `rrr` continues to work

### T006: Update CLAUDE.md with slash command documentation
**File Path**: `CLAUDE.md`
**Description**: Document new slash commands in main Claude Code documentation
**Actions**:
1. Add section for new slash commands
2. Document both slash commands and original short codes
3. Provide usage examples for both methods
4. Maintain backward compatibility information

### T007: Create manual testing procedures
**File Path**: `.claude/tests/manual-testing.md`
**Description**: Create comprehensive manual testing guide
**Content Requirements**:
- Test scenarios from quickstart.md
- Step-by-step testing procedures
- Expected results for each test
- Backward compatibility verification steps

### T008: Execute quickstart validation scenarios
**Description**: Run through all manual test scenarios from quickstart.md
**Actions**:
1. Test command discovery (auto-complete)
2. Test each slash command individually
3. Test flag functionality (--verbose, --dry-run)
4. Verify backward compatibility
5. Document any issues found

### T009: Verify backward compatibility
**Description**: Ensure both old short codes and new slash commands work
**Actions**:
1. Test original short codes: `ccc`, `nnn`, `rrr`
2. Test new slash commands: `/context`, `/plan`, `/retrospective`
3. Verify identical functionality between old and new methods
4. Test mixed usage in same session

## Notes
- All tasks use simple markdown files - no compilation needed
- Commands are self-documenting through markdown format
- Manual testing only - no automated test framework required
- Backward compatibility maintained throughout
- Implementation estimated at <1 hour total (constitutional compliance)

## Task Generation Rules
*Applied during main() execution*

1. **From Data Model**:
   - 3 command mappings → 3 markdown file creation tasks (T003-T005)
   - Simple structure → minimal setup tasks

2. **From Contracts**:
   - command-template.md → template for all command files
   - No complex API contracts → no contract tests needed

3. **From Quickstart**:
   - Manual testing procedures → validation tasks (T008-T009)
   - Implementation time tracking → ensures <1 hour completion

4. **Ordering**:
   - Setup → Core Files → Documentation → Testing
   - All command files can be created in parallel
   - No complex dependencies

## Validation Checklist
*GATE: Checked by main() before returning*

- [x] All commands have creation tasks (T003-T005)
- [x] All tasks specify exact file paths
- [x] Parallel tasks are truly independent (different files)
- [x] No complex build or compilation steps
- [x] Manual testing covers all scenarios
- [x] Backward compatibility maintained
- [x] Total estimated time <1 hour
- [x] Constitutional simplicity principles followed

---
**Total Tasks**: 9 (simplified from 44)
**Parallel Groups**: 1 group with 3 parallel tasks
**Estimated Duration**: ~45 minutes (perfect constitutional compliance)
**Complexity**: Minimal - just markdown file creation