# Developer Report: CLAUDE.md Guidelines Overview

This report summarizes the key expectations and workflows described in the CLAUDE.md guidelines (reference item 2 in the project README). It is intended to help developers quickly understand how to operate effectively and safely when collaborating with AI assistants.

## 1. Executive Summary
- The CLAUDE.md document establishes comprehensive workflows for AI-assisted development.
- Core responsibilities include implementation, testing, documentation, and maintaining safe practices.
- Adherence to documented processes ensures high-quality contributions and protects project integrity.

## 2. Quick Start Workflow
1. **Verify tooling**: Confirm required CLI tools (language runtime, package manager, git, GitHub CLI, tmux) are installed.
2. **Repository setup**: Clone the repository, install dependencies, configure environment variables, and initialize any tmux sessions using the provided shorthand commands.
3. **First task pattern**: Run `lll` to gather project status, `nnn` to generate a detailed plan, and `gogogo` to execute that plan.

## 3. Project Context Requirements
- Maintain a project overview covering goals, architecture (backend, frontend, infrastructure), and key libraries.
- Track current features and ensure the document reflects the latest state of the project.

## 4. Critical Safety Rules
- Operate exclusively on the designated fork (`nazt/firmware`) and never interact with upstream repositories without permission.
- Avoid destructive command flags (`--force`, `-f`) for git, package managers, or file operations.
- Do not merge pull requests without explicit user approval and always favor reversible actions.

## 5. Development Environment Practices
- Use safe file management commands and confirm before deleting or modifying critical assets.
- For troubleshooting, follow documented steps for build failures, dependency cache resets, and port conflicts.

## 6. Standard Development Workflows
- Follow linting/style guides for the specific technology stack.
- Use strict typing where possible and document non-obvious logic.
- Handle errors gracefully with descriptive messaging and appropriate fallbacks.

## 7. Git Hygiene
- Use the structured commit message format:
  ```
  [type]: [brief description]

  - What: [specific changes]
  - Why: [motivation]
  - Impact: [affected areas]

  Closes #[issue-number]
  ```
- Accepted commit types include `feat`, `fix`, `docs`, `style`, `refactor`, `test`, and `chore`.

## 8. Lessons Learned & Best Practices
- Prefer incremental plans (≈1 hour of work) and minimum viable implementations before expansion.
- Capture retrospectives, including AI diary entries and honest feedback, to retain contextual knowledge.
- Leverage parallel analysis when tackling complex systems and label multi-phase plans clearly.

## 9. Observed User Preferences
- Maintain manageable task scopes and phased delivery.
- Provide visible progress quickly and emphasize actionable feedback.
- Assume collaboration in GMT+7 (Bangkok) unless otherwise specified.

## 10. Troubleshooting Reference
- For build errors, inspect compiler output, clear caches, reinstall dependencies, and re-run builds.
- Diagnose port conflicts with `lsof` and stop offending processes safely.

## 11. Operational Checklist
- Confirm environment readiness (runtime versions, package manager, GitHub CLI, tmux, environment variables, git configuration).
- Update the CLAUDE.md-derived documentation whenever processes or preferences evolve.

---
This report should be reviewed before starting development work to ensure alignment with the CLAUDE.md standards.
