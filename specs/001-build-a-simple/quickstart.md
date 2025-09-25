# Quickstart — Webhook Proxy Service Foundation

This guide shows how to run the webhook proxy locally using FastAPI + PocketBase (framework mode), execute Go migrations, and validate quality gates.

## Prerequisites
- Python 3.12+
- `uv` CLI (https://github.com/astral-sh/uv#installation)
- Go 1.22+
- Docker Engine with Docker Compose v2
- `curl` or `httpie`

## 1. Clone & Bootstrap
```bash
git clone git@github.com:laris-co/catlab-kit.git
cd catlab-kit
git checkout 001-build-a-simple

# Sync Python dependencies
uv sync

# Install Go dependencies
cd go/pocketbase
go mod tidy
cd -
```

## 2. Configure Environment
```bash
cp .env.example .env
# Update values:
#   POCKETBASE_URL=http://localhost:8090
#   POCKETBASE_ADMIN_TOKEN=<pb_admin_token>
#   DISCORD_WEBHOOK_URL_OPERATIONS=<discord_url>
#   APP_SECRET_KEY=<random-string>
```

Optional: Update `config/sources.yaml` with source identifiers, field mappings, and destination ordering.

## 3. Build PocketBase Framework App & Migrations
```bash
cd go/pocketbase
# Generate new migration (example)
go run github.com/pocketbase/pocketbase/cmd/pocketbase migrate create add_new_collection
# Run all migrations
GO_ENV=development go run main.go migrate up
cd -
```

## 4. Launch Services
```bash
docker compose up --build
# Services:
# - FastAPI API: http://localhost:8000
# - PocketBase admin UI: http://localhost:8090/_/
```

Wait for logs indicating `Application startup complete` (FastAPI) and `PocketBase server started`.

## 5. Seed Destinations & Sources
Use the CLI (`uv run python -m app.cli seed`) or PocketBase UI:
1. Create destinations (`destinations` collection) with Discord webhook URLs.
2. Create source config (`source_configs`) defining field mappings and destination order.

## 6. Send Sample Webhook
```bash
curl -X POST \
  http://localhost:8000/webhooks/github-deploy \
  -H 'Content-Type: application/json' \
  -d '{"action": "deployed", "repo": "example", "actor": "alice"}'
```

Expected outcome:
- Response `202 Accepted` with correlation ID.
- PocketBase `webhook_events` record contains raw payload and extracted fields.
- Discord channel receives formatted message.

## 7. Run Automated Quality Gates
```bash
# Lint & format
uv run ruff check src tests
uv run black --check src tests

# Type checking
uv run mypy --strict src

# Unit & integration tests with reports
uv run pytest \
  --junitxml=test-reports/junit.xml \
  --cov=src --cov-report=xml:coverage/coverage.xml \
  --cov-report=html:coverage/html

# Go tests for migrations
cd go/pocketbase
go test ./...
cd -
```

Artifacts generated:
- `test-reports/junit.xml`
- `coverage/coverage.xml`
- `coverage/html/index.html`

## 8. Replay & Admin Runbooks
- Replay event: `uv run python -m app.cli replay --event-id <id>`
- Migration runbook: `docs/runbooks/migrations.md` describes manual/CI execution

## 9. Shut Down
```bash
docker compose down
```

> Commit and push after each meaningful change. Do not use `--force` or other destructive commands.
