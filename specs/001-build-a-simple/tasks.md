# Tasks: Webhook Proxy Service Foundation

**Input**: Design documents from `/home/floodboy/catlab-kit/specs/001-build-a-simple/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory → Extract tech stack/libraries
2. Load optional docs: data-model.md, contracts/, research.md, quickstart.md
3. Generate tasks by category: Setup → Tests → Core → Integration → Polish
4. Apply rules: Tests before implementation; [P] for parallel (different files)
5. Number tasks sequentially; include dependencies and parallel examples
6. Validate: reports, coverage, Twelfth-Factor admin/runbooks, no-force policy
```

## Format: `[ID] [P?] Description`
- [P] = can run in parallel (different files, no dependencies)
- Include exact absolute file paths in descriptions
- After each task: commit and push to remote; never use force flags

## Phase 3.1: Setup
- [X] T001 Create project structure and package files
  - Files: 
    - `/home/floodboy/catlab-kit/src/__init__.py`
    - `/home/floodboy/catlab-kit/src/api/__init__.py`
    - `/home/floodboy/catlab-kit/src/models/__init__.py`
    - `/home/floodboy/catlab-kit/src/services/__init__.py`
    - `/home/floodboy/catlab-kit/src/cli/__init__.py`
    - `/home/floodboy/catlab-kit/config/.gitkeep`
    - `/home/floodboy/catlab-kit/tests/contract/__init__.py`
    - `/home/floodboy/catlab-kit/tests/integration/__init__.py`
    - `/home/floodboy/catlab-kit/tests/unit/__init__.py`
  - cmd: `applypatch` to create files and folders
  - done-when: directories exist and tracked in git
  - git: `git add -A && git commit -m "T001: scaffold project structure" && git push`

- [X] T002 Initialize `pyproject.toml` with Python 3.12, deps, and tool configs
  - File: `/home/floodboy/catlab-kit/pyproject.toml`
  - Include runtime deps: fastapi, httpx, structlog, prometheus-client, pydantic, pyyaml, ulid-py, uvicorn
  - Include dev deps: pytest, pytest-cov, mypy (strict), ruff, black, types-PyYAML
  - Configure: Ruff, Black, mypy (strict), pytest (junitxml), coverage (XML+HTML)
  - cmd: `applypatch` to add minimal pyproject
  - done-when: `uv pip install -e .[dev]` succeeds locally
  - git: `git add -A && git commit -m "T002: add pyproject + tooling" && git push`

- [X] T003 [P] Add Docker Compose for PocketBase (and optional app)
  - File: `/home/floodboy/catlab-kit/docker-compose.yml`
  - Services: `pocketbase` with volume at `./pb_data` and port 8090; app optional
  - cmd: `applypatch` to add compose; `docker compose up -d pocketbase`
  - done-when: `docker ps` shows pocketbase running
  - git: `git add -A && git commit -m "T003: docker-compose for PocketBase" && git push`

- [X] T004 [P] Example config file for mappings and destinations
  - File: `/home/floodboy/catlab-kit/config/webhook-proxy.yaml`
  - Content: matches quickstart; uses `${DISCORD_WEBHOOK_URL}` env var
  - cmd: `applypatch` to add YAML example
  - done-when: file exists; env override documented
  - git: `git add -A && git commit -m "T004: add example config" && git push`

- [X] T005 [P] CI workflow to run tests and archive reports
  - File: `/home/floodboy/catlab-kit/.github/workflows/ci.yml`
  - Steps: setup Python 3.12; install with uv; run ruff/black/mypy/pytest; upload `test-reports/` and `coverage/`
  - cmd: `applypatch` to add workflow
  - done-when: workflow green on PRs
  - git: `git add -A && git commit -m "T005: add CI workflow" && git push`

- [X] T006 PocketBase migrations (Go) for collections
  - Paths (create if absent):
    - `/home/floodboy/catlab-kit/pb/go.mod`
    - `/home/floodboy/catlab-kit/pb/main.go`
    - `/home/floodboy/catlab-kit/pb/migrations/0001_init.go`
  - Define collections: `webhook_events`, `delivery_logs` per data-model.md
  - cmd: `applypatch` to scaffold; `go mod tidy`
  - done-when: `go run ./pb` starts PocketBase with embedded migrations
  - git: `git add -A && git commit -m "T006: scaffold PocketBase migrations" && git push`

## Phase 3.2: Tests First (TDD) — MUST FAIL initially
- [X] T007 [P] Contract test for GET /healthz
  - File: `/home/floodboy/catlab-kit/tests/contract/test_healthz_contract.py`
  - Assert: OpenAPI contains `/healthz`; TestClient GET returns 200
  - cmd: `applypatch` to add test; `pytest -q`
  - done-when: test exists and currently fails
  - git: `git add -A && git commit -m "T007: add healthz contract test" && git push`

- [X] T008 [P] Contract test for POST /webhook/{source}
  - File: `/home/floodboy/catlab-kit/tests/contract/test_webhook_post_contract.py`
  - Assert: OpenAPI contains `/webhook/{source}` with POST; response schema has `event_id` and `notification_status`
  - cmd: `applypatch` to add test; `pytest -q`
  - done-when: test exists and currently fails
  - git: `git add -A && git commit -m "T008: add webhook POST contract test" && git push`

- [X] T009 [P] Integration test — primary user story
  - File: `/home/floodboy/catlab-kit/tests/integration/test_end_to_end_basic.py`
  - Scenario: load config; POST payload to `/webhook/alerts`; assert stored (mock PB); assert notification attempted; status recorded
  - cmd: `applypatch` to add test; `pytest -q`
  - done-when: test exists and currently fails
  - git: `git add -A && git commit -m "T009: add e2e basic test" && git push`

- [X] T010 [P] Integration test — payload too large (413)
  - File: `/home/floodboy/catlab-kit/tests/integration/test_payload_limit.py`
  - Scenario: >1 MiB body returns 413
  - cmd: `applypatch` to add test; `pytest -q`
  - done-when: test exists and currently fails
  - git: `git add -A && git commit -m "T010: add payload limit test" && git push`

- [X] T011 [P] Integration test — missing mapped fields resolve empty
  - File: `/home/floodboy/catlab-kit/tests/integration/test_missing_fields.py`
  - Scenario: mapping references absent fields; notification uses defaults; event stored
  - cmd: `applypatch` to add test; `pytest -q`
  - done-when: test exists and currently fails
  - git: `git add -A && git commit -m "T011: add missing fields test" && git push`

- [X] T012 [P] Integration test — destination timeout -> failed delivery
  - File: `/home/floodboy/catlab-kit/tests/integration/test_destination_timeout.py`
  - Scenario: mock destination timeout >5s; status failed; failure recorded
  - cmd: `applypatch` to add test; `pytest -q`
  - done-when: test exists and currently fails
  - git: `git add -A && git commit -m "T012: add destination timeout test" && git push`

## Phase 3.3: Core Implementation (only after tests are failing)
- [X] T013 Create FastAPI app factory and health endpoint
  - Files:
    - `/home/floodboy/catlab-kit/src/app.py` (function `create_app()`)
    - `/home/floodboy/catlab-kit/src/api/health.py` (GET /healthz)
  - cmd: `applypatch` to add modules; `pytest -q`
  - done-when: healthz contract test passes
  - git: `git add -A && git commit -m "T013: add FastAPI app + healthz" && git push`

- [X] T014 Config loader for mappings/destinations with auto-reload
  - File: `/home/floodboy/catlab-kit/src/services/config_loader.py`
  - Behavior: load YAML; env var overrides; reload if mtime changed within 60s window
  - cmd: `applypatch` to add module; `pytest -q`
  - done-when: used by webhook route; unit tests to follow
  - git: `git add -A && git commit -m "T014: config loader with reload" && git push`

- [X] T015 Dotted-path field extractor
  - File: `/home/floodboy/catlab-kit/src/services/mapping.py`
  - Behavior: extract dict path values with defaults; return mapping dict
  - cmd: `applypatch` to add module; `pytest -q`
  - done-when: missing fields test eventually passes
  - git: `git add -A && git commit -m "T015: add mapping extractor" && git push`

- [X] T016 PocketBase REST client wrapper
  - File: `/home/floodboy/catlab-kit/src/services/pb_client.py`
  - Methods: `store_event`, `log_delivery`
  - cmd: `applypatch` to add module; `pytest -q`
  - done-when: e2e test can stub PB calls
  - git: `git add -A && git commit -m "T016: add PocketBase client" && git push`

- [X] T017 Outbound delivery service
  - File: `/home/floodboy/catlab-kit/src/services/delivery.py`
  - Behavior: build message from template; POST to destination with 5s timeout; no retries; return status
  - cmd: `applypatch` to add module; `pytest -q`
  - done-when: destination-timeout test passes
  - git: `git add -A && git commit -m "T017: add outbound delivery service" && git push`

- [X] T018 Webhook endpoint implementation
  - Files:
    - `/home/floodboy/catlab-kit/src/api/webhook.py` (POST /webhook/{source})
    - integrate into `/home/floodboy/catlab-kit/src/app.py`
  - Behavior: enforce 1 MiB limit; store event; attempt notification; record DeliveryLog
  - cmd: `applypatch` to add route; `pytest -q`
  - done-when: webhook contract test passes
  - git: `git add -A && git commit -m "T018: implement webhook endpoint" && git push`

- [X] T019 Prometheus metrics exposure
  - File: `/home/floodboy/catlab-kit/src/services/metrics.py`
  - Counters: events_received_total, events_stored_total, notifications_sent_total, notifications_failed_total
  - cmd: `applypatch` to add module; wire into app
  - done-when: counters increment during tests
  - git: `git add -A && git commit -m "T019: add metrics" && git push`

- [X] T020 Admin CLI command `purge-events` + runbook
  - Files:
    - `/home/floodboy/catlab-kit/src/cli/admin.py` (click or argparse)
    - `/home/floodboy/catlab-kit/docs/runbooks/purge-events.md`
  - Behavior: delete records via PB REST; document execution/rollback
  - cmd: `applypatch` to add CLI and docs
  - done-when: manual dry-run documented in runbook
  - git: `git add -A && git commit -m "T020: add purge-events CLI + runbook" && git push`

## Phase 3.4: Integration
- [X] T021 Structlog configuration and request logging middleware
  - Files: `/home/floodboy/catlab-kit/src/services/logging.py`, update app wiring
  - cmd: `applypatch`; `pytest -q`
  - done-when: logs emitted in tests
  - git: `git add -A && git commit -m "T021: add structured logging" && git push`

- [X] T022 Dev server wiring and quickstart validation
  - Files: `/home/floodboy/catlab-kit/Makefile` with `dev`, `test`, `lint` targets
  - Steps: `uvicorn src.app:create_app --factory --reload`
  - cmd: `applypatch`; validate quickstart.md; `pytest -q`
  - done-when: quickstart steps run cleanly
  - git: `git add -A && git commit -m "T022: add Makefile + dev wiring" && git push`

- [X] T023 Update OpenAPI contract as needed
  - File: `/home/floodboy/catlab-kit/specs/001-build-a-simple/contracts/openapi.yaml`
  - Ensure: response schemas, examples, 503/413 cases
  - cmd: `applypatch`; `pytest -q`
  - done-when: contract tests pass
  - git: `git add -A && git commit -m "T023: refine OpenAPI spec" && git push`

## Phase 3.5: Polish
- [X] T024 [P] Unit tests for mapping/config/metrics
  - Files: `/home/floodboy/catlab-kit/tests/unit/test_mapping.py`, `test_config_loader.py`, `test_metrics.py`
  - cmd: `applypatch`; `pytest -q`
  - done-when: unit tests pass
  - git: `git add -A && git commit -m "T024: add unit tests" && git push`

- [ ] T025 [P] Linting and typing clean
  - Run: `ruff check --output-format=github . && mypy --strict`
  - done-when: zero errors
  - git: `git add -A && git commit -m "T025: lint + typing clean" && git push`

- [X] T026 [P] Update quickstart and examples
  - File: `/home/floodboy/catlab-kit/specs/001-build-a-simple/quickstart.md`
  - Ensure: consistent with implemented CLI/app
  - cmd: `applypatch`
  - done-when: doc reflects current behavior
  - git: `git add -A && git commit -m "T026: update quickstart" && git push`

- [X] T027 [P] Update AGENTS.md manual notes
  - File: `/home/floodboy/catlab-kit/AGENTS.md`
  - Add reminder: commit and push after each task; never force (already present, verify)
  - cmd: `applypatch` if needed
  - done-when: note present under MANUAL ADDITIONS
  - git: `git add -A && git commit -m "T027: ensure commit/push note" && git push`

- [ ] T028 [P] Coverage and reports archived in CI
  - Validate CI uploads `test-reports/` and `coverage/`
  - done-when: artifacts visible on CI runs
  - git: `git add -A && git commit -m "T028: verify CI reports" && git push`

## Dependencies
- T001 → T002/T003/T004
- T002 → T007–T012 (tests need tooling)
- T006 (migrations) optional for unit/integration with mocks; required before full e2e with real PB
- Tests T007–T012 must fail before T013–T018
- T013 → T018; T014/T015/T016/T017 feed into T018
- Implementation (T013–T023) before polish (T024–T028)

## Parallel Execution Examples
```
# Example 1: Parallel tests
Run T007, T008, T009, T010, T011, T012 concurrently — different files.

# Example 2: Parallel polish
Run T024, T025, T026, T027, T028 concurrently — independent files/pipelines.
```

## Validation Checklist
- All contracts have tests (T007, T008)
- All entities have model/storage tasks (T016, PB migrations in T006)
- Tests precede implementation (T007–T012 before T013–T018)
- Parallel tasks touch different files only
- Each task specifies absolute file paths
- Test reports produced (JUnit XML + coverage XML/HTML)
- Twelfth-Factor admin runbook created (T020)
- No force flags used; commits pushed after each task
