# Tasks: Webhook Proxy Service Foundation

**Input**: Design documents from `/specs/001-build-a-simple/`
**Prerequisites**: plan.md, research.md, data-model.md, contracts/, quickstart.md

## Phase 3.1: Setup
- [ ] T001 Create project skeleton: `src/app/` (api/, mapping/, notifications/, events/, scheduler/), `tests/` (contract/, integration/, unit/), and supporting files (`config/`, `docs/runbooks/`).
- [ ] T002 [P] Configure `pyproject.toml` for Python 3.12 with FastAPI, uvicorn, httpx, structlog, prometheus instrumentation, testing (pytest, pytest-asyncio, httpx), mypy --strict, Ruff, Black, and uv build backend metadata.
- [ ] T003 [P] Initialize Go module under `go/pocketbase/` (`go.mod`, `go.sum`) with PocketBase framework dependency and standard tooling (lint/test scripts).
- [ ] T004 Define environment templates: create `.env.example` and `config/sources.yaml` scaffold reflecting required variables from quickstart.
- [ ] T005 Establish Docker Compose orchestrator `docker-compose.yaml` wiring FastAPI `api` and PocketBase `pocketbase` services, shared network, env files, and persistent PocketBase volume.

## Phase 3.2: Tests First (author, run, and watch them fail)
- [ ] T006 Write contract tests for `POST /webhooks/{sourceId}` in `tests/contract/test_ingest_webhook.py` covering accepted, mapping validation error (400), and unknown source (404) responses with httpx AsyncClient.
- [ ] T007 Write contract tests for `POST /admin/events/{eventId}/replay` in `tests/contract/test_replay_webhook.py` verifying replay scheduled (202), disabled (403), and missing event (404) flows.
- [ ] T008 [P] Create integration test `tests/integration/test_event_persistence.py` ensuring raw payload + mapped fields persist via PocketBase client with correlation IDs.
- [ ] T009 [P] Create integration test `tests/integration/test_delivery_pipeline.py` simulating downstream webhook dispatch, retry policy, and delivery log creation.
- [ ] T010 [P] Add unit tests `tests/unit/test_mapping_service.py` validating JSON path extraction and required field handling from source configs.
- [ ] T011 [P] Add unit tests `tests/unit/test_notifications_dispatcher.py` covering Discord formatter rendering, retries, and error logging.
- [ ] T012 Add Go migration test `go/pocketbase/migrations/migrations_test.go` asserting collections/indexes exist after running migrations.
- [ ] T013 Add observability + CLI unit tests `tests/unit/test_logging_and_cli.py` for structlog correlation propagation and replay CLI guard rails.

## Phase 3.3: Data & Models
- [ ] T014 Implement initial migration `go/pocketbase/migrations/001_init_collections.go` creating `webhook_events`, `destinations`, `source_configs`, `delivery_logs` with indexes and rules per data-model.md.
- [ ] T015 Implement optional seed migration `go/pocketbase/migrations/002_seed_destinations.go` inserting sample destinations guarded for idempotency.
- [ ] T016 Register migrations and startup hooks in `go/pocketbase/main.go`, exposing CLI entry (`migrate up/down`) and ensuring automatic execution at boot.
- [ ] T017 [P] Define Pydantic models for webhook events in `src/app/models/webhook_event.py` matching PocketBase schema and typed delivery status enum.
- [ ] T018 [P] Define Pydantic models for destinations in `src/app/models/destination.py` with formatter template representation and enabled flag.
- [ ] T019 [P] Define Pydantic models for source configurations in `src/app/models/source_config.py` capturing mappings, destination order, and replay flag.
- [ ] T020 [P] Define Pydantic models for delivery logs in `src/app/models/delivery_log.py` capturing attempt metadata and status enums.

## Phase 3.4: Core Services & Endpoints
- [ ] T021 Implement PocketBase admin client `src/app/pocketbase_client.py` handling auth token management, CRUD helpers, retry/backoff, and correlation ID headers.
- [ ] T022 Implement mapping service `src/app/mapping/service.py` applying source configuration mappings to raw payloads with validation errors aligned to contract.
- [ ] T023 Implement event persistence workflow `src/app/events/service.py` storing raw payloads, extracted fields, updating attempt counters, and emitting delivery logs.
- [ ] T024 Implement notification dispatcher `src/app/notifications/dispatcher.py` with Discord formatter, HTTP delivery via httpx, retry schedule, and structured logging.
- [ ] T025 Implement scheduler/worker `src/app/scheduler/retry_worker.py` to process pending/failed deliveries and invoke dispatcher respecting throttle rules.
- [ ] T026 Wire FastAPI routes `src/app/api/routes.py` for ingest endpoint delegating to mapping, persistence, dispatcher, and returning correlation IDs.
- [ ] T027 Implement admin replay surface: CLI command in `src/app/cli.py` and FastAPI admin router `src/app/api/admin.py` enforcing replay-enabled guard.
- [ ] T028 Compose FastAPI entrypoint `src/app/main.py` with app factory, dependency wiring, Prometheus instrumentation, and startup/shutdown handlers.

## Phase 3.5: Integration & Ops
- [ ] T029 Configure structured logging in `src/app/logging.py` using structlog, injecting correlation IDs, and hooking into FastAPI middleware.
- [ ] T030 Instrument metrics exposure via `prometheus_fastapi_instrumentator` and custom counters in `src/app/main.py` and dispatcher.
- [ ] T031 Create Dockerfile for API (`Dockerfile.api`) leveraging uv for install and multi-stage build; ensure reproducible builds.
- [ ] T032 Create Dockerfile for PocketBase Go app (`go/pocketbase/Dockerfile`) building binary and running migrations on start.
- [ ] T033 Update `docker-compose.yaml` to build images, mount PocketBase volume, pass environment, and wait-for dependency between services.
- [ ] T034 Establish GitHub Actions workflow `.github/workflows/ci.yml` running Ruff, Black, mypy, pytest (with coverage + JUnit), and `go test ./...` with artifact uploads.
- [ ] T035 Draft migration runbook `docs/runbooks/migrations.md` covering CLI usage, Docker Compose exec, and CI expectations.
- [ ] T036 Draft replay operations runbook `docs/runbooks/replay.md` covering CLI usage, safeguards, and rollback strategy.
- [ ] T037 Add configuration hardening checklist `docs/runbooks/configuration.md` documenting env vars, secrets management, and Twelfth-Factor compliance.

## Phase 3.6: Polish & Validation
- [ ] T038 Update `README.md` with architecture overview, quickstart highlights, and links to runbooks/OpenAPI docs.
- [ ] T039 Export bundled OpenAPI spec to `generated/openapi.json` and enable FastAPI docs at `/docs` and `/redoc`.
- [ ] T040 Enforce coverage gate ≥85% via pytest config (`pyproject.toml` or `pytest.ini`) and document reporting to `coverage/` + `test-reports/`.
- [ ] T041 Audit retention and rate-limit decisions once clarified; update `docs/architecture.md` and data model comments accordingly.
- [ ] T042 Perform final quality sweep: run `uv run ruff check`, `uv run black --check`, `uv run mypy --strict`, `uv run pytest ...`, and `go test ./...`; capture artifacts in `test-reports/` and `coverage/` directories.

## Dependencies
- T001 → T002, T004, T005 (directories required before config files).
- T002 → T006–T011, T021–T028, T029–T042 (Python environment before code/tests).
- T003 → T012, T014–T016, T032, T034 (Go module before migrations/tests/CI).
- T004 → T005, T033, T037 (env scaffolding before compose/config docs).
- T005 → T033 (compose relies on base file), T031–T033 (containerization).
- T006 & T007 must be completed before T026 & T027 (contracts before endpoints).
- T008–T013 before corresponding implementations T021–T028.
- T014–T016 before services relying on PocketBase data (T021–T025) and CI (T034).
- T017–T020 before services using typed models (T021–T025).
- T021–T027 before integration ops tasks T029–T037.
- T029–T033 before final validation T042.
- T034 before claiming CI coverage in polish phase.
- T035–T037 before README update T038 (links/reference material).
- T038–T041 should complete before final sweep T042.

## Parallel Execution Examples
```bash
# After T002 and T003, run parallel test authoring tasks
swe task run T008
swe task run T009
swe task run T010
swe task run T011

# After migrations (T014–T016), implement independent models in parallel
swe task run T017
swe task run T018
swe task run T019
swe task run T020
```

## Validation Checklist
- [ ] Contract and integration tests (T006–T013) fail before implementing services/endpoints, then pass.
- [ ] Test reports generated at `test-reports/junit.xml` and coverage artifacts at `coverage/coverage.xml` + `coverage/html/` during T042.
- [ ] Go tests (`go test ./...`) executed with migrations coverage as part of T012 and T042.
- [ ] No destructive commands used (no `--force`, `--force-with-lease`, `rm -rf`).
- [ ] Twelfth-Factor runbooks (T035–T037) published alongside implementation.
- [ ] CI workflow (T034) enforces lint/type/test gates for Python and Go components.
- [ ] Docker Compose + Dockerfiles (T031–T033) align with quickstart and run migrations automatically.
