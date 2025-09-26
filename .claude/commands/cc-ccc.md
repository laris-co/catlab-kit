---
description: Capture the current git and conversation state, file a GitHub context issue, then compact the chat.
---

# Context & Compact (cc-ccc)

Capture an actionable snapshot of the repository and conversation so the next worker can pick up with full context and a compact history.

## Usage
```
/cc-ccc [--title "Custom context title"] [--labels "context,handoff"] [--no-compact]
```

## What this command does

- Inspects the repository to record branch, status, and notable changes.
- Summarizes the active conversation focus, blockers, and next intentions.
- Files a structured GitHub context issue with the captured state.
- Runs Claude Code's `/compact` to trim history unless explicitly skipped.
- Emits workflow suggestions keyed to the current project state.

## Key Features

- Simple markdown workflow that mirrors existing Claude Code command patterns.
- GitHub issue payloads stay consistent for easy searching and handoffs.
- Optional flags let the user override title, labels, or skip compacting.
- Built-in smart suggestions nudge the next logical command in the chain.

## Architecture

1. Validate required tooling (`git`, `gh`, `/compact`) and offer clear fixes when missing.
2. Collect git metadata with `git status --porcelain` and `git rev-parse --abbrev-ref HEAD`.
3. Assemble a temporary markdown body that captures repo state and conversation summary.
4. Create or append to the context issue via `gh issue create` using consistent labels.
5. Compact the conversation (unless `--no-compact` given or `/compact` unavailable).
6. Evaluate project state and surface context-aware next steps:
   - Dirty git tree -> remind the user why capturing context is timely.
   - Recent context issue -> suggest `/cc-nnn` to spin up a planning issue.
   - Otherwise -> confirm readiness to move into planning or implementation.

## Smart Suggestions

```
if git_has_uncommitted_changes; then
  say "Git changes detected-context captured, consider staging or reviewing next."
elif recent_context_issue_exists; then
  say "Latest context already filed-run `/cc-nnn` to draft the implementation plan."
else
  say "Context saved-ready for planning, handoff, or implementation."
fi
```

## Command executed
```bash
set -euo pipefail

command -v git >/dev/null 2>&1 || {
  echo "git is required for cc-ccc" >&2
  exit 1
}
command -v gh >/dev/null 2>&1 || {
  echo "GitHub CLI (gh) is required; run 'gh auth login' first" >&2
  exit 1
}

BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
CHANGES="$(git status --porcelain)"

CONTEXT_BODY="$(mktemp)"
{
  echo "## Session Snapshot"
  echo "- Branch: ${BRANCH}"
  echo "- Git changes detected: $([[ -n "$CHANGES" ]] && echo yes || echo no)"
  echo
  echo "### Uncommitted files"
  if [ -n "$CHANGES" ]; then
    printf '%s\n' "$CHANGES"
  else
    echo "None"
  fi
  echo
  echo "### Conversation Focus"
  echo "<!-- Inject active conversation summary via Claude context helpers -->"
  echo
  echo "### Next Intentions"
  echo "<!-- Capture blockers, decisions, and proposed next steps -->"
} >"${CONTEXT_BODY}"

ISSUE_TITLE=${CC_CCC_TITLE:-"Context: ${BRANCH} ($(date +%Y-%m-%d))"}
ISSUE_LABELS=${CC_CCC_LABELS:-"context"}

if ! gh issue create \
  --title "${ISSUE_TITLE}" \
  --body-file "${CONTEXT_BODY}" \
  --label "${ISSUE_LABELS}"; then
  echo "Failed to create GitHub context issue; body preserved at ${CONTEXT_BODY}" >&2
  exit 1
fi

if [ -z "${CC_CCC_SKIP_COMPACT:-}" ]; then
  if command -v /compact >/dev/null 2>&1; then
    /compact "Context captured for ${BRANCH}"
  else
    echo "Skipping compact: /compact command not available" >&2
  fi
fi

# Smart suggestion emission happens after inspecting git + GitHub state
```

## Error handling

- Stops early with actionable guidance when `git` or `gh` are unavailable.
- Preserves the generated issue body locally if GitHub creation fails (offline mode ready).
- Skips the compact step gracefully when `/compact` cannot be invoked.

## Safety

- Only reads repository state before writing to GitHub; no direct file modifications.
- Issue titles and labels are namespaced to avoid collisions with existing workflows.
- Re-running the command produces new timestamped issues instead of overwriting history.
