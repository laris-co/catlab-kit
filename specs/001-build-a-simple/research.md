# Research Notes — Webhook Proxy Service Foundation

Date: 2025-09-25 | Branch: 001-build-a-simple
Input Spec: /home/floodboy/catlab-kit/specs/001-build-a-simple/spec.md

## Key Decisions

1) Endpoint shape
- Decision: POST /webhook/{source}
- Rationale: Single generic entrypoint keeps routing/config simple.
- Alternatives: Multiple endpoints per source; dynamic routes — rejected for initial simplicity.

2) Storage engine
- Decision: PocketBase (SQLite) for `WebhookEvent` and `DeliveryLog`.
- Rationale: Matches active technologies; trivial to embed and migrate.
- Alternatives: PostgreSQL, file-based logs — rejected for additional ops weight.

3) Configuration surface
- Decision: Single YAML file (mount via docker-compose) with optional env var overrides.
- Rationale: Clear diffs, easy review; meets “minimal configuration” goal.
- Alternatives: DB-stored config, UI admin — deferred.

4) Mapping rules
- Decision: Simple dotted-path selectors (e.g., `issue.title`) mapping to alias keys used in templates.
- Rationale: Human-readable, easy to implement; strict JSONPath not required yet.
- Alternatives: JSONPath/JMESPath — deferred for complexity.

5) Notification delivery
- Decision: Synchronous attempt in request path with 5s timeout, no retries; log outcome.
- Rationale: No background workers; reduced moving parts.
- Alternatives: Async queue + worker, retry/backoff — deferred.

6) Deduplication
- Decision: None (store every delivery).
- Rationale: Simplest; aligns with spec clarifications.
- Alternatives: Idempotency-key or hash-window — deferred.

7) Security posture
- Decision: No inbound auth; assume non-sensitive data only; document clearly.
- Rationale: Scope-limited prototype; avoids key management.
- Alternatives: HMAC secrets, OAuth — deferred.

8) Observability
- Decision: Structured logs (structlog) + Prometheus counters: events_received_total, events_stored_total, notifications_sent_total, notifications_failed_total.
- Rationale: Minimal but useful signals.
- Alternatives: Tracing — deferred.

9) Admin/runbooks
- Decision: Provide `purge-events` admin command with runbook (same config env) per Constitution.
- Rationale: Twelfth-Factor operations readiness compliance.

## Open Questions (Deferred, non-blocking)
- Performance SLAs beyond “low volume” — defer to future needs.
- Rich template engine for destinations (Markdown, embeds) — start with simple string template.

## References
- Spec clarifications (2025-09-25, 2025-09-26) establish: no dedup, no retries, 5s timeout, 1 MiB limit, non-sensitive data only.

