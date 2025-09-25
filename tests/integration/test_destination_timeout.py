from fastapi.testclient import TestClient


def test_destination_timeout_marks_failed(monkeypatch):
    from src.app import create_app
    from src.services import delivery as dlv
    from src.services import pb_client

    def fake_deliver(dest: dict, message: str) -> bool:
        return False  # simulate timeout/failure

    monkeypatch.setattr(dlv, "deliver", fake_deliver)
    monkeypatch.setattr(pb_client, "store_event", lambda *a, **k: "01HFAKEEVENTID")

    app = create_app()
    client = TestClient(app)
    r = client.post("/webhook/alerts", json={"alert": {"title": "T", "severity": "low"}})
    assert r.status_code in (201, 200)
    assert r.json().get("notification_status") == "failed"
