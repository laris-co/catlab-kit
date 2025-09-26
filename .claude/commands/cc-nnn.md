---
description: Analyse captured context and publish a GitHub implementation plan without modifying the working tree.
---

The user input to you can be provided directly or via `/cc-nnn <issue-ref>`; you **MUST** inspect it before acting. Accept `#123` or full URLs to target a specific context issue. No other flags are supported.

User input:

$ARGUMENTS

Goal: Transform the latest context into a detailed execution plan while honouring the **analysis-only** contract. This is Step 2 of the `ccc → nnn → gogogo` pattern.

Hard constraints:
- Absolutely **no** file writes, staging, commits, or destructive operations.
- Operate in read-only mode; shell commands should inspect only.
- Output must be a GitHub "Plan" issue plus an in-chat summary.

### Preconditions
- Fresh `ccc` issue exists (either detected automatically or supplied via argument).
- Running inside a git repo with `git` and `gh` available.
- Sufficient project artifacts (README, specs, existing code) accessible for analysis.

### Execution steps
1. **Resolve context source**
   - If `$ARGUMENTS` provided, parse the referenced issue ID/URL.
   - Otherwise fetch the most recent open context issue labeled `context` (using `gh issue list`).
   - If none found → stop and instruct user to run `/cc-ccc` first.

2. **Validate environment**
   - Confirm `gh` authentication and repository access for the context issue.
   - Abort if repository contains unmerged migrations or partially applied patches that would invalidate analysis.

3. **Ingest context**
   - Read the context issue body: extract goals, blockers, relevant PRs, outstanding decisions.
   - Pull in supporting artifacts mentioned in the issue (spec docs, retro notes, etc.).

4. **Survey codebase (read-only)**
   - Use `git status --short`, `rg --files`, targeted file reads, and dependency inspection to understand current architecture.
   - Map affected modules, tests, configs, and external integrations.

5. **Develop the plan structure**
   - Core sections to populate:
     1. **Summary / Intent** – restate the problem using context wording.
     2. **Research & Insights** – key findings from code and docs.
     3. **Implementation Strategy** – ordered phases with rationale.
     4. **Task Breakdown** – bullet list with file paths and owners (if known).
     5. **Testing & Validation** – unit/integration/manual checks required.
     6. **Risks & Mitigations** – call out uncertainty, prerequisites, rollbacks.
     7. **Next Commands** – usually `/cc-gogogo`; include `/cc-rrr` if session closure likely.

6. **Publish GitHub plan issue**
   - Use consistent naming like `Plan: <user story>`.
   - Apply labels: `plan`, plus any component labels derived from context.
   - Cross-link back to the context issue using `gh issue create --body-file` with references.
   - If issue creation fails, report error and preserve draft plan content for manual posting.

7. **Emit workflow guidance**
   - Default suggestion: `/cc-gogogo` referencing new issue number.
   - If blockers remain unsolved, recommend follow-up research or `clarify` style questioning before implementation.

8. **Summarise for the user**
   - Provide plan issue number/URL, high-level phases, and explicit reminder that no files were modified.

### Error handling
- **No context found** → Respond with "Run `/cc-ccc` to capture context first." Do not attempt to fabricate context.
- **Invalid issue reference** → Explain the issue was not accessible and request a different ID.
- **Analysis failure** (e.g., repository unreadable) → Fail fast with diagnostic suggestion (permissions, branch mismatch).

### Completion checklist
- Plan issue created and linked to context issue.
- Chat summary includes ordered implementation phases and risk callouts.
- Next-step command recommendation provided.
- Confirmation that working tree remains unchanged.

### Follow-on commands
- `/cc-gogogo` to execute the plan.
- `/cc-ccc` if significant new information emerges before implementation.
- `/cc-rrr` once execution completes to document outcomes.
