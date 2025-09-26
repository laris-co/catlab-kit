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
Migrate existing short codes (`ccc`, `nnn`, `rrr`) from Claude.md to proper Claude Code slash commands (`/context`, `/plan`, `/retrospective`) while maintaining backward compatibility. The new commands will be discoverable through auto-complete, support common flags (`--verbose`, `--dry-run`), and provide structured error handling.

## Technical Context
**Language/Version**: TypeScript/Node.js (Claude Code extension environment)
**Primary Dependencies**: Claude Code API, VS Code Extension API
**Storage**: Local file system for command definitions
**Testing**: Jest for unit tests, manual testing in Claude Code
**Target Platform**: Claude Code (VS Code-based environment)
**Project Type**: single - Claude Code extension commands
**Performance Goals**: Instant command discovery via auto-complete
**Constraints**: Must maintain backward compatibility with existing short codes
**Scale/Scope**: 3 primary commands with 2 common flags each

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### I. Simplicity First
- ✅ PASS: Starting with exact migration of 3 commands only
- ✅ PASS: Adding only essential flags (`--verbose`, `--dry-run`)
- ✅ PASS: Using existing Claude Code command infrastructure

### II. Safety by Default
- ✅ PASS: No force flags in design
- ✅ PASS: Dry-run option for preview mode
- ✅ PASS: Structured error handling with remedies

### III. Incremental Development
- ✅ PASS: Each command can be implemented independently
- ✅ PASS: Tasks estimated at <1 hour each
- ✅ PASS: Phased approach: migrate → test → enhance

### IV. Orchestrator-Worker Pattern
- ✅ PASS: Commands maintain existing orchestrator patterns
- ✅ PASS: Clear separation of command logic

### V. Explicit Over Implicit
- ✅ PASS: Descriptive command names
- ✅ PASS: Explicit flag behaviors
- ✅ PASS: Clear error messages

## Project Structure

### Documentation (this feature)
```
specs/001-migrate-short-code/
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
├── lib/
│   ├── command-registry.ts
│   ├── error-handler.ts
│   └── flag-parser.ts
└── tests/
    ├── commands/
    └── lib/

CLAUDE.md                 # Updated with new command documentation
```

**Structure Decision**: Single project structure using Claude Code's existing `.claude/commands/` directory for command definitions, with supporting TypeScript libraries in `.claude/lib/`.

## Phase 0: Outline & Research
1. **Extract unknowns from Technical Context** above:
   - Claude Code slash command API specification
   - Existing short code implementation details
   - Command registration mechanism
   - Auto-complete integration requirements

2. **Generate and dispatch research agents**:
   ```
   Task 1: "Research Claude Code slash command API and registration"
   Task 2: "Analyze existing ccc, nnn, rrr implementations in CLAUDE.md"
   Task 3: "Research auto-complete integration in Claude Code"
   Task 4: "Find best practices for command migration and backward compatibility"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all technical decisions documented

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Extract entities from feature spec** → `data-model.md`:
   - SlashCommand entity with name, description, handler
   - CommandRegistry for managing available commands
   - CommandArguments for parsing and validation
   - ErrorResponse with code, message, remedy

2. **Generate API contracts** from functional requirements:
   - Command registration interface
   - Command execution protocol
   - Error response structure
   - Output to `/contracts/command-api.yaml`

3. **Generate contract tests** from contracts:
   - Test command registration
   - Test argument parsing
   - Test error handling
   - Tests must fail initially (TDD approach)

4. **Extract test scenarios** from user stories:
   - Test `/context` executes ccc workflow
   - Test `/plan` with issue number argument
   - Test `/retrospective` generates report
   - Test auto-complete discovery
   - Test backward compatibility

5. **Update agent file incrementally** (O(1) operation):
   - Run `.specify/scripts/bash/update-agent-context.sh claude`
   - Add slash command information to CLAUDE.md
   - Document new command usage

**Output**: data-model.md, /contracts/*, failing tests, quickstart.md, CLAUDE.md updates

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Load `.specify/templates/tasks-template.md` as base
- Generate tasks from Phase 1 design docs (contracts, data model, quickstart)
- Each command → implementation task [P]
- Each flag → parser implementation task
- Each error case → handler task
- Integration tests for backward compatibility

**Ordering Strategy**:
- TDD order: Tests before implementation
- Core infrastructure before commands
- Commands before flags
- Mark [P] for parallel execution where possible

**Estimated Output**: 15-20 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)
**Phase 4**: Implementation (execute tasks.md following constitutional principles)
**Phase 5**: Validation (run tests, execute quickstart.md, verify auto-complete)

## Complexity Tracking
*No violations detected - all constitutional principles satisfied*

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