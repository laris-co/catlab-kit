# catlab-kit Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-09-25

## Active Technologies
- Python 3.12+ (per constitution) + FastAPI, uv tooling for dependency/runtime management, PocketBase REST API, docker-compose runtime (001-build-a-simple)
- Python 3.12+ for FastAPI service; Go 1.22+ for PocketBase embedding/migrations + FastAPI, uv (dependency management), PocketBase framework SDK, pocketbase Go migration scaffolding, httpx, structlog, Prometheus instrumentation (001-build-a-simple)
- PocketBase (SQLite) embedded via Go module, running in dedicated container with mounted volume (001-build-a-simple)
- Python 3.12+ (service), Go 1.22+ (PocketBase migrations) + FastAPI, httpx, structlog, prometheus-client; PocketBase (SQLite) framework SDK; uv; docker-compose (001-build-a-simple)
- PocketBase (SQLite) for persisted events and delivery logs; configuration via file/env (YAML or env vars) (001-build-a-simple)

## Project Structure
```
src/
tests/
```

## Commands
cd src [ONLY COMMANDS FOR ACTIVE TECHNOLOGIES][ONLY COMMANDS FOR ACTIVE TECHNOLOGIES] pytest [ONLY COMMANDS FOR ACTIVE TECHNOLOGIES][ONLY COMMANDS FOR ACTIVE TECHNOLOGIES] ruff check .

## Code Style
Python 3.12+ (per constitution): Follow standard conventions

## Recent Changes
- 001-build-a-simple: Added Python 3.12+ (service), Go 1.22+ (PocketBase migrations) + FastAPI, httpx, structlog, prometheus-client; PocketBase (SQLite) framework SDK; uv; docker-compose
- 001-build-a-simple: Added Python 3.12+ for FastAPI service; Go 1.22+ for PocketBase embedding/migrations + FastAPI, uv (dependency management), PocketBase framework SDK, pocketbase Go migration scaffolding, httpx, structlog, Prometheus instrumentation
- 001-build-a-simple: Added Python 3.12+ (per constitution) + FastAPI, uv tooling for dependency/runtime management, PocketBase REST API, docker-compose runtime

<!-- MANUAL ADDITIONS START -->
Notes
- After each task: commit and push to remote; never use force flags.
<!-- MANUAL ADDITIONS END -->
