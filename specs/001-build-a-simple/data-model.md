# Data Model — Webhook Proxy Service Foundation

## Collections

### webhook_events
- `id` (PocketBase record id, UUID string) — primary key.
- `source_identifier` (string, indexed) — matches configured source key.
- `received_at` (datetime, indexed) — timestamp of inbound event.
- `raw_payload` (JSON) — full payload stored verbatim.
- `payload_fields` (JSON) — extracted key/value pairs per configuration mapping.
- `delivery_status` (enum: `pending`, `forwarded`, `failed`, `retrying`) — current forwarding state.
- `last_delivery_attempt_at` (datetime, nullable) — last attempt timestamp.
- `delivery_attempts` (int) — count of attempts taken.
- `error_message` (string, nullable, 512 chars) — last failure reason.
- `destination_ids` (array<string>) — references to `destinations.id` attempted.

**Indexes**
- Composite index `(source_identifier, received_at)` for querying recent events by source.
- Index on `delivery_status` for retry polling.

### destinations
- `id` (PocketBase record id) — primary key.
- `name` (string, unique) — human-friendly label.
- `destination_type` (enum: `discord_webhook`, `generic_json`).
- `endpoint_url` (string, stored encrypted via PocketBase secrets) — target webhook URL.
- `enabled` (boolean) — whether forwarding is active.
- `formatter_template` (JSON) — configuration for message formatting (fields, template string).
- `metadata` (JSON) — optional destination-specific settings (e.g., headers).

**Indexes**
- Unique index on `name`.
- Index on `destination_type` to support filtering.

### source_configs
- `id` (PocketBase record id) — primary key.
- `source_identifier` (string, unique) — path segment used in webhook URL.
- `description` (string) — short description of the source system.
- `field_mappings` (JSON) — array of mapping rules: `{path, alias, required}`.
- `destination_order` (array<string>) — ordered list of `destinations.id` to send notifications to.
- `replay_enabled` (boolean) — whether replays are allowed for this source.
- `throttle_per_minute` (int, nullable) — optional rate limit per source.

### delivery_logs
- `id` (PocketBase record id) — primary key.
- `event_id` (relation -> webhook_events.id)` — the event that triggered the delivery.
- `destination_id` (relation -> destinations.id)` — destination attempted.
- `attempt_number` (int) — sequential attempt.
- `attempted_at` (datetime) — time of attempt.
- `status` (enum: `success`, `failed`, `skipped`).
- `response_status_code` (int, nullable).
- `response_body` (JSON, optional truncated) — snippet for debugging (<= 2 KB).
- `error_message` (string, nullable).

**Indexes**
- Composite index `(event_id, destination_id, attempt_number)` for dedupe and reporting.

## Relationships & Constraints
- `webhook_events.destination_ids` references `destinations.id` but authoritative join occurs via `delivery_logs` to track each attempt.
- Deleting a destination should soft-disable it (set `enabled = false`) to preserve history; actual record deletion should be prevented via PocketBase rules.
- `source_configs.destination_order` must only reference enabled destinations (enforced in application validation).

## State Transitions
1. `pending` (initial) → `forwarded` when at least one destination succeeds and no retries pending.
2. `pending` → `retrying` after first failure; stays `retrying` until success or retries exhausted.
3. `retrying` → `failed` when attempts exceed policy (default 5).
4. Manual replay resets status to `pending`, increments `delivery_attempts`, and appends to `delivery_logs`.

## Configuration Artifacts
- `config/sources.yaml` (managed file) duplicates subset of PocketBase configuration for bootstrap; migration task ensures config is synchronized.
- Environment variables: `DISCORD_WEBHOOK_URL_*`, `POCKETBASE_URL`, `POCKETBASE_ADMIN_TOKEN`, `APP_SECRET_KEY` for signing correlation IDs.

## Outstanding Decisions
- Final retention window for `webhook_events` (default 30 days assumed).
- Whether to expose public replay endpoint or limit to CLI script (currently favour CLI runbook).
