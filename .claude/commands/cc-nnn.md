---
description: Analyse context and draft implementation plan issues without touching the working tree.
---

# Smart Planning Command (cc-nnn)

Run a read-only planning workflow that turns recent project context into a GitHub implementation plan while respecting the strict **ANALYSIS ONLY** contract.

## Usage
```
/cc-nnn
/cc-nnn #123
```

## What this command does

- Detects the active context by preferring an explicit issue reference, otherwise finds the most recent context issue.
- Performs repository reconnaissance (git status, tree scanning, dependency inspection) strictly in read-only mode.
- Synthesises a step-by-step implementation blueprint that maps requirements to files, modules, and tests.
- Creates or updates a GitHub planning issue via `gh issue create` linking back to the originating context.
- Surfaces smart next-step suggestions (typically `/cc-gogogo`) once the plan is ready.

## Key Features

- ✅ Context-aware: auto-locates recent context or validates an explicit issue.
- 🧭 Deep analysis: inspects code structure, tooling, and contracts without modifying files.
- 🧱 Plan scaffolding: outputs actionable task breakdowns with risks, dependencies, and verification steps.
- 📎 GitHub native: leverages `gh` CLI for plan issue creation and cross-linking.
- 🚫 DO NOT modify/implement/write files — this command must remain analysis-only.

## Architecture

- **Context detection**: `gh issue list` / `gh issue view` combined with local cache of recent commands to identify the driving issue; aborts with `"No recent context - run /cc-ccc first"` when none are found.
- **Project inspection**: read-only commands (`git status --short`, `rg --files`, `ls`, language-aware tooling) to understand current architecture, dependencies, and potential change surfaces.
- **Planning engine**: synthesises goals, risks, and task ordering from context issue details and repository findings; prepares structured sections (Overview → Tasks → Risks → Validation).
- **Issue publishing**: composes markdown and executes `gh issue create --title ... --body ... --label plan` linking back to the originating context issue.
- **Suggestion system**: evaluates workflow state (context located? plan issued?) to recommend `/cc-gogogo` or remediation commands.
- **Guard rails**: before any step, asserts `ANALYSIS_ONLY=true`; any attempt to write files or run destructive commands produces a hard stop with `"Cannot analyze codebase - check file permissions"` style messaging.

## Command executed
```bash
cc-nnn() {
  ensure_git_repo_or_exit
  ensure_analysis_only_mode  # hard fail if modification attempt detected

  issue_ref=$(resolve_context_issue "$1") || error "No recent context - run /cc-ccc first"
  validate_issue_access "$issue_ref" || error "Issue $issue_ref not found or inaccessible"

  capture_project_state            # git status, repo metadata, dependency graphs
  perform_read_only_code_analysis  # static inspection only; no edits allowed
  plan_payload=$(draft_plan_markdown "$issue_ref" "$project_state") || \
    error "Cannot analyze codebase - check file permissions"

  gh issue create --title "Plan: ${issue_ref}" --body "$plan_payload" --label plan
  suggest_next_step "/cc-gogogo" "Plan created from ${issue_ref}"
}
```

## Error Handling

- **No Context Found** → `"No recent context - run /cc-ccc first"`
- **Invalid Issue** → `"Issue #123 not found or inaccessible"`
- **Analysis Failures** → `"Cannot analyze codebase - check file permissions"`

## Smart Suggestions

- After successful planning, recommend running `/cc-gogogo` to execute the plan.
- If context is missing, prompt the user to run `/cc-ccc` to establish it.
- When analysis cannot proceed, direct the user to inspect repository permissions or rerun with correct context.
