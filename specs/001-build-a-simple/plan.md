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
Deliver a containerised webhook proxy that ingests arbitrary webhook payloads, stores both raw and extracted data in PocketBase, and forwards formatted notifications to downstream webhooks (e.g., Discord). Runtime is FastAPI (Python 3.12+) with PocketBase embedded as a Go module (per "Use PocketBase as a framework") to enable custom Go migrations and business logic. Docker Compose orchestrates the FastAPI API container and a Go-based PocketBase service. Focus areas: minimal configuration, no auth, extensible mappings/destinations, operational runbooks, and automated Go migrations for schema evolution.

## Technical Context
**Language/Version**: Python 3.12+ for FastAPI service; Go 1.22+ for PocketBase embedding/migrations  
**Primary Dependencies**: FastAPI, uv (dependency management), PocketBase framework SDK, pocketbase Go migration scaffolding, httpx, structlog, Prometheus instrumentation  
**Storage**: PocketBase (SQLite) embedded via Go module, running in dedicated container with mounted volume  
**Testing**: pytest, pytest-asyncio, httpx, pytest-mock, coverage (XML/HTML), mypy --strict, go test for migration package  
**Target Platform**: Docker Compose (api + pocketbase containers) on Linux  
**Project Type**: Single backend service with companion PocketBase framework app  
**Performance Goals**: Sustain 50 req/s with p95 < 300ms for forwarding; persistence latency < 50ms per event  
**Constraints**: No authentication, minimal configuration surface, Twelfth-Factor-compliant runbooks, no force commands, Go migrations auto-run on startup  
**Scale/Scope**: MVP supporting 3 source configs, 2 destinations, local-only deployment

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity First**: Keep architecture to two services (FastAPI + PocketBase Go app); defer advanced plugin system until needed.
- **Code Quality & PEP 8**: Enforce Ruff + Black; docstrings for public FastAPI handlers and services.
- **Python 3.12+ / Typing Everywhere**: `pyproject.toml` with `requires-python >=3.12`; mypy strict; pyright optional.
- **Tests First with Mandatory Reports**: Contract/integration tests before implementation; pytest produces JUnit/coverage artifacts; go tests emit coverage for migrations if feasible.
- **Continuous Quality Gates**: CI workflow runs lint/type/test/report checks for both Python and Go components.
- **Commit & Push Traceability**: Work in atomic commits; branch already synced; push after every artifact.
- **No Force Commands**: Reiterate policy in tasks; plan avoids destructive operations.
- **Twelfth-Factor Operations**: Runbook for Go migration execution & replay; migrations executed through same container image; CLI for admin processes.

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
│   ├── pocketbase_client.py
│   ├── scheduler/
│   └── cli.py
├── config/
├── logging.py
└── main.py

go/pocketbase/
├── main.go              # PocketBase framework bootstrap
├── migrations/          # Go migration files
└── pb_hooks.go          # Optional hooks

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

**Structure Decision**: Option 1 (single backend service + Go PocketBase submodule)

## Phase 0: Outline & Research
1. Validate PocketBase framework embedding: confirm Docker build strategy for Go app, migration hooks, and API surface between FastAPI and PocketBase.
2. Document Go migration workflow: command to create/run migrations (`go run github.com/pocketbase/pocketbase migrate`). Determine volume mounts to persist SQLite.
3. Assess integration between FastAPI and PocketBase: REST client vs gRPC, authentication (admin token), rate limits.
4. Investigate observability for PocketBase (logs, metrics) and reconcile with Twelfth-Factor requirements.
5. Capture open questions: retention policy, replay authorization, throughput expectations.

**Output**: research.md summarising stack choices, Go migration strategy, observability, and remaining questions.

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Data modeling** (`data-model.md`): define PocketBase collections with fields, indexes, relationships, and note Go migration file responsibilities.
2. **API contract** (`contracts/webhook-proxy.openapi.yaml`): specify webhook ingest/replay endpoints, error schemas, correlation IDs.
3. **PocketBase migration outline**: describe initial Go migration file responsibilities (create collections, indexes, initial config records).
4. **Quickstart** (`quickstart.md`): include instructions to build/run Docker Compose, execute Go migrations, seed configs, run FastAPI tests.
5. **Agent context**: run `.specify/scripts/bash/update-agent-context.sh codex` to register Go/PocketBase framework usage.

**Output**: data-model.md, contract spec, quickstart, updated agent context, migration outline.

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Seed tasks.md from template ensuring Twelfth-Factor and no-force gates.
- Derive tasks from artifacts: contract/integration tests, PocketBase Go migrations, FastAPI endpoint implementations, logging/metrics, Docker Compose orchestration, runbooks.
- Add Go-specific tasks (build pocketbase framework app, write migration file, run go tests).

**Ordering Strategy**:
- TDD flow: tests → infrastructure/migrations → implementation → ops/runbooks → polish.
- Distinguish Python vs Go tasks to allow parallelism on different directories.

**Estimated Output**: ~30 tasks covering tests, implementation, Go migrations, observability, docs, CI.

**IMPORTANT**: Tasks.md is generated in this phase to satisfy downstream automation.

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
