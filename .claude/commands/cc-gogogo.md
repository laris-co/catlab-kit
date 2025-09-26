---
description: Execute implementation work from an approved plan while tracking progress and preserving git safety.
---

# cc-gogogo (Execute Implementation)

Run the implementation phase by consuming the latest planning issue, validating the workflow, executing the steps in order, and reporting progress back to the plan and repository.

## Usage
```
/cc-gogogo [--plan <issue-number>] [--branch <name>] [--dry-run]
```

## What this command does

- Validates that a recent `/cc-nnn` plan issue exists and is executable before touching the workspace.
- Parses the plan's task list into sequential steps, groups optional parallel items, and builds a progress tracker.
- Prepares the git workspace (status check, branch verification/creation, dependency hooks) with user confirmations for risky actions.
- Executes each plan step with built-in prompts for file edits, test runs, and verification, updating plan checkboxes and local progress after every step.
- Handles commits, prepares PR updates, and surfaces blockers while keeping the user in control of writing, staging, or pushing changes.
- Emits a final summary with completed work, remaining tasks, suggested `/cc-rrr`, and next-step recommendations.

## Key Features

- ✅ Plan-first safety: refuses to run without a valid `/cc-nnn` issue; dry-run preview to confirm readiness.
- 🔧 Guided execution: structured loop with per-step instructions, git safeguards, and optional automation helpers.
- 📊 Progress telemetry: real-time tracker, checkbox updates, and clear status outputs for each phase.

## Architecture

- Reads plan metadata through `gh issue view` (or cached JSON) to pull phases, acceptance criteria, and linked issues.
- Uses lightweight parsing to build a normalized step array with attributes (`id`, `description`, `type`, `requires_tests`, `files`).
- Maintains runtime state in memory (current step index, completion flags, pending follow-ups); persists status notes to `.catlab/workers/` for traceability.
- Wraps git/gh operations in guard clauses (status clean required unless `--force`, interactive confirmation prior to destructive commands).
- Integrates with existing scripts (e.g., `codex-exec.sh`) when steps need shell automation or background work.

## Command executed
```bash
# Sketch of the execution flow (actual orchestration handled inside Claude Code runtime)
resolve_plan_issue() {
  plan_id=$(detect_plan_issue "$1") || return 1
  plan_payload=$(gh issue view "$plan_id" --json body,title,number,state,labels) || return 2
  validate_plan_schema "$plan_payload" || return 3
}

prepare_workspace() {
  require_git || return 10
  git status --short
  ensure_clean_tree || confirm_or_abort "Working tree dirty; continue?"
  checkout_or_create_branch "$branch"
}

execute_steps() {
  build_progress_tracker "$plan_payload"
  for step in ${steps[@]}; do
    show_step_intro "$step"
    confirm_plan_alignment "$step" || abort "Plan needs revision."
    run_step_actions "$step"              # edits/tests delegated to Claude interactions
    mark_progress "$step"
    update_plan_checklist "$plan_id" "$step"
    suggest_commit_if_ready "$step"
  done
}

finalize_run() {
  summarize_results "$plan_id"
  offer_commit_and_pr_helpers
  recommend_followup_command "/cc-rrr"
}

main() {
  resolve_plan_issue "$PLAN_FLAG" || return
  prepare_workspace || return
  execute_steps || return
  finalize_run
}
```
```
