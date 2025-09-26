---
description: Create a feature branch, commit changes, push to origin, and open a PR using GitHub Flow.
---

The user input to you can provide branch, commit, or PR details. Read it fully before proceeding.

User input:

$ARGUMENTS

Execute the following workflow from /home/floodboy/catlab-kit while honoring the Constitution (especially "No Force Commands"):

1. Verify tooling:
   - Run `git --version` and `gh --version` to confirm they are available.
   - Run `gh auth status` to ensure the GitHub CLI is authenticated. If authentication fails, stop and instruct the user to authenticate.
2. Inspect repository state:
   - Run `git status --short` to understand pending changes.
   - Run `git rev-parse --abbrev-ref HEAD` to identify the current branch.
3. Branch management:
   - If you are on `main` or another protected branch, ensure it is up to date with `git pull --ff-only origin $(git rev-parse --abbrev-ref HEAD)`.
   - Determine the target feature branch name:
     * If $ARGUMENTS specifies one, sanitize and use it.
     * Otherwise, derive a descriptive feature branch name (e.g., `chore/<short-topic>`), share it with the user, and proceed.
   - If you are not already on that feature branch, create or switch with `git switch -c <branch>` (or `git switch <branch>` if it exists).
   - When switching to an existing branch, pull latest changes with `git pull --ff-only origin <branch>`.
4. Prepare the change set:
   - Stage only the intended files using `git add <path>` commands.
   - Review staged changes with `git diff --cached`. If adjustments are needed, amend the staging set before continuing.
5. Quality gates:
   - Confirm required tests/linters have been run since the last change set (e.g., `pytest`, `ruff check`, `mypy`).
   - If they have not been run, execute them now or document why they are being deferred. Do not skip without explicit user approval.
6. Craft the commit:
   - If $ARGUMENTS provides a commit message, use it verbatim after trimming whitespace.
   - Otherwise, compose a concise imperative message describing the change; confirm with the user if uncertain.
   - Create the commit with `git commit -m "<message>"`. If there are no staged changes, revisit the staging step.
7. Push to origin:
   - Determine whether this branch already tracks a remote: `git rev-parse --abbrev-ref --symbolic-full-name @{u}`.
   - For a new branch, run `git push -u origin $(git rev-parse --abbrev-ref HEAD)`.
   - Otherwise, run `git push`. Never use `--force` or related destructive flags.
8. Prepare PR metadata:
   - Choose the base branch (default `main` unless specified in $ARGUMENTS).
   - Draft the PR title and a Markdown body summarizing changes, tests, and follow-up.
   - Write the body to a temporary file (e.g., `/tmp/pr-body.md`) so that newline formatting is preserved.
9. Create or update the PR:
   - Check if a PR already exists with `gh pr view --json number --head $(git rev-parse --abbrev-ref HEAD)`. If one exists, report its URL instead of creating a duplicate.
   - Otherwise, run `gh pr create --base <base> --head $(git rev-parse --abbrev-ref HEAD) --title "<title>" --body-file /tmp/pr-body.md` (adjust the path if a different file name was used). Use `--fill` only when suitable templates exist and no custom text is supplied.
10. Report results to the user including:
    - Current branch and commit hash (`git rev-parse HEAD`).
    - Test/linters status.
    - Push confirmation (`git status --short` should be clean).
    - PR URL or status, plus any next recommended actions (e.g., request review).

Stop immediately if any step would violate Spec Kit policies or the Constitution, and ask the user for guidance.
