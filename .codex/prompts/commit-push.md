---
description: Commit and push the current feature branch while respecting the Constitution.
---

The user input to you can include a commit message or extra guidance. Read it carefully before taking any action.

User input:

$ARGUMENTS

Execute the following workflow from /home/floodboy/catlab-kit:

1. Run `git status --short` to verify there are staged or unstaged changes. If the working tree is clean, stop and inform the user.
2. Determine the current branch using `git rev-parse --abbrev-ref HEAD`.
   - If you are on `main` or another protected branch, first ensure it is current with `git pull --ff-only origin $(git rev-parse --abbrev-ref HEAD)`.
   - Derive a descriptive feature branch name if $ARGUMENTS does not provide one (e.g., `chore/<short-topic>`), announce it to the user, and switch to it with `git switch -c <branch>`.
   - If the target branch already exists locally, switch with `git switch <branch>` and sync it via `git pull --ff-only origin <branch>`.
   - Only continue once you are on a feature branch.
3. Stage the intended files with `git add <path>`. Stage only the files relevant to the current change set; avoid staging unrelated files.
4. Show the staged diff with `git diff --cached` to confirm the commit contents. If issues are found, adjust the staging before proceeding.
5. Ensure tests and linters required by the Constitution have passed. If they have not been run since the last change set, run the documented commands (e.g., `pytest`, `ruff check`, `mypy`) or note why they are being skipped.
6. Derive the commit message:
   - If $ARGUMENTS provides a message, use it verbatim after trimming.
   - Otherwise, craft a concise, imperative summary describing the change. Confirm the message with the user if there is any ambiguity.
7. Create the commit with `git commit -m "<message>"`. If the commit is rejected because there are no staged changes, revisit staging.
8. Push the branch:
   - For a first push of the branch, run `git push -u origin $(git rev-parse --abbrev-ref HEAD)`.
   - Otherwise run `git push`.
   - Never use `--force` or similar destructive flags.
9. Report the resulting commit hash and the remote tracking status to the user, including any follow-up actions (e.g., open PR, run additional checks).

Always honor the "No Force Commands" rule and stop for clarification if any step would violate the Constitution or Spec Kit policies.
