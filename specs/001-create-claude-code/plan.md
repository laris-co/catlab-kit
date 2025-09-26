
# Implementation Plan: Claude Code Custom Command Migration

**Branch**: `001-create-claude-code` | **Date**: 2025-09-26 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/home/floodboy/catlab-kit/specs/001-create-claude-code/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from file system structure or context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, `GEMINI.md` for Gemini CLI, `QWEN.md` for Qwen Code or `AGENTS.md` for opencode).
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
Migrate 4 short codes (ccc, nnn, rrr, gogogo) from CLAUDE.md to Claude Code custom commands with cc- prefix to avoid conflicts. Preserve original functionality while adding smart workflow suggestions based on current project state. Simple approach focusing on markdown-based command definitions.

## Technical Context
**Language/Version**: Markdown (Claude Code custom commands)
**Primary Dependencies**: Claude Code framework, existing .claude/commands infrastructure
**Storage**: File-based (.claude/commands/*.md files)
**Testing**: Manual testing with Claude Code CLI
**Target Platform**: Claude Code development environment
**Project Type**: Single project - CLI tooling enhancement
**Performance Goals**: Instant command recognition and execution
**Constraints**: Must not conflict with existing Claude Code commands, maintain backward compatibility
**Scale/Scope**: 4 commands, simple integration, user preference: "we still going simple way"

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Simplicity First ✅
Simple approach requested: "we still going simple way" - markdown-based commands without complex infrastructure.

### User Choice & Control ✅
Commands are optional - users can continue using existing workflows or adopt new short codes.

### Safety First ✅
cc- prefix prevents conflicts with existing commands. No destructive operations without confirmation.

### Infrastructure Reuse ✅
Leverages existing .claude/commands structure and patterns from compare-analyse.md and research.md.

### Background Execution Support ✅
Commands can delegate to existing background-capable scripts like codex-research.sh.

**Gate Status**: PASS - All constitutional principles satisfied with simple approach.

## Project Structure

### Documentation (this feature)
```
specs/[###-feature]/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->
```
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Phase 0: Outline & Research
1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task

2. **Generate and dispatch research agents**:
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Generate contract tests** from contracts:
   - One test file per endpoint
   - Assert request/response schemas
   - Tests must fail (no implementation yet)

4. **Extract test scenarios** from user stories:
   - Each story → integration test scenario
   - Quickstart test = story validation steps

5. **Update agent file incrementally** (O(1) operation):
   - Run `.specify/scripts/bash/update-agent-context.sh claude`
     **IMPORTANT**: Execute it exactly as specified above. Do not add or remove any arguments.
   - If exists: Add only NEW tech from current plan
   - Preserve manual additions between markers
   - Update recent changes (keep last 3)
   - Keep under 150 lines for token efficiency
   - Output to repository root

**Output**: data-model.md, /contracts/*, failing tests, quickstart.md, agent-specific file

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Create 4 individual command implementation tasks
- Each command file → creation task (cc-ccc.md, cc-nnn.md, cc-rrr.md, cc-gogogo.md)
- Smart suggestions logic → context detection task
- Integration testing → workflow sequence validation task
- Documentation → usage examples and troubleshooting

**Priority Order**:
1. [P] Create cc-ccc.md (Context & Compact command)
2. [P] Create cc-nnn.md (Planning command - analysis only)
3. [P] Create cc-gogogo.md (Implementation execution command)
4. [P] Create cc-rrr.md (Retrospective command)
5. [S] Add smart workflow suggestions to all commands
6. [S] Test complete workflow sequences
7. [S] Create usage documentation and troubleshooting guide

## Progress Tracking

### Phase 0: Research ✅ COMPLETE
- [x] Feature spec analysis complete
- [x] Short code behavior patterns documented
- [x] Claude Code command structure analyzed
- [x] Constitutional compliance verified
- [x] Technical feasibility confirmed

### Phase 1: Design & Artifacts ✅ COMPLETE
- [x] data-model.md created with command structure
- [x] contracts/command-interface.md created with interface specs
- [x] quickstart.md created with usage examples
- [x] CLAUDE.md created with agent guidelines
- [x] Post-design constitution check: PASS

### Phase 2: Ready for /tasks Command
**Status**: READY - All planning artifacts complete

**Next Steps**:
1. Run `/tasks` command to generate implementation tasks
2. Execute tasks to create 4 command files in `.claude/commands/`
3. Test workflow sequences and smart suggestions
4. Validate integration with Claude Code CLI

**Key Deliverables Produced**:
- ✅ research.md - Technical research and feasibility
- ✅ data-model.md - Command data structures and contracts
- ✅ contracts/command-interface.md - Interface specifications
- ✅ quickstart.md - Usage guide and examples
- ✅ CLAUDE.md - Agent implementation guidelines

**Planning Complete**: Ready for task generation and implementation phases.

**Ordering Strategy**:
- TDD order: Tests before implementation 
- Dependency order: Models before services before UI
- Mark [P] for parallel execution (independent files)

**Estimated Output**: 25-30 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |


## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [ ] Phase 0: Research complete (/plan command)
- [ ] Phase 1: Design complete (/plan command)
- [ ] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [ ] Initial Constitution Check: PASS
- [ ] Post-Design Constitution Check: PASS
- [ ] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented

---
*Based on Constitution v2.1.1 - See `/memory/constitution.md`*
