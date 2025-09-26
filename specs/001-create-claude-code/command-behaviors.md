# Expected Command Behaviors: Claude Code Short Commands

**Feature**: 001-create-claude-code
**Created**: 2025-09-26
**Purpose**: Document expected behavior for each command for testing validation

## Command Behavior Specifications

### cc-ccc (Context & Compact) Behavior

#### Primary Function
Create GitHub context issue and compact current conversation to prepare for handoff or continuation.

#### Expected Inputs
- **Git Repository**: Must be in a git repository
- **Session State**: Active Claude Code conversation
- **Optional**: Issue template preferences

#### Expected Processing
1. **Git Status Analysis**:
   - Run `git status --porcelain` to detect changes
   - Capture current branch information
   - Document uncommitted files and their states

2. **Session Context Capture**:
   - Gather recent conversation highlights
   - Identify current focus and objectives
   - Note any pending decisions or blockers

3. **GitHub Issue Creation**:
   - Use `gh issue create` with structured template
   - Include git status, session state, next steps
   - Tag appropriately for context filtering

4. **Conversation Compacting**:
   - Execute Claude Code's `/compact` functionality
   - Preserve essential context for continuation

#### Expected Outputs
- **GitHub Issue**: Created with context information
- **Compact Status**: Confirmation of conversation compacting
- **Smart Suggestions**: Next recommended workflow steps

#### Smart Suggestions Logic
```
IF git has uncommitted changes THEN
  Suggest: "Git changes detected - good time for context capture"
ELSIF recent context issue exists THEN
  Suggest: "Consider `/cc-nnn` to create implementation plan"
ELSE
  Suggest: "Context captured - ready for planning or handoff"
```

#### Expected Error Handling
- **No Git Repo**: "Must be run in a git repository"
- **No GitHub Auth**: "GitHub CLI not authenticated - run `gh auth login`"
- **Network Issues**: "Cannot create issue - working offline"

### cc-nnn (Smart Planning) Behavior

#### Primary Function
Analyze current context and create detailed implementation plan (analysis only - NO file modifications).

#### Expected Inputs
- **Context Source**: Recent context issue OR explicit issue reference (`/cc-nnn #123`)
- **Git Repository**: For codebase analysis
- **Project Structure**: To understand architecture

#### Expected Processing
1. **Context Detection**:
   - IF no issue specified: Find most recent context issue
   - IF issue specified: Load specified issue content
   - IF no context found: Error with suggestion to run cc-ccc first

2. **Codebase Analysis**:
   - Scan relevant files and directories
   - Identify patterns, frameworks, dependencies
   - Understand existing architecture and conventions

3. **Implementation Planning**:
   - Break down requirements into actionable steps
   - Consider technical constraints and dependencies
   - Create detailed task breakdown with file paths

4. **Plan Issue Creation**:
   - Use `gh issue create` with implementation plan template
   - Include technical analysis, step-by-step plan, risks
   - Link to original context issue

#### Expected Outputs
- **Implementation Plan Issue**: Detailed GitHub issue with plan
- **Analysis Summary**: Brief overview of approach
- **Smart Suggestions**: Next steps (usually cc-gogogo)

#### Critical Constraints
- **NO FILE MODIFICATIONS**: Must be analysis and planning only
- **NO CODE WRITING**: Cannot implement, only plan
- **NO DESTRUCTIVE ACTIONS**: Read-only operations only

#### Smart Suggestions Logic
```
IF no context issue found THEN
  Suggest: "Run `/cc-ccc` first to create context"
ELSIF plan created successfully THEN
  Suggest: "Use `/cc-gogogo` to execute this plan"
ELSE
  Suggest: "Review plan issue and refine if needed"
```

#### Expected Error Handling
- **No Context Found**: "No recent context - run `/cc-ccc` first"
- **Invalid Issue**: "Issue #123 not found or inaccessible"
- **Analysis Failures**: "Cannot analyze codebase - check file permissions"

### cc-rrr (Retrospective) Behavior

#### Primary Function
Generate comprehensive session retrospective with timeline, learnings, and structured documentation.

#### Expected Inputs
- **Git History**: Recent commits and file changes
- **Session Duration**: Start/end times and major events
- **Work Artifacts**: Files created, issues addressed, PRs made

#### Expected Processing
1. **Session Data Collection**:
   - Use `git log --oneline main...HEAD` for commits
   - Use `git diff --name-only main...HEAD` for file changes
   - Capture session timeline and major events

2. **Retrospective Generation**:
   - Create structured markdown with required sections
   - Include AI Diary (first-person session narrative)
   - Include Honest Feedback (frank assessment)
   - Document lessons learned and next steps

3. **File Export**:
   - Save to `retrospectives/YYYY/MM/` directory structure
   - Use timestamp-based filename for uniqueness
   - Commit retrospective file to repository

4. **GitHub Integration**:
   - Comment on relevant issues/PRs with retrospective link
   - Update related GitHub artifacts

#### Expected Outputs
- **Retrospective File**: Structured markdown in retrospectives/ directory
- **Git Commit**: Retrospective committed to repository
- **GitHub Comments**: Links added to relevant issues/PRs

#### Required Sections (MUST include all)
- Session Summary and Timeline
- Technical Details (files modified, decisions made)
- **AI Diary** (first-person narrative - MANDATORY)
- What Went Well / What Could Improve
- **Honest Feedback** (frank assessment - MANDATORY)
- Lessons Learned
- Next Steps

#### Smart Suggestions Logic
```
IF meaningful session activity detected THEN
  Suggest: "Good time to document learnings"
ELSIF no significant changes THEN
  Suggest: "Limited activity - consider shorter summary"
ELSE
  Suggest: "Retrospective created - ready for next session"
```

#### Expected Error Handling
- **No Git History**: "No recent changes to retrospect on"
- **File Permission Issues**: "Cannot write to retrospectives/ directory"
- **Missing Required Sections**: Warning about incomplete retrospective

### cc-gogogo (Execute Implementation) Behavior

#### Primary Function
Execute the most recent implementation plan step-by-step with file modifications allowed.

#### Expected Inputs
- **Implementation Plan**: Most recent plan issue from cc-nnn
- **Git Repository**: For making changes and commits
- **File System**: Write access for implementation

#### Expected Processing
1. **Plan Detection**:
   - Find most recent implementation plan issue
   - Parse plan structure and extract actionable steps
   - Validate plan completeness and feasibility

2. **Step-by-Step Execution**:
   - Execute each plan step in dependency order
   - Allow file modifications, code writing, system changes
   - Provide progress updates and confirmations

3. **Change Management**:
   - Commit logical groups of changes
   - Use descriptive commit messages referencing plan
   - Create or update feature branch as needed

4. **Completion Tracking**:
   - Mark completed steps in plan issue
   - Update GitHub issue with progress
   - Provide final summary of changes made

#### Expected Outputs
- **File Modifications**: Code changes as specified in plan
- **Git Commits**: Logical commits with clear messages
- **GitHub Updates**: Plan issue updated with progress
- **Summary Report**: Overview of implemented changes

#### Execution Permissions
- **FILE MODIFICATIONS ALLOWED**: Can write, edit, delete files
- **GIT OPERATIONS ALLOWED**: Can commit, branch, merge
- **SYSTEM OPERATIONS ALLOWED**: Can run build, test, install commands

#### Smart Suggestions Logic
```
IF no recent plan found THEN
  Suggest: "Run `/cc-nnn` first to create implementation plan"
ELSIF plan execution successful THEN
  Suggest: "Use `/cc-rrr` to document this session"
ELSIF execution failed THEN
  Suggest: "Review errors and consider `/cc-nnn` to replan"
```

#### Expected Error Handling
- **No Plan Found**: "No recent implementation plan - run `/cc-nnn` first"
- **Plan Parse Errors**: "Cannot parse plan format - check plan structure"
- **Execution Failures**: "Step X failed: [specific error] - suggest fixes"
- **Permission Errors**: "Cannot modify files - check permissions"

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