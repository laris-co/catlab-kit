# Research Log — Webhook Proxy Service Foundation

**Date**: 2025-09-25  
**Participants**: Codex planning agent  
**Spec Reference**: /specs/001-build-a-simple/spec.md

## Decisions

### Stack & Tooling
- **Python Runtime**: Adopt Python 3.12 for compliance with constitution Principle III.
- **Framework**: FastAPI chosen for async request handling, automatic schema docs, and ecosystem support.
- **Runtime Tooling**: Use `uv` for dependency management and packaging; aligns with Python 3.12 and simplifies reproducible installs.
- **Deployment**: Compose two services: `api` (FastAPI) and `pocketbase`. Compose file defines shared network, env vars, and volumes for PocketBase storage.

### Storage & Data Flow
- **Database**: PocketBase (SQLite-backed) stores webhook events, destination mappings, and delivery logs.
- **Event Persistence**: Store both raw payload JSON and extracted fields per clarification; raw payload kept in `webhook_events.raw_payload` (JSON) and normalized fields in `webhook_events.payload_fields` (JSONB-like).
- **Retention Strategy**: Default to 30 days retention with configurable setting; requires confirmation (open question).

### Observability & Operations
- **Logging**: Emit structured JSON logs via `structlog` (or FastAPI logging config) with correlation IDs per event.
- **Metrics**: Integrate Prometheus FastAPI instrumentation (e.g., `prometheus-fastapi-instrumentator`) publishing to `/metrics` for future scraping.
- **Tracing**: Optional future addition; not part of MVP.
- **Runbooks**: Create `docs/runbooks/replay.md` describing replay CLI/endpoint, required env vars, and rollback steps.

### Notification Formatting
- **Destination Templates**: Provide Discord webhook formatter (username, avatar, content) with fallback plain JSON. Abstract formatters to allow new destinations.
- **Retry Strategy**: Exponential backoff (2^n seconds, max 5 attempts) stored per delivery log entry.

## Open Questions / Risks
- **Retention Duration**: Need stakeholder confirmation on 30-day purge (FR gap from spec).
- **Replay Authorization**: Clarify who can trigger replays since no auth is planned; propose limited to CLI command executed by operator (document in runbook).
- **Rate Limits**: Need target inbound/outbound rate limits to size queues and backoff windows.
- **PocketBase Limits**: Validate concurrent write throughput and index strategy to avoid contention.

## References
- FastAPI docs: https://fastapi.tiangolo.com/
- PocketBase REST API: https://pocketbase.io/docs/api-records
- Discord Webhook Formatting: https://discord.com/developers/docs/resources/webhook
- `uv` project: https://github.com/astral-sh/uv
