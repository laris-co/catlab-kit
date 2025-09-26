---
description: Capture a full-session retrospective with timeline, AI diary, and actionable follow-through artifacts.
---

# Retrospective Command (cc-rrr)

Generate a structured end-of-session retrospective that documents what happened, how it felt, and what should happen next while archiving the results in the `retrospectives/` knowledge base.

## Usage
```
/cc-rrr
/cc-rrr --issue 123   # optionally link the retrospective to a relevant GitHub issue/PR
```

## What this command does

- Scrapes recent activity by collecting git commits (`git log --oneline main...HEAD`), touched files (`git diff --name-only main...HEAD`), and notable timeline markers from the active session.
- Builds a retrospective markdown document that **always** includes the mandatory sections: Session Summary and Timeline, Technical Details, AI Diary, What Went Well / What Could Improve, Honest Feedback, Lessons Learned, and Next Steps.
- Writes the finished report to `retrospectives/YYYY/MM/SESSION_TIMESTAMP-retro.md`, creating missing directories as needed.
- Optionally posts a comment on a linked GitHub issue or PR with the retrospective location to keep stakeholders in sync.
- Surfaces smart follow-up suggestions (e.g., revisit planning, open new context) based on session intensity and outstanding work.

## Key Features

- 🧾 Structured storytelling: Timeline-first summary plus deep dive sections tailored to engineering retrospectives.
- 🧠 AI Diary spotlight: Dedicated first-person narrative that captures thought process and emotion.
- 📂 Automatic archiving: Date-based directory layout keeps retrospectives organized for long-term reference.
- 🔍 Provenance tracking: Explicit lists of modified files, decisions, and references back to git history.
- 🗣️ Honest feedback loop: Encourages frank assessment to surface workflow friction and tooling gaps.

## Architecture

- **Session data collector** pulls git metadata, session timestamps, and any cached action logs; bails with `"No recent changes to retrospect on"` when nothing meaningful is detected.
- **Retrospective templater** injects gathered facts into a canonical markdown scaffold, enforcing the mandatory sections and flagging gaps before writing.
- **Diary composer** generates the first-person AI Diary slice separate from objective notes to honour the experiential requirement.
- **Exporter** materializes the final document into `retrospectives/<YYYY>/<MM>/` with a timestamp slug; errors like permission denials emit `"Cannot write to retrospectives/ directory"`.
- **GitHub notifier** (optional) comments on linked issues/PRs with a pointer to the new retrospective and syncs any session labels.
- **Suggestion engine** inspects repo/workflow state to recommend the next logical command (often `/cc-ccc` or `/cc-nnn` for the following cycle).

## Command executed
```bash
cc-rrr() {
  ensure_git_repo_or_exit

  session_span=$(detect_session_window)
  changes=$(git log --oneline main...HEAD)
  files=$(git diff --name-only main...HEAD)
  [ -z "$changes$files" ] && warning "No recent changes to retrospect on" && return 1

  retro_payload=$(build_retro_markdown \
    --timeline "$session_span" \
    --commits "$changes" \
    --files "$files" \
    --enforce-sections "Session Summary and Timeline,Technical Details,AI Diary,What Went Well / What Could Improve,Honest Feedback,Lessons Learned,Next Steps" \
  ) || error "Missing required sections"

  retro_path=$(write_retro_file "$retro_payload") || error "Cannot write to retrospectives/ directory"

  maybe_comment_on_issue "$retro_path" "$1"
  suggest_next_step $(derive_workflow_suggestion)
}
```

## Error Handling

- **No Git History** → emits `"No recent changes to retrospect on"` and aborts without writing a file.
- **File Permission Issues** → returns `"Cannot write to retrospectives/ directory"` when export fails.
- **Missing Required Sections** → blocks finalization until all mandatory sections are populated.

## Smart Suggestions

- When meaningful activity is detected, suggest running `/cc-rrr` immediately after implementation to lock in learnings.
- If the retrospective completes successfully, steer the workflow toward fresh context (`/cc-ccc`) or planning (`/cc-nnn`) depending on outstanding work.
- In low-activity sessions, recommend a brief summary or deferring the retrospective until substantial progress occurs.
