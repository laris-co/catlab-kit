# Data Model — Webhook Proxy Service Foundation

## PocketBase Collections (defined via Go migrations)

### webhook_events
- `id` (PocketBase record id, UUID string) — primary key.
- `source_identifier` (string, indexed) — matches configured source key.
- `received_at` (datetime, indexed) — inbound timestamp.
- `raw_payload` (JSON) — full payload stored verbatim.
- `payload_fields` (JSON) — extracted fields per configuration mapping.
- `delivery_status` (enum: `pending`, `forwarded`, `retrying`, `failed`).
- `last_delivery_attempt_at` (datetime, nullable).
- `delivery_attempts` (int, default 0).
- `error_message` (string, nullable, 512 chars) — last failure reason.
- `destination_ids` (array<string>) — references attempted destinations.

**Indexes**
- Composite `(source_identifier, received_at)` for recent lookups.
- Index on `delivery_status` for retry worker queries.

### destinations
- `id` — primary key.
- `name` (string, unique).
- `destination_type` (enum: `discord_webhook`, `generic_json`).
- `endpoint_url` (text, encrypted via PocketBase secret storage).
- `enabled` (bool).
- `formatter_template` (JSON) — message structure.
- `metadata` (JSON) — optional headers or overrides.

**Indexes**
- Unique `name`.
- Index `destination_type` for filtering.

### source_configs
- `id` — primary key.
- `source_identifier` (string, unique) — used in webhook path.
- `description` (string).
- `field_mappings` (JSON array) — `{path, alias, required}` definitions.
- `destination_order` (array<string>) — ordered destination IDs.
- `replay_enabled` (bool).
- `throttle_per_minute` (int, nullable).

### delivery_logs
- `id` — primary key.
- `event_id` (relation -> webhook_events.id).
- `destination_id` (relation -> destinations.id).
- `attempt_number` (int).
- `attempted_at` (datetime).
- `status` (enum: `success`, `failed`, `skipped`).
- `response_status_code` (int, nullable).
- `response_body` (JSON, nullable, truncate to 2 KB).
- `error_message` (string, nullable).

**Indexes**
- Composite `(event_id, destination_id, attempt_number)`.

## Relationships & Constraints
- `destination_order` must reference enabled destinations; enforced in service validation.
- Soft-delete destinations by toggling `enabled`; migrations enforce rule via PocketBase list rules.
- Replay resets `delivery_status` to `pending` and increments `delivery_attempts`.

## Migration Responsibilities (Go)
- `001_init_collections.go`: create collections, indexes, and base rules.
- `002_seed_destinations.go` (optional): insert sample destination records for quickstart.
- Migrations run automatically on PocketBase startup (`pb.App.Migrations().Register(...)`).
- Provide CLI command `go run go/pocketbase/main.go migrate up/down` for manual control; document in runbook.

## Configuration Artifacts
- `config/sources.yaml` bootstraps source mappings; sync job ensures consistency with PocketBase records.
- Environment variables: `POCKETBASE_URL`, `POCKETBASE_ADMIN_TOKEN`, destination webhook URLs, `APP_SECRET_KEY` for correlation IDs.

## Outstanding Decisions
- Confirm retention window (30-day default currently assumed).
- Define max retry attempts/backoff strategy parameters.
- Determine whether replay endpoint is exposed via API or CLI-only (default CLI).
