<!--
Sync Impact Report
- Version change: 1.0.0 → 1.1.0
- Modified principles: Added VI. Commit and Push Traceability
- Added sections: None (expanded Workflow & Gates content)
- Removed sections: None
- Templates requiring updates:
  ✔ .specify/templates/plan-template.md (updated: version reference, commit/push gate)
  ✔ .specify/templates/tasks-template.md (updated: push requirement + checklist)
  ⚠ .specify/templates/spec-template.md (no change needed)
  ⚠ .specify/templates/commands/* (not present in repo)
- Follow-up TODOs:
  - Configure branch protections for `main` (require status checks, disallow force pushes).
  - Ensure CI uploads `test-reports/` and `coverage/` artifacts on every run.
-->

# catlab-kit Constitution

## Core Principles

### I. Simplicity First, Complexity Later (NON-NEGOTIABLE)
- Start with the simplest design that meets the current, explicit
  requirements. Avoid speculative abstractions and premature layering.
- Introduce complexity only when a failing test, performance constraint, or
  concrete requirement proves it necessary and is documented in the plan’s
  Constitution Check.
- Keep functions small and modules cohesive; prefer composition over deep
  inheritance.
Rationale: Simpler code is easier to test, reason about, and change.

### II. Code Quality & PEP 8 Compliance
- Code MUST conform to PEP 8. Enforce with a linter (e.g., Ruff) and a
  formatter (e.g., Black) in CI and pre-commit.
- Public modules, classes, and functions MUST include clear docstrings.
- No disabling of lint rules without an inline justification linked to a
  ticket or PR.
Rationale: Consistent style and documentation improve readability and reduce
review time.

### III. Python 3.12+ and Explicit Type Hints Everywhere
- All runtime code MUST target Python 3.12 or newer. Declare this in
  `pyproject.toml` via `requires-python = ">=3.12"`.
- All functions, methods, and module-level variables MUST be fully typed. Use
  precise types; avoid `Any` unless strictly necessary and documented.
- Enforce static typing in CI with a type checker (e.g., mypy in `--strict` or
  equivalent pyright configuration).
Rationale: Strong typing prevents defects and supports safe refactoring.

### IV. Tests First with Mandatory Reports
- Follow TDD: write tests that fail before implementation, then implement and
  refactor.
- Every test run MUST produce:
  - JUnit XML at `test-reports/junit.xml`.
  - Coverage XML at `coverage/coverage.xml` and HTML at `coverage/html/`.
- Unit tests validate behavior; integration tests cover boundaries and
  contracts where applicable.
Rationale: Fast feedback plus auditable reports enforce quality over time.

### V. Continuous Quality Gates
- CI MUST fail on any of: style errors (Ruff/Black check), missing type
  hints or type errors (mypy/pyright), failing tests, or missing test
  report artifacts.
- Pre-commit hooks mirror CI checks to prevent drift.
Rationale: Automated gates maintain standards without manual policing.

### VI. Commit and Push Traceability
- Work in short, atomic commits with imperative, descriptive messages.
- After each meaningful change (tests, code, docs, or config), commit and push
  to the feature branch immediately. Do not accumulate local-only work.
- Use feature branches and open PRs to merge into protected branches (e.g.,
  `main`). Do not force-push protected branches.
Rationale: Frequent commit/push cycles create transparent progress, reduce
integration risk, and improve recovery.

## Quality Standards & Constraints

- Language/Runtime: Python >= 3.12 across local and CI.
- Packaging/Config: Use PEP 621 `pyproject.toml`. Declare
  `requires-python = ">=3.12"`. Store tool configs (Black, Ruff, mypy/pyright,
  pytest) in the same file when supported.
- Linting/Formatting: Enforce Black (line length 88 unless justified) and Ruff
  (PEP 8 rules). No unreviewed rule suppressions.
- Typing: Enable strict static analysis (e.g., mypy `--strict`). Disallow
  implicit `Any`. Use `typing.Annotated` and `TypedDict`/`dataclass` as
  appropriate for clarity.
- Testing: Use pytest. Always emit JUnit XML and coverage XML+HTML to the
  paths defined above. Keep tests fast and deterministic.
- Artifacts: CI must archive `test-reports/` and `coverage/` as build
  artifacts for each run.

## Development Workflow & Quality Gates

- Feature flow: spec → plan → tasks → tests (failing) → implementation →
  refactor → docs.
- Constitution Check: Every plan must document simplicity decisions, any
  intentional complexity, and evidence justifying it.
- Definition of Done for a PR:
  - Python 3.12+ compatible.
  - Fully typed with zero `Any` (unless documented exception).
  - PEP 8 clean (Ruff/Black) and type-check clean (mypy/pyright).
  - Tests pass and required reports are present.
  - Reviewer confirms "Simplicity First" was observed.
  - Commit history shows small, logical steps; all commits are pushed to
    remote.

## Governance
<!-- Example: Constitution supersedes all other practices; Amendments require documentation, approval, migration plan -->

This constitution supersedes conflicting guidance in this repository. Amendments
occur via pull request labeled "Constitution" and must include:
- Change summary and rationale.
- Impact analysis and migration steps (if any).
- Proposed version bump following SemVer for governance docs:
  - MAJOR: remove/redefine principles or break compliance expectations.
  - MINOR: add a new principle/section or materially expand guidance.
  - PATCH: clarifications and non-semantic refinements.

Compliance Review Expectations:
- All PRs include a "Constitution Check" section referencing this file
  (`.specify/memory/constitution.md`).
- CI enforces gates for style, typing, tests, and report artifacts.

**Version**: 1.1.0 | **Ratified**: 2025-09-25 | **Last Amended**: 2025-09-25
<!-- Ratified on initial adoption; amended to add commit/push traceability. -->
