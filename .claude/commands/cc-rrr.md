---
description: Produce a full-session retrospective with mandatory AI Diary and Honest Feedback sections, then archive it under `retrospectives/`.
---

The user input to you can be provided directly or as `/cc-rrr --issue <id>`; review it carefully before proceeding. If `--issue` is supplied, link the retrospective back to that GitHub issue or PR in the closing steps.

User input:

$ARGUMENTS

Goal: Capture what happened, why it mattered, and how it felt so future sessions inherit the full story. This is typically Step 4 after `/cc-gogogo` completes.

Scope: Read repository history, write retrospective files, optionally post GitHub comments. Do **not** modify source code.

### Preconditions
- Meaningful activity occurred during the session (commits, diffs, or documented decisions).
- Git repository accessible with `git log` and `git diff` history.
- `retrospectives/` directory writable (create it if missing).

### Execution steps
1. **Parse optional arguments**
   - Support `--issue <number|url>` to attach the retrospective.
   - Reject unsupported flags with a clear usage reminder.

2. **Collect session evidence**
   - Determine session window (start/end) via timestamps or context markers.
   - Gather `git log --oneline main...HEAD` and `git diff --name-only main...HEAD`.
   - Note key PRs/issues touched and outstanding TODOs.

3. **Assemble retrospective scaffold**
   - Required sections (must be non-empty):
     1. Session Summary & Timeline
     2. Technical Details (files changed, key decisions)
     3. **AI Diary** (first-person narrative) — **MANDATORY**
     4. What Went Well / What Could Improve
     5. **Honest Feedback** — **MANDATORY**
     6. Lessons Learned (patterns, mistakes, discoveries)
     7. Next Steps & Follow-ups
   - Include Blockers & Resolutions if any were encountered.

4. **Write retrospective file**
   - Path: `retrospectives/YYYY/MM/<YYYY-MM-DD>_<HH-MM>_retrospective.md` (UTC in filename, primary timezone GMT+7 inside body per gist guidance).
   - Ensure directory exists; create with `mkdir -p` if necessary.
   - Populate metadata (date, start/end times, session type, linked issue/PR, export path).

5. **Validate completeness**
   - Confirm AI Diary and Honest Feedback contain substantive prose (not placeholders).
   - Ensure timeline events include actual timestamps.
   - Verify lessons and next steps are actionable (checkbox list allowed).

6. **Version control integration**
   - Stage the new file (`git add retrospectives/...`).
   - Commit with message like `docs: add retrospective <date>` referencing linked issue when available.

7. **Notify stakeholders**
   - If `--issue` provided, comment with the retrospective path and highlight key learnings.
   - Optionally update `CLAUDE.md` lessons learned if new insights surfaced (per gist instructions).

8. **Report outcome**
   - Share file path, commit hash (if created), linked issue/PR comment URL, and outstanding TODOs.
   - Recommend whether to capture fresh context (`/cc-ccc`) or move directly into planning (`/cc-nnn`).

### Error handling
- **No recent activity** → Abort with "No meaningful changes to document; run after completing work." Do not create empty retrospectives.
- **Write failure** → Report inability to write under `retrospectives/` and provide remediation (permissions, directories).
- **Missing mandatory sections** → Stop and prompt to fill AI Diary/Honest Feedback before saving.

### Completion checklist
- Retrospective file saved with timestamped name.
- Mandatory sections populated with non-placeholder content.
- Git commit created (or staged) and optional GitHub comment posted.
- Recommendations for next commands included.

### Follow-on commands
- `/cc-ccc` to capture new context if more work remains.
- `/cc-nnn` to plan the next iteration.
- `/cc-gogogo` only after a refreshed plan exists.
