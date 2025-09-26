# Expected Command Behaviors: Claude Code Short Commands

**Feature**: 001-create-claude-code
**Created**: 2025-09-26
**Purpose**: Document expected behavior for each command for testing validation

## Command Behavior Specifications

### cc-ccc (Context & Compact) Behavior

**Preconditions**
- Run inside a git repository with `git` and `gh` authenticated
- Conversation has actionable focus, blockers, and next intentions documented
- Optional flags: `--title`, `--labels`, `--no-compact`

**Execution Steps**
1. Parse arguments; default to title `Context: <branch> (<YYYY-MM-DD>)` and label `context`.
2. Capture repo snapshot (`git rev-parse --abbrev-ref HEAD`, `git status --porcelain`, `git log --oneline -5`).
3. Summarise conversation focus, decisions, blockers, and next steps.
4. Compose markdown body with sections: Session Snapshot, Uncommitted Files, Conversation Focus, Next Intentions, Suggested Commands.
5. Create GitHub context issue via `gh issue create ... --body-file <temp>`.
6. Run `/compact` unless skipped, then emit workflow suggestion.

**Outputs**
- GitHub context issue URL with captured repo + conversation state
- Compact command status (invoked or skipped)
- Suggested next command (usually `/cc-nnn`)

**Smart Suggestions Logic**
- Git tree dirty → "Git changes detected - context captured, review or stage next."
- Recent context already exists → Suggest `/cc-nnn` to move into planning.
- Clean slate → Confirm readiness for planning or implementation.

**Failure Modes**
- Not a git repo → abort with guidance
- `gh` unauthenticated → instruct `gh auth login`
- Network/creation failure → preserve body and surface retry path
- Insufficient conversation detail → prompt user for summary before retry
### cc-nnn (Smart Planning) Behavior

**Preconditions**
- Context issue exists (auto-detected or supplied via `#123` argument)
- Repo accessible with read permissions; working tree may be dirty but will not be modified
- `gh` authenticated and able to read linked issues
- Strict ANALYSIS ONLY contract enforced

**Execution Steps**
1. Resolve context: use argument reference or fetch newest open `context` issue; abort if none found.
2. Validate repository and tooling availability (fail fast on auth or permission errors).
3. Ingest context issue body plus referenced artifacts for research.
4. Inspect codebase read-only (tree scan, dependency map, targeted file reads).
5. Draft plan sections: Summary/Intent, Research & Insights, Implementation Strategy, Task Breakdown, Testing & Validation, Risks & Mitigations, Next Commands.
6. Publish `Plan:` GitHub issue with labels (`plan`, component tags) linking back to the context issue.
7. Emit workflow recommendation (typically `/cc-gogogo`).

**Outputs**
- GitHub plan issue URL
- Ordered phase overview and risk callouts
- Reminder that no files were modified

**Smart Suggestions Logic**
- No context found → Prompt `/cc-ccc`
- Plan created → Suggest `/cc-gogogo`
- Analysis blocked → Direct to fix permissions or refresh context

**Failure Modes**
- Missing/invalid context issue
- `gh` permission errors
- Repository unreadable (e.g., missing files, analysis command failures)
### cc-rrr (Retrospective) Behavior

**Preconditions**
- Recent session activity (commits, diffs, or decisions worth documenting)
- Git history accessible (`git log`, `git diff`)
- `retrospectives/` directory writable; optional `--issue` argument for linking

**Execution Steps**
1. Gather session evidence (window/timestamps, `git log main...HEAD`, `git diff --name-only main...HEAD`).
2. Build retrospective markdown ensuring required sections: Session Summary & Timeline, Technical Details, AI Diary, What Went Well / What Could Improve, Honest Feedback, Lessons Learned, Next Steps, plus Blockers & Resolutions when applicable.
3. Write timestamped file under `retrospectives/YYYY/MM/` using UTC filename and GMT+7 display time.
4. Stage and commit the retrospective; if `--issue` provided, comment with link + highlights.
5. Suggest follow-on commands (usually `/cc-ccc` or `/cc-nnn`).

**Outputs**
- Retrospective file path in repo
- Commit referencing the retrospective (or staged changes awaiting commit)
- Optional GitHub comment linking the retrospective

**Smart Suggestions Logic**
- High session activity → Encourage immediate documentation to preserve detail
- Low activity → Offer shorter summary guidance
- Successful export → Recommend next workflow command

**Failure Modes**
- No meaningful changes detected → Abort with instruction to run after implementation
- Cannot write to `retrospectives/` → Surface permission/directory fix
- Mandatory sections incomplete → Block finalisation until filled
### cc-gogogo (Execute Implementation) Behavior

**Preconditions**
- Most recent `/cc-nnn` plan issue exists and is accessible
- Working tree ready for modification (clean or intentionally staged for execution)
- Tooling/runtime dependencies installed as per plan

**Execution Steps**
1. Resolve plan source (argument or newest open plan issue) and validate structure (phases, tasks, acceptance criteria, `[P]` markers).
2. Prepare workspace: checkout/create branch, install dependencies, configure environment.
3. Execute tasks in plan order, respecting dependencies and TDD expectations; run validations (tests, linters) per task.
4. Group changes into logical commits referencing plan issue; avoid force pushes and preserve reviewable history.
5. Update plan issue progress (checkboxes/comments), create or update PR with testing evidence, and record blockers/deviations.
6. Run final verification suite and summarise outcomes for the user, recommending `/cc-rrr`.

**Outputs**
- Code/documentation changes in repo
- Commits (and optional PR) referencing the plan issue
- Updated plan issue status
- Test/verification results reported back to the user

**Smart Suggestions Logic**
- Missing plan → Prompt `/cc-nnn`
- Successful run → Suggest `/cc-rrr`
- Failure mid-step → Highlight failing step and recommend remediation before retry

**Failure Modes**
- Plan not found or unreadable
- Task execution failure (tests, builds)
- Git conflicts or permission errors during commits/pushes
- Environment setup gaps (missing dependencies)
## Smart Workflow Suggestions System

### Context Detection Logic
The smart suggestions system analyzes current project state:

```
PROJECT_STATE = {
  git_status: "clean" | "dirty",
  recent_context_issue: boolean,
  recent_plan_issue: boolean,
  session_activity: "low" | "medium" | "high"
}

SUGGESTION_ENGINE = {
  IF git_status == "dirty" THEN suggest cc-ccc
  ELSIF recent_context_issue && !recent_plan_issue THEN suggest cc-nnn
  ELSIF recent_plan_issue && !implementation_done THEN suggest cc-gogogo
  ELSIF session_activity >= "medium" THEN suggest cc-rrr
  ELSE suggest workflow assessment
}
```

### Cross-Command Context Flow
Commands share context through GitHub issues and git state:

1. **cc-ccc** creates context → enables cc-nnn
2. **cc-nnn** creates plan → enables cc-gogogo
3. **cc-gogogo** implements changes → suggests cc-rrr
4. **cc-rrr** documents session → suggests new cycle

### Workflow State Prevention
Commands validate prerequisites to prevent invalid states:

- **cc-nnn** checks for context before planning
- **cc-gogogo** validates plan exists before executing
- **cc-rrr** ensures meaningful activity before retrospecting

## Testing Validation Points

Each behavior specification includes:
- **Input validation**: Required vs. optional inputs
- **Processing verification**: Expected internal operations
- **Output validation**: Required outputs and formats
- **Error handling**: Expected error scenarios and messages
- **Smart suggestions**: Context-aware next step recommendations

This comprehensive behavior specification ensures consistent testing and validation of all command functionality.