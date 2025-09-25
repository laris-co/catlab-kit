
# Implementation Plan: Webhook Proxy Service Foundation

**Branch**: `001-build-a-simple` | **Date**: 2025-09-25 | **Spec**: `/specs/001-build-a-simple/spec.md`
**Input**: Feature specification from `/specs/001-build-a-simple/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, `GEMINI.md` for Gemini CLI, `QWEN.md` for Qwen Code or `AGENTS.md` for opencode).
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
Deliver a lightweight webhook proxy that receives generic webhook payloads, stores both raw and extracted data for auditing, and forwards formatted notifications to downstream webhooks such as Discord. The service emphasizes minimal configuration, no authentication, and easy extensibility for new sources/destinations while running as a containerized FastAPI application orchestrated with Docker Compose alongside a local PocketBase instance.

## Technical Context
**Language/Version**: Python 3.12+ (per constitution)  
**Primary Dependencies**: FastAPI, uv tooling for dependency/runtime management, PocketBase REST API, docker-compose runtime  
**Storage**: PocketBase (SQLite-backed) running locally via Docker Compose  
**Testing**: pytest, pytest-asyncio, httpx, pytest-mock, coverage XML/HTML + JUnit XML  
**Target Platform**: Containerized Linux services orchestrated with Docker Compose (FastAPI app + PocketBase)  
**Project Type**: single service backend  
**Performance Goals**: Handle up to 50 requests/sec with p95 < 300ms for forwarding to Discord; queue retries for failures within 5 minutes  
**Constraints**: No authentication layer, minimal configuration (YAML/env), Twelfth-Factor runbooks for admin/replay flows, avoid force operations, emit structured logs  
**Scale/Scope**: MVP supporting 3 distinct webhook source configurations and 2 destination webhooks, local development deployment only

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity First**: Start with a single FastAPI app + PocketBase service using straightforward routing and storage; defer templating or plugin systems until multiple sources require them.
- **Code Quality & PEP8**: Enforce Ruff + Black in pre-commit/CI; docstrings for public interfaces.
- **Python 3.12+ / Typing**: Configure `pyproject.toml` with `requires-python >=3.12`; run mypy (strict) + pyright optional.
- **Tests First with Reports**: Adopt TDD: write failing pytest suites (unit, integration) before implementation; configure pytest to emit JUnit/coverage artifacts to `test-reports/` and `coverage/`.
- **Continuous Quality Gates**: CI pipeline fails on lint/type/test/report gaps; pre-commit mirrors.
- **Commit & Push Traceability**: Work in atomic commits, push after each testable change, branch already tracked (`001-build-a-simple`).
- **No Force Commands**: Document policy in plan/tasks; no destructive git/system operations.
- **Twelfth-Factor Operations**: Capture runbooks for replay/backfill processes, ensure admin scripts share same container images & env vars; add to repo under `docs/runbooks/`.

## Project Structure

### Documentation (this feature)
```
specs/001-build-a-simple/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (planning artifact)
```

### Source Code (repository root)
```
# Option 1: Single project (DEFAULT)
src/
├── app/
│   ├── api/
│   ├── mapping/
│   ├── notifications/
│   ├── pocketbase/
│   ├── scheduler/
│   └── cli.py
├── config/
├── logging.py
└── main.py

tests/
├── contract/
├── integration/
└── unit/

# Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── same as backend above

ios/ or android/
└── platform-specific structure
```

**Structure Decision**: Option 1 (single project) — FastAPI backend with tests directories

## Phase 0: Outline & Research
1. Document stack alignment:
   - Confirm FastAPI + uv compatibility with Python 3.12, note docker-compose orchestration with PocketBase.
   - Capture deployment topology (two containers: api, pocketbase) and shared env management.
2. Investigate operational requirements:
   - Define logging/metrics strategy (structured JSON logs, PocketBase audit use, forwarding metrics via Prometheus-compatible exporter TBD).
   - Outline replay/backfill admin process and retention policy options; flag decisions needing product input (e.g., retention duration, replay approval flow).
3. Study integration boundaries:
   - Characterize PocketBase REST API usage (collections, schema definition, indexing) and limits for concurrent writes.
   - Review target outbound webhook formatting (Discord) and general templating approach for future destinations.
4. Capture open risks & assumptions:
   - Throughput targets, rate limiting, retry backoff strategy.
   - Storage growth expectations and pruning mechanism.

**Output**: research.md summarizing decisions, open questions for retention/rate limits, and recommended observability + runbook approach.

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Data modeling** (`data-model.md`):
   - Detail PocketBase collections for `webhook_events`, `destinations`, `delivery_logs` with schema, indexes, and relationships.
   - Define status transitions (`pending`, `forwarded`, `failed`, `retried`).
   - Capture configuration structure (YAML/env) to map sources to destinations.
2. **API contract** (`contracts/webhook-proxy.openapi.yaml`):
   - Specify `POST /webhooks/{sourceId}` request schema and 202/4xx responses.
   - Define `POST /webhooks/{sourceId}/replay` for admin-triggered replays (flagged pending decision) with clear TODO if disabled initially.
   - Include error envelopes describing retry tokens/log IDs.
3. **Quickstart** (`quickstart.md`):
   - Steps to clone repo, install uv, start docker compose (api + pocketbase), configure `.env`/YAML, send sample webhook, verify stored event and forwarded Discord message.
   - Include commands for generating JUnit and coverage reports, and referencing runbook for replays.
4. **Clarification integration**:
   - Align documentation to store raw payload + extracted fields.
   - Note outstanding retention/rate limit decisions.
5. **Agent context**: execute `.specify/scripts/bash/update-agent-context.sh codex` to refresh shared instructions with new stack info.

**Output**: data-model.md, /contracts/* artifacts, quickstart.md, updated agent context.

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Seed tasks.md from template ensuring Twelfth-Factor checks (runbooks) and no-force policies are explicit.
- Derive tasks from artifacts:
  - Contract tests for webhook ingest, replay (if enabled), and failure logging.
  - Data model migrations/collections for PocketBase.
  - Notification formatter unit tests (Discord + placeholder future dest).
  - Observability setup (structured logging, metrics counters).
  - Runbook & admin CLI tasks.
- Align tasks with TDD and ensure each has precise file paths under `src/` and `tests/`.

**Ordering Strategy**:
- Maintain TDD flow: contract/integration tests → infra scaffolding → implementation → runbooks → QA artifacts.
- Group by directories to maximize parallel [P] tasks where files differ.
- Include Docker Compose & CI pipeline adjustments prior to deployment tasks.

**Estimated Output**: ~28 tasks covering setup, tests, implementation, runbooks, and polish with explicit artifact verification.

**IMPORTANT**: Tasks.md is generated in this phase to satisfy user requirement for end-to-end planning.

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| *None* | — | — |


## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [ ] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented
- [x] No-force policy observed (no `--force`/`--force-with-lease`, `rm -rf`)
- [x] Plan changes committed and pushed to remote
- [x] Twelfth-Factor admin processes documented (runbooks/scripts planned)

---
*Based on Constitution v1.3.0 - See `.specify/memory/constitution.md`*
