from __future__ import annotations

from fastapi import FastAPI

from src.api.health import router as health_router
from src.api.webhook import router as webhook_router


def create_app() -> FastAPI:
    app = FastAPI(title="Webhook Proxy Service")
    app.include_router(health_router)
    app.include_router(webhook_router)
    return app

