from fastapi.testclient import TestClient
from pathlib import Path


def test_end_to_end_basic(monkeypatch, tmp_path):
    # Monkeypatch PB client and delivery service
    from src import app as app_module
    from src.services import pb_client as pb
    from src.services import delivery as dlv

    stored = {}

    def fake_store_event(source: str, payload: dict, extracted: dict, size: int) -> str:
        stored["saved"] = {
            "source": source,
            "payload": payload,
            "extracted": extracted,
            "size": size,
        }
        return "01HXXXXXFAKEEVENTID"

    def fake_log_delivery(event_id: str, dest_id: str, success: bool, error: str | None = None) -> None:
        stored.setdefault("logs", []).append({
            "event_id": event_id,
            "dest_id": dest_id,
            "success": success,
            "error": error,
        })

    def fake_deliver(dest: dict, message: str) -> bool:
        stored["delivered"] = {"dest": dest["id"], "message": message}
        return True

    monkeypatch.setattr(pb, "store_event", fake_store_event)
    monkeypatch.setattr(pb, "log_delivery", fake_log_delivery)
    monkeypatch.setattr(dlv, "deliver", fake_deliver)

    # Use default config path; ensure template present
    from src.app import create_app

    app = create_app()
    client = TestClient(app)

    payload = {"alert": {"title": "Disk space low", "severity": "high"}}
    r = client.post("/webhook/alerts", json=payload)
    assert r.status_code == 201
    data = r.json()
    assert data["notification_status"] in ("sent", "failed")
    assert "event_id" in data

