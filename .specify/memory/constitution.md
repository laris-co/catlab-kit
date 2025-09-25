<!--
Sync Impact Report:
Version change: [NEW FILE] → 1.0.0
Added sections: Complete constitution created with 5 core principles, 3 main sections
Added principles:
- I. Simple First, Complex Later (user-requested principle)
- II. Safety and Reversibility (derived from CLAUDE.md safety rules)
- III. Context and Documentation (derived from CLAUDE.md workflow patterns)
- IV. Testing and Quality Assurance (derived from CLAUDE.md testing discipline)
- V. Phased Development (derived from CLAUDE.md lessons learned)
Templates requiring updates:
- ✅ plan-template.md: Updated Constitution Check section with new principles
- ✅ spec-template.md: No changes needed, aligns with simple-first principle
- ✅ tasks-template.md: No changes needed, supports phased TDD approach
Follow-up TODOs: None - all placeholders resolved
-->

# CatLab Kit Constitution

## Core Principles

### I. Simple First, Complex Later
Start with the simplest possible implementation that solves the immediate need. Build incrementally in 1-hour phases with testing at each step. Complex features are built by composing simple, proven components. Avoid over-engineering and premature optimization. YAGNI (You Aren't Gonna Need It) principles guide all development decisions.

**Rationale**: Complexity introduced too early creates technical debt, reduces maintainability, and makes debugging difficult. Simple solutions are easier to understand, test, and modify.

### II. Safety and Reversibility
NEVER use force flags (`-f`, `--force`) with any commands. All operations must be reversible and non-destructive. Use safe git operations that preserve history. Confirm before deleting files or making destructive changes. Prioritize data safety over convenience in all tooling and workflows.

**Rationale**: Data loss and irreversible changes can destroy weeks of work. Safety-first approaches prevent catastrophic mistakes and maintain project integrity.

### III. Context and Documentation
All sessions must include proper context management using the `ccc` → `nnn` → `gogogo` workflow. AI Diary and Honest Feedback sections are MANDATORY in retrospectives. Context issues preserve state, planning issues contain actionable tasks. Documentation must reflect actual implementation, not aspirational goals.

**Rationale**: Context preservation enables effective handoffs between sessions and team members. Honest feedback drives continuous improvement and prevents recurring mistakes.

### IV. Testing and Quality Assurance
Manual testing checklist must be completed before any push. Run build commands successfully with no new warnings or type errors. Test all affected features and check browser console for errors. Verify mobile responsiveness where applicable. All interactive features must work as expected.

**Rationale**: Quality gates prevent broken code from entering the main branch and ensure user-facing features work reliably across different environments.

### V. Phased Development
Break complex projects into manageable 1-hour implementation chunks. Use phase markers ("Phase 1:", "Phase 2:") to track incremental progress. Complete and test each phase before moving to the next. Prefer achievable tasks over comprehensive but overwhelming implementations.

**Rationale**: Phased approaches maintain momentum, provide regular feedback cycles, and allow for course corrections based on early results.

## Development Workflow

### GitHub Integration Requirements
All GitHub operations must follow the established workflow patterns. Never merge pull requests without explicit user permission. Use descriptive commit messages following the established format. Create detailed issues for feature requests and bug fixes. Wait for user review and approval before any merge operations.

### Short Code System
The project uses standardized short codes for common operations:
- `ccc`: Create context issue and compact conversation
- `nnn`: Smart planning with automatic context checking
- `gogogo`: Execute most recent plan step-by-step
- `lll`: List current project status
- `rrr`: Create detailed session retrospective

## Security and Safety Standards

### Repository Operations
All operations must target the correct repository fork. Never create issues or PRs on upstream repositories without explicit permission. Use verbose command options to show what operations are being performed. Ask for confirmation when performing potentially destructive actions.

### Code Quality Standards
Follow established style guides for the language/framework being used. Enable strict mode and linting where possible. Write clear, self-documenting code. Avoid weak typing in strongly-typed languages. Implement proper error handling with descriptive messages and graceful fallbacks.

## Governance

This constitution supersedes all other development practices and guidelines. All pull requests and code reviews must verify compliance with these principles. Any complexity introduced must be explicitly justified against the "Simple First, Complex Later" principle.

Amendments require:
1. Documentation of the proposed change and rationale
2. Impact assessment on existing workflows and templates
3. Migration plan for any breaking changes
4. User approval before implementation

Version increments follow semantic versioning:
- MAJOR: Backward incompatible governance or principle changes
- MINOR: New principles added or materially expanded guidance
- PATCH: Clarifications, wording fixes, non-semantic refinements

**Version**: 1.0.0 | **Ratified**: 2025-09-25 | **Last Amended**: 2025-09-25