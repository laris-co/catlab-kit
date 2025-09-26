---
description: Execute the newest `/cc-nnn` implementation plan with full write permissions, reporting progress step-by-step.
---

The user input to you can be provided directly or as `/cc-gogogo <plan-issue>`; inspect it BEFORE proceeding. If no argument is provided you **must** locate the most recent open implementation plan produced by `/cc-nnn`.

User input:

$ARGUMENTS

Goal: Deliver the planned work end-to-end — coding, tests, commits, and PR handoff — while staying faithful to the authored plan. This is Step 3 of the `ccc → nnn → gogogo` workflow.

Execution privileges: File edits, dependency installs, shell commands, tests, commits, branch pushes, and PR creation are all allowed. Destructive git flags (`--force`) remain prohibited.

### Preconditions
- A valid implementation plan issue exists (open, labelled `plan`, authored by `/cc-nnn`).
- Working tree is clean or intentionally dirty only with changes required for this execution.
- Required tooling (language runtimes, test frameworks) is available.

### Execution steps
1. **Resolve the plan source**
   - Use `$ARGUMENTS` issue reference if supplied; otherwise select the newest open plan issue.
   - Abort with guidance (`"No implementation plan found - run /cc-nnn"`) if none qualifies.

2. **Parse the plan**
   - Extract phases, ordered tasks, acceptance criteria, and risk callouts.
   - Identify dependencies (sequence vs `[P]` parallel markers) and required files/tests.
   - Capture referenced branches or environment instructions.

3. **Prepare workspace**
   - Checkout or create the indicated feature branch.
   - Ensure tooling prerequisites from the plan are met (install packages, env setup) while avoiding global destructive changes.

4. **Execute tasks**
   - Process tasks in plan order, respecting dependencies and TDD expectations (write/execute tests before implementation when specified).
   - For each task:
     1. Describe intent before execution.
     2. Apply code/documentation changes.
     3. Run targeted validations (formatters, linters, unit/integration tests).
     4. If a task fails, halt sequence, capture diagnostics, and report blocking details.

5. **Manage version control**
   - Stage logically grouped changes per task or phase.
   - Commit with messages referencing the plan issue (e.g., `fix: implement task 3 (Plan #123)`), summarising what/why.
   - Maintain clean history; never use force push.

6. **Update plan issue**
   - After each completed task/phase, update checkboxes or progress notes in the plan issue via `gh issue comment` or issue editing.
   - Capture blockers or deviations explicitly if the plan had to change.

7. **Create or update pull request**
   - If no PR exists, create one referencing the plan and context issues; include testing evidence.
   - If PR already exists, push updates and leave a concise status comment.

8. **Run final verification**
   - Execute the full test suite or the subset mandated by the plan.
   - Perform manual sanity checks when requested (e.g., screenshot, CLI demo) and attach artefacts if possible.

9. **Report completion**
   - Summarise accomplished tasks, test outcomes, link to commits/PR, and note any follow-up work.
   - Recommend `/cc-rrr` to document the retrospective or `/cc-ccc` if new context needs capturing.

### Error handling
- **No plan issue** → Stop with instruction to run `/cc-nnn`.
- **Plan parsing failure** → Report missing structure; prompt user to correct plan.
- **Task failure** → Halt, log failing command output, suggest remedial action before retry.
- **Git issues** → Stop on merge conflicts or dirty tree, surface resolution steps.

### Completion checklist
- All plan tasks marked complete (or explicitly deferred with rationale).
- Tests executed with results documented.
- Commits pushed and PR updated/created with validation notes.
- Remaining risks, TODOs, or follow-ups captured.

### Follow-on commands
- `/cc-rrr` for formal retrospective.
- `/cc-ccc` if additional context capture is required post-implementation.
- `/cc-nnn` again if plan refresh is needed before next iteration.
