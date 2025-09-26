
# Implementation Plan: Migrate Short Codes to Claude Code Slash Commands

**Branch**: `001-migrate-short-code` | **Date**: 2025-09-26 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-migrate-short-code/spec.md`

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
Migrate existing short codes (`ccc`, `nnn`, `rrr`) from Claude.md to proper Claude Code slash commands (`/context`, `/plan`, `/retrospective`) while maintaining backward compatibility. Implementation will use simple markdown files for command definitions instead of complex TypeScript modules.

## Technical Context
**Language/Version**: Markdown (simple text files for command definitions)
**Primary Dependencies**: Claude Code's existing command infrastructure
**Storage**: Local markdown files in `.claude/commands/` directory
**Testing**: Manual testing through Claude Code interface
**Target Platform**: Claude Code (VS Code-based environment)
**Project Type**: single - Simple markdown-based command definitions
**Performance Goals**: Instant command discovery via auto-complete
**Constraints**: Must maintain backward compatibility with existing short codes
**Scale/Scope**: 3 primary commands with 2 common flags each

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### I. Simplicity First
- ✅ PASS: Using simple markdown files instead of complex TypeScript
- ✅ PASS: Minimal command definitions with only essential functionality
- ✅ PASS: Leveraging existing Claude Code command infrastructure

### II. Safety by Default
- ✅ PASS: No force flags in design
- ✅ PASS: Dry-run option for preview mode
- ✅ PASS: Structured error handling with remedies

### III. Incremental Development
- ✅ PASS: Each command can be created independently
- ✅ PASS: Simple markdown files are <1 hour tasks
- ✅ PASS: Phased approach: create → test → enhance

### IV. Orchestrator-Worker Pattern
- ✅ PASS: Commands maintain existing orchestrator patterns
- ✅ PASS: Clear separation using markdown file approach

### V. Explicit Over Implicit
- ✅ PASS: Descriptive command names
- ✅ PASS: Clear markdown format
- ✅ PASS: Explicit file paths and structures

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
```
.claude/
├── commands/
│   ├── context.md       # /context command definition
│   ├── plan.md          # /plan command definition
│   └── retrospective.md # /retrospective command definition
└── tests/
    └── manual-testing.md # Manual test scenarios

CLAUDE.md                 # Updated with new command documentation
```

**Structure Decision**: Simple markdown-based structure using Claude Code's existing `.claude/commands/` directory for command definitions. No TypeScript compilation or complex build processes needed.

## Phase 0: Outline & Research
1. **Research simplified approach**:
   - Claude Code markdown command format
   - How to leverage existing short code functionality
   - Backward compatibility mechanisms

2. **Key research questions**:
   - What is the exact markdown format for Claude Code commands?
   - How do existing short codes (ccc, nnn, rrr) work?
   - How to maintain both slash commands and short codes?

3. **Consolidate findings** in `research.md`:
   - Decision: Use simple markdown files
   - Rationale: Aligns with constitutional simplicity principle
   - Alternatives: Complex TypeScript rejected for over-engineering

**Output**: research.md with simplified implementation approach

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Define simple data model** → `data-model.md`:
   - Command markdown file structure
   - Backward compatibility mapping
   - Simple flag handling

2. **Document command format** → `/contracts/`:
   - Markdown template for slash commands
   - Command metadata structure
   - No complex API contracts needed

3. **Create test scenarios** → `quickstart.md`:
   - Manual testing procedures
   - Backward compatibility verification
   - Command discovery testing

4. **Update agent file**:
   - Run `.specify/scripts/bash/update-agent-context.sh claude`
   - Document simplified markdown approach

**Output**: data-model.md, /contracts/command-template.md, quickstart.md, CLAUDE.md updates

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Create 3 simple markdown files for commands
- Set up manual testing procedures
- Update documentation
- Much simpler than previous TypeScript approach

**Ordering Strategy**:
- Setup command directory structure
- Create individual command markdown files [P]
- Test each command manually
- Update documentation

**Estimated Output**: 8-10 simple tasks in tasks.md

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
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [x] All NEEDS CLARIFICATION resolved
- [x] Complexity deviations documented (none needed)

---
*Based on Constitution v1.0.0 - See `.specify/memory/constitution.md`*
