# Tasks: Webhook Proxy Service Foundation

**Input**: Design documents from `/specs/001-build-a-simple/`
**Prerequisites**: plan.md, research.md, data-model.md, contracts/

## Phase 3.1: Setup
- [ ] T001 Configure uv project metadata in `pyproject.toml` (Python >=3.12, FastAPI, uvicorn, PocketBase client libs)
- [ ] T002 [P] Establish Docker Compose file `docker-compose.yaml` with `api` and `pocketbase` services, shared network, and volumes
- [ ] T003 [P] Scaffold FastAPI app entrypoint `src/app/main.py` with health endpoint and settings loader
- [ ] T004 Add configuration module `src/app/config.py` to load env/YAML mappings with type hints

## Phase 3.2: Tests First (TDD)
- [ ] T005 Author contract test `tests/contract/test_ingest_webhook.py` using httpx AsyncClient verifying 202, 400, 404 scenarios
- [ ] T006 Author contract test `tests/contract/test_replay_webhook.py` covering replay allowed/disabled cases
- [ ] T007 [P] Create unit tests `tests/unit/test_mapper.py` for payload mapping extraction logic
- [ ] T008 [P] Create unit tests `tests/unit/test_formatter_discord.py` ensuring Discord payload formatting
- [ ] T009 [P] Create integration test `tests/integration/test_event_persistence.py` that uses PocketBase test container to assert raw payload + extracted fields saved
- [ ] T010 Create integration test `tests/integration/test_delivery_retry.py` simulating downstream failure and retry logging
- [ ] T011 Add observability test `tests/unit/test_logging_correlation.py` to ensure correlation IDs propagate to logs
- [ ] T012 Prepare runbook validation test `tests/unit/test_runbook_commands.py` (CLI replay command dry run)

## Phase 3.3: Core Implementation
- [ ] T013 Implement PocketBase client wrapper `src/app/pocketbase/client.py` with typed methods for CRUD
- [ ] T014 Implement mapping engine `src/app/mapping/service.py` converting raw payload to configured fields
- [ ] T015 Implement persistence service `src/app/events/service.py` storing raw payload + extracted fields, writing delivery logs
- [ ] T016 Implement notification dispatcher `src/app/notifications/dispatcher.py` with Discord formatter and retry strategy
- [ ] T017 Wire FastAPI router `src/app/api/routes.py` for `/webhooks/{sourceId}` ingest endpoint
- [ ] T018 Implement replay command `src/app/api/admin.py` (endpoint or CLI) respecting replay-enabled flag
- [ ] T019 Add background task scheduler `src/app/scheduler/retry_worker.py` to process retry queue (in-process for MVP)
- [ ] T020 Update configuration loader to hydrate PocketBase collections on startup if missing (idempotent)

## Phase 3.4: Integration & Ops
- [ ] T021 Add structured logging configuration `src/app/logging.py` using structlog with correlation IDs
- [ ] T022 Integrate Prometheus Instrumentator in `src/app/main.py` exposing `/metrics`
- [ ] T023 Create Dockerfile for API service with uv-managed dependencies and pytest stage
- [ ] T024 Define GitHub Actions workflow `.github/workflows/ci.yml` running lint, type check, tests, artifact uploads
- [ ] T025 Create PocketBase migration seed script `scripts/bootstrap_pocketbase.py` ensuring schema aligns with data model
- [ ] T026 Document replay runbook `docs/runbooks/replay.md` including docker-compose exec examples
- [ ] T027 Add admin CLI entrypoint `src/app/cli.py` exposing replay/backfill commands (Twelfth-Factor compliance)

## Phase 3.5: Polish
- [ ] T028 Update README section detailing webhook proxy usage and link to quickstart
- [ ] T029 Generate OpenAPI docs route `/docs` and export static spec `generated/openapi.json`
- [ ] T030 Verify coverage threshold >= 85% and update `pyproject.toml` coverage config
- [ ] T031 Ensure lint/type/test commands documented in CONTRIBUTING.md or README quality section
- [ ] T032 Finalize retention policy configuration docs once stakeholder answer received (placeholder update)

## Validation Checklist
- [ ] All contract and integration tests fail before implementation then pass after relevant tasks
- [ ] Test reports: `test-reports/junit.xml`, `coverage/coverage.xml`, `coverage/html/`
- [ ] No force flags used in git or scripts
- [ ] Twelfth-Factor runbooks/scripts created for operational steps
- [ ] CI pipeline uploads artifacts and enforces gates
