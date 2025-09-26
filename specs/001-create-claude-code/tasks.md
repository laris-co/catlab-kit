# Tasks: Claude Code Custom Command Migration

**Input**: Design documents from `/home/floodboy/catlab-kit/specs/001-create-claude-code/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/, quickstart.md

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → Tech stack: Markdown (Claude Code custom commands), CLI tooling enhancement
   → Structure: Single project - .claude/commands/*.md files
2. Load design documents:
   → data-model.md: 4 command entities (cc-ccc, cc-nnn, cc-rrr, cc-gogogo)
   → contracts/: Command interface specifications
   → research.md: Simple file-based approach, existing patterns
3. Generate tasks by category:
   → Setup: Directory structure, template preparation
   → Tests: Manual integration testing with Claude Code CLI
   → Core: 4 individual command files
   → Integration: Workflow chaining, smart suggestions
   → Polish: Documentation, usage examples
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Manual testing approach (no automated test framework)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Single project**: `.claude/commands/` at repository root
- All command files follow pattern: `.claude/commands/cc-*.md`

## Phase 3.1: Setup
- [x] T001 Create .claude/commands/ directory structure if not exists
- [x] T002 [P] Analyze existing .claude/commands/compare-analyse.md pattern for template reference

## Phase 3.2: Manual Testing Preparation ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: Test scenarios must be prepared before implementation**
- [x] T003 [P] Create manual test plan in specs/001-create-claude-code/test-plan.md
- [x] T004 [P] Document expected behavior for each command in test scenarios
- [x] T005 [P] Prepare git test repository state for workflow testing

## Phase 3.3: Core Command Implementation (ONLY after test preparation)
- [ ] T006 [P] Create cc-ccc.md command file in .claude/commands/cc-ccc.md
- [ ] T007 [P] Create cc-nnn.md command file in .claude/commands/cc-nnn.md
- [ ] T008 [P] Create cc-rrr.md command file in .claude/commands/cc-rrr.md
- [ ] T009 [P] Create cc-gogogo.md command file in .claude/commands/cc-gogogo.md

## Phase 3.4: Smart Suggestions Integration
- [ ] T010 Add context-aware suggestions to cc-ccc.md (detect git changes)
- [ ] T011 Add workflow suggestions to cc-nnn.md (check for recent context)
- [ ] T012 Add plan detection to cc-gogogo.md (find recent plan issue)
- [ ] T013 Add session detection to cc-rrr.md (meaningful activity check)

## Phase 3.5: Integration & Workflow Testing
- [ ] T014 [P] Test cc-ccc command with Claude Code CLI
- [ ] T015 [P] Test cc-nnn command with Claude Code CLI
- [ ] T016 [P] Test cc-rrr command with Claude Code CLI
- [ ] T017 [P] Test cc-gogogo command with Claude Code CLI
- [ ] T018 Test complete workflow sequence (ccc → nnn → gogogo → rrr)

## Phase 3.6: Polish & Documentation
- [ ] T019 [P] Update quickstart.md with verified usage examples
- [ ] T020 [P] Create troubleshooting guide for common command issues
- [ ] T021 [P] Validate command conflict prevention (cc- prefix verification)
- [ ] T022 Document integration with existing GitHub/git workflows
- [ ] T023 Final validation against constitutional principles

## Dependencies
- Setup (T001-T002) before test preparation (T003-T005)
- Test preparation (T003-T005) before implementation (T006-T009)
- Core implementation (T006-T009) before smart suggestions (T010-T013)
- Smart suggestions (T010-T013) before integration testing (T014-T017)
- Individual tests (T014-T017) before workflow testing (T018)
- Implementation complete before polish (T019-T023)

## Parallel Example
```
# Launch T006-T009 together (core command files):
Task: "Create cc-ccc.md command file following data-model.md specification for Context & Compact workflow"
Task: "Create cc-nnn.md command file following data-model.md specification for Next/Planning workflow"
Task: "Create cc-rrr.md command file following data-model.md specification for Retrospective workflow"
Task: "Create cc-gogogo.md command file following data-model.md specification for Execute Implementation workflow"
```

## Detailed Task Specifications

### T006: Create cc-ccc.md command file
- **File**: `.claude/commands/cc-ccc.md`
- **Based on**: data-model.md command structure, contracts/command-interface.md
- **Behavior**: Create context issue, compact conversation, smart suggestions
- **Dependencies**: GitHub CLI (gh), git operations
- **Template**: Follow existing .claude/commands pattern with frontmatter description

### T007: Create cc-nnn.md command file
- **File**: `.claude/commands/cc-nnn.md`
- **Based on**: data-model.md command structure, contracts/command-interface.md
- **Behavior**: Smart planning workflow, analysis only (NO file modifications)
- **Dependencies**: GitHub issue analysis, codebase scanning
- **Critical**: Include explicit "DO NOT modify/implement/write files" constraint

### T008: Create cc-rrr.md command file
- **File**: `.claude/commands/cc-rrr.md`
- **Based on**: data-model.md command structure, contracts/command-interface.md
- **Behavior**: Generate session retrospective with timeline and learnings
- **Dependencies**: Git history, session data collection
- **Output**: Structured markdown in retrospectives/ directory

### T009: Create cc-gogogo.md command file
- **File**: `.claude/commands/cc-gogogo.md`
- **Based on**: data-model.md command structure, contracts/command-interface.md
- **Behavior**: Execute most recent implementation plan step-by-step
- **Dependencies**: Issue tracking, file operations allowed
- **Constraint**: Must validate plan exists before executing

## Success Criteria Validation
- [ ] All 4 commands work as native Claude Code commands
- [ ] cc- prefix prevents conflicts with existing commands
- [ ] Smart suggestions provide context-aware workflow guidance
- [ ] Original CLAUDE.md functionality preserved and enhanced
- [ ] Manual testing validates each command and workflow sequences
- [ ] Commands integrate seamlessly with existing development process
- [ ] Constitutional compliance maintained (simplicity, user control, safety)

## Notes
- [P] tasks = different files, no dependencies
- Manual testing approach due to CLI tooling nature
- Commit after each major task (T006-T009, T018, T023)
- Follow "simple way" approach per user preference
- Leverage existing infrastructure patterns from compare-analyse.md

## Task Generation Rules Applied
1. **From Data Model**: 4 command entities → 4 implementation tasks [P]
2. **From Contracts**: Interface specifications → smart suggestions tasks
3. **From Research**: Simple file-based approach → minimal setup tasks
4. **From Quickstart**: Usage scenarios → manual testing tasks
5. **Ordering**: Setup → Tests → Models → Integration → Polish
6. **CLI Tool Pattern**: Manual testing instead of automated test suite

## Validation Checklist
*GATE: All items verified before implementation complete*
- [ ] All 4 commands have corresponding .md files
- [ ] All commands follow contract interface specifications
- [ ] Manual test scenarios prepared before implementation
- [ ] Parallel tasks truly independent (different files)
- [ ] Each task specifies exact file path
- [ ] Constitutional principles maintained throughout
- [ ] Smart workflow suggestions implemented and tested