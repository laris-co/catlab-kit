# Runbook: purge-events

This runbook describes the administrative process to purge stored webhook events.

- Command: `python -m src.cli.admin purge-events`
- Environment: Same configuration as the service (env vars, mounted config)
- Preconditions: Operator confirms maintenance window (if applicable)

Steps
1. Dry run: confirm selection criteria and projected deletions.
2. Execute purge against PocketBase collections `webhook_events` and associated `delivery_logs`.
3. Verify metrics and remaining records.
4. Rollback: restore from last backup if an unintended purge occurred.

Notes
- Idempotent and safe to re-run.
- No force flags; changes are auditable.

