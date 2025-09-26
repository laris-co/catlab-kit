# Agent Operating Guide

## Repository Snapshot
- **Project**: catlab-kit — reference hub for secure, well-governed automation workflows.
- **Primary docs**: `README.md`, `.specify/memory/constitution.md`, and Spec Kit configuration (see `https://github.com/github/spec-kit`).
- **Key references**: OpenAI Codex security guidance, Codex sandbox practices, and local docs under `docs/`.

## Core Responsibilities
- Understand the current task, confirm assumptions, and create a lightweight plan before editing.
- Keep the repository state transparent: document context, narrate progress, and leave clear breadcrumbs for the next contributor.
- Use the GitHub CLI (`gh`) and GitHub Flow for collaboration—create feature branches, open PRs for review, and avoid direct pushes to protected branches.

## Getting Started Checklist
1. Review `README.md` and any linked Spec Kit or Constitution updates relevant to your task.
2. Verify local tooling (`python --version`, `git --version`, `gh --version`, task-specific commands).
3. Install dependencies exactly as documented; do not add `--force` or mass upgrade flags.
4. Capture the current context (open issues, plans, or `.specify` artifacts) before making changes.

## Working Agreements
- Break work into small, verifiable steps; prefer incremental commits over large drops.
- After each meaningful action (tests, code, docs), create a descriptive commit and push it to the remote feature branch.
- Write or update tests where practical, run linters/type checkers locally, and surface any failing checks in your notes.
- Defer specialized policies (security, release, branching) to the Spec Kit rule set; do not override those constraints in ad-hoc ways.

## Safety & Compliance
- The Spec Kit configuration is the authoritative source for operational constraints (testing gates, prohibited commands, required approvals). Consult it alongside the repository Constitution and follow whichever is stricter.
- When a requested action appears to violate Spec Kit or Constitution rules (e.g., forced pushes, destructive deletes), halt and request guidance instead of proceeding.
- Log notable decisions, risk tradeoffs, or blocked items so that downstream automation has full context.

## Communication & Handoff
- Summarize session outcomes, remaining work, and verification status before finishing.
- Link to relevant artifacts (test reports, coverage summaries, plans) so future agents can resume quickly.
- Use concise retrospectives to note lessons learned or follow-up questions.

## Useful Entry Points
- `README.md` — high-level project references and links.
- `.specify/` — generated plans, templates, and memory artifacts managed by Spec Kit.
- `docs/` — local security and operational reports.

When in doubt, prefer the simplest safe approach, document your reasoning, and sync with maintainers before deviating from Spec Kit or Constitution guidance.
