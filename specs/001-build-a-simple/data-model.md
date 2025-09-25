# Data Model — Webhook Proxy Service Foundation

Spec: /home/floodboy/catlab-kit/specs/001-build-a-simple/spec.md  
Branch: 001-build-a-simple | Date: 2025-09-25

## Entities

### WebhookEvent (persisted)
- id: ULID (string) — primary key
- source: string — required, indexed
- received_at: datetime (UTC) — required, default now
- raw_payload: JSON (stored as TEXT) — required
- extracted_fields: JSON (TEXT) — required (may be `{}`)
- delivery_status: enum('sent','failed') — required
- size_bytes: integer — required, must be ≤ 1_048_576

Constraints
- Index: (source, received_at desc)
- Check: size_bytes ≤ 1 MiB
- Note: No deduplication; each delivery creates a new record

### DeliveryLog (persisted)
- id: ULID (string) — primary key
- event_id: ULID (string) — required, FK → WebhookEvent.id (cascade delete)
- destination_id: string — required (from config key)
- destination_url_snapshot: string — required (audit)
- attempted_at: datetime (UTC) — required, default now
- success: boolean — required
- error_message: string (TEXT) — optional
- attempt: integer — required, default 1 (no auto-retries in this feature)

Indexes
- Index: (event_id, attempted_at desc)

### DestinationMapping (configuration, not persisted)
- source: string — unique key
- destinations: array<DestinationRef> — one or more
- fields: map<string alias, string dotted_path> — field extraction rules
- template: string — notification template using `{alias}` placeholders

Types
- DestinationRef
  - id: string — unique key used in logs
  - type: enum('discord_webhook','generic_webhook')
  - url: string (secret managed via env or mounted file)

## Relationships
- WebhookEvent 1 — N DeliveryLog (by event_id)
- DestinationMapping is resolved at runtime from configuration (not stored in DB)

## State Transitions
- On store success → attempt notification(s)
  - If all succeed: WebhookEvent.delivery_status = 'sent'
  - If any fail: WebhookEvent.delivery_status = 'failed' (details in DeliveryLog)

## Validation Rules
- Reject inbound request if raw payload > 1 MiB (HTTP 413)
- Missing mapped fields resolve to empty values in `extracted_fields`

