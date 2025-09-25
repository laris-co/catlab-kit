# Quickstart — Webhook Proxy Service Foundation

Spec: /home/floodboy/catlab-kit/specs/001-build-a-simple/spec.md  
Plan: /home/floodboy/catlab-kit/specs/001-build-a-simple/plan.md

## Prerequisites
- Docker + Docker Compose
- Python 3.12 with `uv` installed

## Run PocketBase (SQLite) via Compose
```bash
# (compose file will mount PocketBase data volume)
docker compose up -d pocketbase
```

## Set configuration
Create `/home/floodboy/catlab-kit/config/webhook-proxy.yaml`:
```yaml
sources:
  alerts:
    destinations:
      - id: ops-discord
        type: discord_webhook
        url: ${DISCORD_WEBHOOK_URL}
    fields:
      summary: alert.title
      severity: alert.severity
    template: "[{source}] {summary} (sev={severity})"
```
Export secrets (example):
```bash
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

## Install dev tools
```bash
uv venv
uv pip install -e .[dev]
```

## Run tests (expected to fail initially)
```bash
cd /home/floodboy/catlab-kit
pytest -q
```

## Next steps
- Implement FastAPI app in `src/` to satisfy contract in `/home/floodboy/catlab-kit/specs/001-build-a-simple/contracts/openapi.yaml`.
- Provide `purge-events` admin command and runbook per FR-020.
