from __future__ import annotations

from typing import Any, Dict
import httpx


TIMEOUT_SECONDS = 5.0


def deliver(dest: Dict[str, Any], message: str) -> bool:
    dest_type = dest.get("type")
    url = dest.get("url")
    if not url:
        return False
    try:
        if dest_type == "discord_webhook":
            body = {"content": message}
        else:
            body = {"message": message}
        r = httpx.post(url, json=body, timeout=TIMEOUT_SECONDS)
        return 200 <= r.status_code < 300
    except Exception:
        return False

