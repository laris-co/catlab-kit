# Tasks: Webhook Proxy Service Foundation

**Input**: Design documents from `/specs/001-build-a-simple/`
**Prerequisites**: plan.md, research.md, data-model.md, contracts/, go/pocketbase migrations outline

## Phase 3.1: Setup
- [ ] T001 Configure Python project metadata in `pyproject.toml` (Python >=3.12, FastAPI, uvicorn, structlog, testing deps)
- [ ] T002 [P] Initialise Go module under `go/pocketbase` (`go mod init`, add PocketBase dependency)
- [ ] T003 [P] Establish Docker Compose file `docker-compose.yaml` with `api` and `pocketbase` services, shared network, volumes
- [ ] T004 Scaffold FastAPI entrypoint `src/app/main.py` with health endpoint and settings loader
- [ ] T005 Create configuration module `src/app/config.py` loading env/YAML with type hints

## Phase 3.2: Tests First (TDD)
- [ ] T006 Author contract test `tests/contract/test_ingest_webhook.py` using httpx AsyncClient (202, 400, 404 cases)
- [ ] T007 Author contract test `tests/contract/test_replay_webhook.py` covering replay allowed/disabled cases
- [ ] T008 [P] Create unit tests `tests/unit/test_mapper.py` for payload mapping extraction
- [ ] T009 [P] Create unit tests `tests/unit/test_formatter_discord.py` for Discord formatting output
- [ ] T010 [P] Create integration test `tests/integration/test_event_persistence.py` verifying raw + extracted fields stored via PocketBase client
- [ ] T011 Create integration test `tests/integration/test_delivery_retry.py` simulating downstream failure and retry logging
- [ ] T012 Add observability test `tests/unit/test_logging_correlation.py` ensuring correlation IDs propagate
- [ ] T013 Add unit test `tests/unit/test_admin_cli.py` for replay CLI dry-run and Twelfth-Factor compliance
- [ ] T014 Create Go test `go/pocketbase/migrations/migrations_test.go` ensuring migrations create expected collections

## Phase 3.3: Core Implementation
- [ ] T015 Implement Go PocketBase app `go/pocketbase/main.go` registering migrations and starting server
- [ ] T016 Implement Go migration `migrations/001_init_collections.go` creating collections/indexes per data model
- [ ] T017 Implement Go migration `migrations/002_seed_sample.go` (optional seed data) with idempotent checks
- [ ] T018 Implement PocketBase client wrapper `src/app/pocketbase_client.py` with typed methods for CRUD and admin auth
- [ ] T019 Implement mapping service `src/app/mapping/service.py` converting raw payloads to configured fields
- [ ] T020 Implement event persistence service `src/app/events/service.py` storing raw payload + extracted fields, writing delivery logs
- [ ] T021 Implement notification dispatcher `src/app/notifications/dispatcher.py` with Discord formatter and retry policy
- [ ] T022 Wire FastAPI router `src/app/api/routes.py` for `/webhooks/{sourceId}` ingest endpoint
- [ ] T023 Implement replay handler/CLI `src/app/api/admin.py` & `src/app/cli.py` respecting replay-enabled flag
- [ ] T024 Add retry worker `src/app/scheduler/retry_worker.py` processing failed deliveries (in-process queue)

## Phase 3.4: Integration & Ops
- [ ] T025 Configure structured logging `src/app/logging.py` using structlog with correlation IDs
- [ ] T026 Integrate Prometheus instrumentation in `src/app/main.py` (`/metrics`)
- [ ] T027 Develop Dockerfile for API (multi-stage with uv) and Dockerfile for PocketBase Go app
- [ ] T028 Update Docker Compose to run migrations on PocketBase container startup (entrypoint script)
- [ ] T029 Add GitHub Actions workflow `.github/workflows/ci.yml` running Python & Go lint/type/test plus artifact uploads
- [ ] T030 Create PocketBase migration runbook `docs/runbooks/migrations.md`
- [ ] T031 Create replay runbook `docs/runbooks/replay.md`
- [ ] T032 Add admin CLI command tests/integration verifying Twelfth-Factor requirements

## Phase 3.5: Polish
- [ ] T033 Update README with webhook proxy overview, runbooks, quickstart link
- [ ] T034 Export OpenAPI spec to `generated/openapi.json` and ensure docs available at `/docs`
- [ ] T035 Verify coverage ≥ 85% and enforce via pytest config
- [ ] T036 Document retention/rate-limit decisions once clarified (update spec + docs)
- [ ] T037 Audit configuration files for minimal surface and align with Twelfth-Factor principles

## Validation Checklist
- [ ] Contract/integration tests fail before implementation then pass after relevant tasks
- [ ] Test reports generated: `test-reports/junit.xml`, `coverage/coverage.xml`, `coverage/html/`
- [ ] Go tests for migrations executed in CI with coverage (if possible)
- [ ] No force flags used (git `--force`/`--force-with-lease`, `rm -rf`, similar)
- [ ] Twelfth-Factor runbooks/scripts created for operational steps
- [ ] CI pipeline uploads artifacts and enforces gates for Python & Go components
