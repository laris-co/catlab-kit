---
description: Capture the current repository and conversation state, file a GitHub context issue, then compact the chat history for clean handoff.
---

The user input to you can be provided directly (chat message) or as a command argument — you **MUST** inspect it before executing anything. Acceptable flags are `--title "Custom"`, `--labels "comma,separated"`, and `--no-compact`.

User input:

$ARGUMENTS

Goal: Preserve a high-fidelity snapshot of the working tree and active discussion so the next agent can continue without context loss. This is Step 1 of the `ccc → nnn → gogogo` workflow.

Authority boundaries:
- Read repository state, conversation history, recent GitHub issues.
- Write **only** to a newly created GitHub “Context” issue (no local file edits besides temporary artifacts).
- Invoke `/compact` unless the user explicitly opts out.

### Preconditions
- Running inside a git repository.
- `git` and `gh` binaries available; `gh` must be authenticated for the target repo.
- Conversation contains enough material to summarise focus, blockers, and next intentions.

### Execution steps
1. **Parse arguments**
   - Default issue title: `Context: <current-branch> (<YYYY-MM-DD>)`.
   - Default labels: `context`.
   - Honour `--title`, `--labels`, `--no-compact` overrides from `$ARGUMENTS`.

2. **Validate tooling**
   - Abort with actionable guidance if `git` or `gh` is unavailable or unauthenticated.
   - Confirm repository cleanliness check is readable (`git status`).

3. **Collect repository snapshot**
   - Record branch name (`git rev-parse --abbrev-ref HEAD`).
   - Capture `git status --porcelain` and note whether uncommitted changes exist.
   - Grab the last 5 commits via `git log --oneline -5`.
   - Detect outstanding PR or issue references from commit messages if present.

4. **Summarise conversation**
   - Extract: current objective, discoveries, blockers, tentative next moves.
   - Include explicit TODOs or unanswered questions so they are traceable later.

5. **Compose context issue body** (markdown skeleton):
   - `## Session Snapshot`
     - Branch, git status summary, pending PR/issue refs.
   - `### Uncommitted Files`
     - Render code block with `git status` output or `None`.
   - `### Conversation Focus`
     - Bullets covering goals, decisions, blockers.
   - `### Next Intentions`
     - Ordered list of recommended next tasks.
   - `### Suggested Commands`
     - Default suggestions based on workflow detection (see Step 8).

6. **Create GitHub issue**
   - Use `gh issue create --title ... --label ... --body-file <temp>`.
   - If creation fails, preserve the temp file path and return an error describing how to retry manually.

7. **Compact conversation**
   - Unless `--no-compact` supplied, run `/compact "Context captured for <branch>"`.
   - If `/compact` is unavailable, warn but continue.

8. **Derive smart suggestions**
   - If git tree is dirty → Suggest staging/reviewing changes before implementation.
   - If a plan issue already exists → Recommend `/cc-nnn` only if context is stale; otherwise suggest checking open plan.
   - Otherwise → Encourage running `/cc-nnn` to produce the implementation plan.

9. **Report results**
   - Provide issue number/URL, highlight whether compact succeeded, and surface next-command recommendations.

### Error handling
- **Not a git repo** → Stop immediately with "Run inside a git repository" instruction.
- **`gh` authentication missing** → Direct user to run `gh auth login`.
- **Network/GitHub failure** → Preserve issue body temp path and instruct retry.
- **Insufficient context** → Prompt user for a brief summary before retrying.

### Completion checklist
- GitHub issue created and number recorded.
- Conversation compacted or explicit skip acknowledged.
- Next-step suggestions tailored to repo state included in the response.

### Follow-on commands
- `/cc-nnn` to convert this context into a plan.
- `/cc-rrr` when wrapping the overall session.
- `/cc-gogogo` only after `/cc-nnn` has produced an actionable plan.
