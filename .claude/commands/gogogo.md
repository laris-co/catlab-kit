# Execute Implementation Command (gogogo)

Execute the most recent plan issue step-by-step with full implementation.

## Usage
```
gogogo
gogogo #123  (execute specific plan issue)
```

## Example
```
gogogo
gogogo #45  (execute plan from issue #45)
```

## What this command does

I will find and execute the implementation plan from the most recent `plan:` labeled issue:

1. **Find Implementation Issue**:
   - Locate most recent issue with `plan:` label
   - Or use specific issue number if provided
   - Verify issue contains implementation steps

2. **Execute Step-by-Step**:
   - Follow the plan in dependency order
   - Make all necessary code changes
   - Handle file operations (create, edit, refactor)
   - Install dependencies if needed
   - Update configuration files

3. **Test & Verify**:
   - Run relevant tests and linting
   - Verify implementation works correctly
   - Check for build errors or warnings
   - Validate against success criteria

4. **Commit & Track**:
   - Stage and commit changes with descriptive message
   - Push to feature branch if needed
   - Create or update PR
   - Update issue with progress

## Implementation Features

✅ **Plan-driven execution** - Follows detailed implementation steps
✅ **Dependency handling** - Respects task prerequisites
✅ **Quality assurance** - Tests and validates changes
✅ **Git workflow** - Proper branching and commits
✅ **Progress tracking** - Updates issues and PRs

## Safety Features

- **Dry-run option** - Preview changes before executing
- **Step confirmation** - Confirm each major step
- **Rollback capability** - Undo changes if needed
- **Backup creation** - Save state before major changes

## Command Flow

1. Find most recent `plan:` issue or use specified issue
2. Parse implementation steps from issue description
3. Create feature branch if needed
4. Execute each step in order:
   - File operations (create/edit/delete)
   - Code changes and refactoring
   - Dependency installation
   - Configuration updates
5. Run tests and quality checks
6. Commit changes with descriptive message
7. Create/update PR with implementation summary
8. Update issue with completion status

## Integration with Workflow

This completes the `ccc` → `nnn` → `gogogo` pattern:
- `ccc`: Capture context and compact conversation
- `nnn`: Create comprehensive implementation plan
- `gogogo`: Execute the plan with full implementation

## Success Criteria

- All implementation steps completed successfully
- Tests pass and build succeeds
- Code follows project conventions
- PR created and linked to issue
- Implementation meets acceptance criteria