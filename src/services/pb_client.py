from __future__ import annotations

from typing import Any, Dict


def store_event(
    source: str, payload: Dict[str, Any], extracted: Dict[str, Any], size: int
) -> str:
    raise NotImplementedError(
        "PocketBase client not implemented in this feature skeleton."
    )


def log_delivery(
    event_id: str, dest_id: str, success: bool, error: str | None = None
) -> None:
    # No-op placeholder for tests that monkeypatch this function.
    return None
