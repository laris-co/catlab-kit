---
description: Capture repository context, publish a GitHub issue, and compact the conversation for fresh workflows.
---

# Context & Compact Command (cc-ccc)

Run this when you need to checkpoint the current session: it snapshots git state, files a structured GitHub context issue, compacts the conversation (unless you opt out), and suggests the next Claude Code command in the workflow.

## Usage
```
/cc-ccc
/cc-ccc --title "Context: hotfix" --labels context,backend
/cc-ccc --no-compact
```

## What this command does

- Gathers repo insights: active branch, pending changes, recent commits, and optionally staged files
- Builds a rich "Context" issue with sections for session summary, code state, blockers, intentions, and suggested follow-ups
- Calls Claude Code's `/compact` command to reset the conversation history unless `--no-compact` is passed
- Emits smart workflow suggestions (e.g., run `/cc-nnn` after capturing context) based on git status, latest context/plan issues, and session cues
- Surfaces actionable errors if required tooling is missing and preserves the issue body for manual retry when publishing fails

## Key Features

- ✅ Git-aware context capture with branch, status, and recent commit digest
- 🔧 GitHub automation via `gh` with fallback storage when auth/network fails
- 📊 Smart workflow suggestions that reference current git cleanliness and existing Claude Code issues

## Architecture

1. **Argument parsing**
   - Defaults: title 5`Context: <branch> (<YYYY-MM-DD>)`5, labels `context`
   - Flags: `--title`, `--labels`, `--no-compact`
2. **Pre-flight checks**
   - Verify `git rev-parse --is-inside-work-tree`
   - Detect `gh` availability and authentication with `gh auth status`
   - Degrade gracefully if dependencies fail (skip GitHub issue, store markdown under `.catlab/pending/cc-ccc-<timestamp>.md`)
3. **Context collection**
   - `git status --short` and `git rev-parse --abbrev-ref HEAD`
   - `git log -5 --pretty=format:"%h %ad %s" --date=short`
   - Optional `git diff --stat` when uncommitted changes exist
   - Gather recent Claude Code command history if available
4. **Issue assembly**
   - Markdown sections: Session Snapshot, Repo Status, Uncommitted Files, Conversation Focus, Blockers & Risks, Next Intentions, Suggested Commands
   - Suggested commands derived from project state (e.g., dirty tree → `/cc-nnn`, clean tree with open plan → `/cc-gogogo`)
5. **Publication + compact**
   - Create/update issue via `gh issue create --title "$title" --label "$labels" --body "$body"`
   - Print resulting issue URL; on failure, emit retry instructions referencing the saved markdown path
   - Trigger `/compact` unless `--no-compact`
6. **Output formatting**
   - Structured success output (issue link, compact status)
   - Smart suggestions with reasoning bullet points

## Command executed
```bash
#!/usr/bin/env bash
set -euo pipefail

if ! command -v git >/dev/null; then
  echo "[cc-ccc] git CLI not found. Please install git or run from a git repo." >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[cc-ccc] This directory is not a git repository. Capture skipped." >&2
  exit 0
fi

branch=$(git rev-parse --abbrev-ref HEAD)
date_stamp=$(date +%Y-%m-%d)
default_title="Context: ${branch} (${date_stamp})"
labels="context"
compact="yes"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)
      default_title="$2"; shift 2 ;;
    --labels)
      labels="$2"; shift 2 ;;
    --no-compact)
      compact="no"; shift ;;
    *)
      echo "[cc-ccc] Unknown option: $1" >&2
      exit 2 ;;
  esac
done

git_status=$(git status --short || true)
last_commits=$(git log -5 --pretty=format:'%h %ad %s' --date=short || true)
issue_body=$(cat <<'MARKDOWN'
## Session Snapshot
- Branch: ${branch}
- Date: ${date_stamp}

## Repo Status
```
${git_status:-Working tree clean}
```

## Recent Commits
```
${last_commits}
```

## Conversation Focus
- …

## Blockers & Risks
- …

## Next Intentions
- …

## Suggested Commands
- …
MARKDOWN
)

issue_file=".catlab/pending/cc-ccc-${date_stamp}.md"
mkdir -p "$(dirname "$issue_file")"
echo "$issue_body" >"$issue_file"

issue_url=""
if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
  issue_url=$(gh issue create --title "$default_title" --label "$labels" --body "$issue_body" 2>&1 | tee /dev/stderr | grep -Eo 'https://github.com/[^ ]+') || true
  if [[ -n "$issue_url" ]]; then
    rm -f "$issue_file"
  else
    echo "[cc-ccc] Stored issue body for manual retry: $issue_file" >&2
  fi
else
  echo "[cc-ccc] gh CLI unavailable or unauthenticated. Issue body saved to $issue_file" >&2
fi

if [[ "$compact" == "yes" ]]; then
  echo "/compact" >&2
fi

echo "[cc-ccc] Context issue: ${issue_url:-pending}" >&2
```
