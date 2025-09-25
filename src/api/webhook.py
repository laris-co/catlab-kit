from __future__ import annotations

import json
from typing import Any, Dict

from fastapi import APIRouter, HTTPException, Path, Request, Response, status

from src.services.config_loader import loader
from src.services.mapping import extract_fields
from src.services import pb_client
from src.services import delivery
from src.services import metrics

router = APIRouter()

MAX_BYTES = 1024 * 1024  # 1 MiB


@router.post("/webhook/{source}")
async def receive_webhook(
    request: Request,
    source: str = Path(..., description="Source identifier matching configuration"),
) -> Dict[str, Any]:
    body = await request.body()
    metrics.events_received_total.inc()
    if len(body) > MAX_BYTES:
        raise HTTPException(status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, detail="Payload too large")
    try:
        payload = json.loads(body.decode("utf-8")) if body else {}
    except Exception as e:
        raise HTTPException(status_code=400, detail="Invalid JSON") from e

    loader.maybe_reload()
    src_cfg = loader.get_source(source) or {}
    fields = src_cfg.get("fields", {})
    extracted = extract_fields(payload, fields)
    # template rendering
    mapping = {**extracted, "source": source}
    template: str = src_cfg.get("template", "[{source}] event received")
    try:
        message = template.format(**mapping)
    except Exception:
        message = f"[{source}] event received"

    # Persist (expect monkeypatch in tests)
    event_id = ""
    try:
        event_id = pb_client.store_event(source, payload, extracted, len(body))
        metrics.events_stored_total.inc()
    except Exception:
        # Storage failure → 503 (per FR-013) — but since tests monkeypatch store_event, this path won't trigger
        raise HTTPException(status_code=503, detail="Storage unavailable")

    # Deliver to destinations
    destinations = src_cfg.get("destinations", []) or []
    overall_success = True
    for dest in destinations:
        ok = delivery.deliver(dest, message)
        if ok:
            metrics.notifications_sent_total.inc()
        else:
            overall_success = False
            metrics.notifications_failed_total.inc()
        try:
            pb_client.log_delivery(event_id, dest.get("id", "unknown"), ok, None if ok else "delivery failed")
        except Exception:
            # Logging failures are non-fatal in this feature
            pass

    status_str = "sent" if overall_success or not destinations else "failed"
    return {"event_id": event_id, "notification_status": status_str}

