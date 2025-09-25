# Quickstart — Webhook Proxy Service Foundation

This guide demonstrates how to launch the webhook proxy locally, send a sample webhook, verify storage/forwarding, and run the quality gates mandated by the constitution.

## Prerequisites
- Python 3.12 installed locally (used primarily for tooling/tests).
- `uv` CLI installed (https://github.com/astral-sh/uv#installation).
- Docker Desktop or Docker Engine + Docker Compose v2.
- `curl` or `httpie` for test requests.

## 1. Clone & Bootstrap
```bash
# Clone repository
uv tool run git clone git@github.com:laris-co/catlab-kit.git
cd catlab-kit

# Ensure feature branch
git checkout 001-build-a-simple

# Sync dependencies
uv sync  # installs FastAPI, pytest, ruff, mypy, etc.
```

## 2. Configure Environment
```bash
cp .env.example .env
# Edit .env to set:
#   POCKETBASE_URL=http://localhost:8090
#   POCKETBASE_ADMIN_TOKEN=<pb_admin_token>
#   DISCORD_WEBHOOK_URL_OPERATIONS=<discord_url>
#   APP_SECRET_KEY=<random-string>
```

Optional: Update `config/sources.yaml` with source identifiers, field mappings, and destination ordering.

## 3. Launch Services
```bash
# Build API image and start both containers
docker compose up --build

# Services expose:
# - FastAPI: http://localhost:8000
# - PocketBase admin UI: http://localhost:8090/_/
```

Wait until logs show `Application startup complete` and `PocketBase Server started`.

## 4. Seed Destinations & Sources
Use the provided admin CLI (once implemented) or PocketBase UI:
1. Create destinations (`destinations` collection) with Discord webhook URLs.
2. Create source config (`source_configs` collection) defining mappings and destination order.

## 5. Send Sample Webhook
```bash
curl -X POST \
  http://localhost:8000/webhooks/github-deploy \
  -H 'Content-Type: application/json' \
  -d '{"action": "deployed", "repo": "example", "actor": "alice"}'
```

Expected outcome:
- Response `202 Accepted` with correlation ID.
- PocketBase `webhook_events` record contains raw payload and extracted fields.
- Discord channel receives formatted deployment notification.

## 6. Run Automated Quality Gates
```bash
# Lint & format checks
uv run ruff check src tests
uv run black --check src tests

# Type checking
uv run mypy --strict src

# Tests with reports
uv run pytest \
  --junitxml=test-reports/junit.xml \
  --cov=src --cov-report=xml:coverage/coverage.xml \
  --cov-report=html:coverage/html
```

Artifacts:
- `test-reports/junit.xml`
- `coverage/coverage.xml`
- `coverage/html/index.html`

## 7. Replay Runbook (Admin Process)
Follow `docs/runbooks/replay.md`:
```bash
uv run python -m app.cli replay --event-id <id>
```
- Ensures Twelfth-Factor parity by running through same containerized code.
- Logs replay attempt in `delivery_logs` and updates status.

## 8. Shut Down
```bash
docker compose down
```

> Remember to commit and push after each meaningful change. Avoid `--force` operations per constitution.
