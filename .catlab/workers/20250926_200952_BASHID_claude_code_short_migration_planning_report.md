# Claude Code Short Code Migration - Planning Report

## Executive Summary
- Migrate four legacy short codes from `CLAUDE.md` into Claude Code custom commands while preserving intent and upgrading ergonomics with the `cc-` prefix.
- Estimated timeline: ~4 weeks (Foundation 1w, Migration 1.5w, Smart Features 1w, Testing & Polish 0.5w) with medium implementation complexity due to orchestration touchpoints and context-aware suggestions.
- Primary success drivers: accurate behavior parity, seamless integration with `.specify` workflows, and actionable smart suggestions that reflect live project state.

## Current State Analysis
- **Command infrastructure**: Existing Claude Code commands live under `.claude/commands` using YAML front matter plus procedural instructions (e.g., `.claude/commands/analyze.md`). Commands frequently invoke `.specify/scripts/bash/check-prerequisites.sh` to hydrate feature context and rely on downstream artifacts (`spec.md`, `plan.md`, `tasks.md`).
- **Short code behavior**: `CLAUDE.md` frames the short codes as orchestration shorthands—`nnn` for planning-only flows, `gogogo` for implementation, and implied complementary roles for `ccc` and `rrr` (context framing and retrospectives). Current doc differentiation emphasizes safety boundaries between plan vs. implementation execution.
- **Integration points**: Migration must align with the command invocation lifecycle (argument handling, `$ARGUMENTS`, multi-phase instructions) and coordinate with `.specify` artifact pipelines, git status checks, and worker-launcher scripts already referenced in the repo.

## Architecture Strategy
- **Command structure design**: Create four new Markdown command definitions (`cc-ccc.md`, `cc-nnn.md`, `cc-rrr.md`, `cc-gogogo.md`) mirroring the existing schema: front matter description, explicit handling of user arguments, enumerated execution steps, and guardrails for read/write scope.
- **Integration approach**: Reuse shared prerequisite scripts to resolve feature directories, load relevant artifacts, and piggyback on established workflows—planning commands should call into or orchestrate `/plan` and `/tasks` flows, while implementation commands leverage `/implement` guidance.
- **Smart suggestions system**: Implement a helper module (e.g., shared bash script or Claude prompt section) that inspects repo state (git status, recent `.catlab/workers` outputs, latest `tasks.md` progress) and emits contextual suggestions appended to command output; ensure idempotent reads so suggestions never modify files.
- **Error handling strategy**: Standardize failure surfaces—missing artifacts should short-circuit with prescriptive follow-ups (e.g., instruct to run `/specify` or regenerate tasks), while execution errors degrade gracefully and log actionable diagnostics for the user.

## Implementation Roadmap
### Phase 1: Foundation [1 week]
- Inventory current commands, define shared helper utilities for context hydration, and draft interface contracts for the suggestion subsystem.
- Validate assumptions about available artifacts and confirm safe read/write rules for each code path.

### Phase 2: Command Migration [1.5 weeks]
- Implement `cc-ccc`, `cc-nnn`, and `cc-rrr`, focusing on behavior parity and consistent text outputs.
- Build `cc-gogogo` with tight coupling to implementation flows, including enforcement of plan prerequisites and safety prompts.
- Introduce automated linting/checks (markdown schema validation, command registry updates) to catch regressions.

### Phase 3: Smart Features [1 week]
- Develop the dynamic suggestion engine (git/project telemetry ingestion, heuristics, rendering).
- Integrate suggestions into each command with opt-in toggles and guardrails to avoid noise.
- Pilot user scenarios to tune thresholds and ensure recommendations are actionable.

### Phase 4: Testing & Polish [0.5 week]
- Execute integration tests covering happy paths, missing artifacts, and failure recovery.
- Update documentation (`CLAUDE.md`, specs, command catalog) and produce migration notes.
- Collect feedback and finalize readiness criteria for release.

## Technical Approach
- **Command definition format**: Follow existing Markdown layout with front matter description, `$ARGUMENTS` placeholder, and ordered execution steps; ensure consistent voice and guardrails per command scope.
- **Configuration requirements**: Confirm `.claude/settings.local.json` remains accurate; extend only if new permissions or toggles are required for suggestion telemetry.
- **Dependencies & prerequisites**: Leverage `.specify/scripts/bash/check-prerequisites.sh` for context, `setup-plan.sh` for planning artifacts, and existing worker-launcher scripts if asynchronous execution is needed.
- **Integration testing strategy**: Compose scenario-based tests (manual or scripted) that simulate command invocation with/without prerequisites, verifying outputs, side-effect safety, and suggestion accuracy; consider adding lightweight command validator to CI if available.

## Detailed Command Plans
### cc-ccc (Context & Compact)
- **Behavior**: Summarize the current feature state—key spec highlights, open tasks, active workers—and output a compact briefing for new sessions.
- **Prerequisites**: Requires readable `spec.md`, `plan.md`, `tasks.md`, plus optional `.catlab/workers` summaries; read-only command.
- **Implementation notes**: Reuse analysis utilities for extracting key sections, ensure output capped for brevity, and surface top 3 smart suggestions derived from recent git changes.

### cc-nnn (Next/Planning)
- **Behavior**: Conduct planning-only workflow—validate spec clarity, optionally trigger `/plan`, and propose ordered next steps without modifying files.
- **Prerequisites**: Demands completed clarifications or explicit override; requires access to `spec.md` and plan templates; strictly read-only except for orchestrating plan regeneration.
- **Implementation notes**: Embed safety prompts preventing file writes, integrate suggestion engine to recommend follow-up commands (e.g., `/tasks`, run targeted research).

### cc-rrr (Retrospective)
- **Behavior**: Generate session retrospective capturing accomplishments, blockers, pending tasks, and lessons learned; optionally archive summary in `.catlab/workers` when instructed by user.
- **Prerequisites**: Needs historical context from git history, recent worker outputs, and tasks checklist; defaults to read-only but supports optional write when user provides output path.
- **Implementation notes**: Structure output with highlights, metrics (completed tasks, tests run), and improvement suggestions; ensure opt-in for writing to disk to maintain safety.

### cc-gogogo (Execute Implementation)
- **Behavior**: Orchestrate implementation phase by verifying prerequisites, sequencing tasks, invoking worker commands, and tracking completion status.
- **Prerequisites**: Requires up-to-date `tasks.md`, plan alignment, and clean working tree; mandates explicit confirmation before enabling write operations.
- **Implementation notes**: Align with `/implement` flow, enforce phase ordering, instrument progress logging, and integrate real-time suggestions (e.g., pending tests, git hygiene reminders).

## Risk Assessment & Mitigation
- **Behavior drift**: Risk of misinterpreting legacy shorthand—mitigate by reviewing existing usage patterns with stakeholders and validating outputs against sample sessions.
- **Suggestion noise**: Context-aware recommendations could overwhelm users—introduce relevance scoring and allow disabling via command arguments or settings.
- **Dependency volatility**: Reliance on `.specify` scripts may break if paths change—create thin abstraction wrappers and document required versions.
- **Safety regressions**: Implementation commands could write unexpectedly—retain explicit confirmation prompts and automated checks for dirty git state before execution.

## Success Metrics
- **Acceptance criteria**: Each command replicates intended behavior, honors safety constraints, and passes scripted scenario tests.
- **Performance targets**: Command runtime under 10s for planning flows and under 20s for implementation orchestration on typical features.
- **User experience goals**: Suggestions feel timely and relevant (≥80% positive feedback during pilot), documentation clearly describes usage, and users can transition without consulting legacy short codes.

## Resource Requirements
- **Development time**: ~2 developer-weeks for command authoring, 1 week for suggestion engine, 1 week for testing/documentation spread across phases.
- **Testing**: Manual command dry-runs, automated lint/validation scripts, and potential integration with CI if available.
- **Documentation**: Update `CLAUDE.md`, command catalog, and onboarding materials; prepare internal change log and quick-reference cheatsheet for the new prefixes.
