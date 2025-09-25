# Research Log — Webhook Proxy Service Foundation

**Date**: 2025-09-25  
**Participants**: Codex planning agent  
**Spec Reference**: /specs/001-build-a-simple/spec.md

## Decisions

### PocketBase as Framework
- Adopt PocketBase framework mode (https://pocketbase.io/docs/use-as-framework/) embedding the server in a Go binary so we can add custom migrations and hooks.
- Structure Go module under `go/pocketbase` with `main.go` to start PocketBase, register migrations, and expose REST interface at `:8090`.
- Mount persistent volume for `pb_data/` in Docker Compose to retain SQLite data.

### Go Migrations
- Use PocketBase migrations package (`github.com/pocketbase/pocketbase/migrations`) to manage schema via Go files.
- Create initial migration `001_init_collections.go` to define `webhook_events`, `destinations`, `source_configs`, and `delivery_logs` collections, including indexes and constraints consistent with data-model.md.
- Run migrations on PocketBase startup (inside `main.go`) and expose CLI command `go run go/pocketbase/main.go migrate` for manual execution.

### FastAPI Service
- Python 3.12 with FastAPI/uvicorn; manage dependencies via `uv` for reproducible builds.
- Communicate with PocketBase through REST using admin token stored in environment (`POCKETBASE_ADMIN_TOKEN`).
- Store raw payload + extracted fields per clarification; maintain correlation IDs across logs and delivery logs.

### Containerization
- Docker Compose orchestrates:
  - `api`: FastAPI app, depends_on `pocketbase`, uses `uv` to install deps, exposes `:8000`.
  - `pocketbase`: Go binary built via multi-stage Dockerfile (Go build stage + minimal runtime), exposes `:8090` and runs migrations on start.
- Shared `.env` config consumed by both services via Compose.

### Observability & Ops
- FastAPI: structured JSON logs (structlog), Prometheus instrumentation via `prometheus-fastapi-instrumentator`.
- PocketBase: enable request logging and pipe to container stdout; capture metrics via sidecar in future (out of scope for MVP).
- Runbooks: create `docs/runbooks/replay.md` and `docs/runbooks/migrations.md` documenting replay CLI and migration execution flow.

## Open Questions / Risks
- Retention duration for webhook events (default 30 days) — confirm with stakeholders.
- Rate limiting thresholds for inbound requests and replay operations.
- Replay authorization (currently CLI-only to avoid auth requirements) — confirm acceptable.
- PocketBase performance under concurrent writes at projected throughput — monitor during integration.
- Discord webhook rate limits — ensure retry strategy respects platform constraints.

## References
- PocketBase framework docs: https://pocketbase.io/docs/use-as-framework/
- PocketBase migrations: https://pocketbase.io/docs/migrations/
- FastAPI docs: https://fastapi.tiangolo.com/
- Discord Webhook formatting: https://discord.com/developers/docs/resources/webhook
- uv project: https://github.com/astral-sh/uv
