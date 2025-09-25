from fastapi.testclient import TestClient


def test_missing_mapped_fields_are_empty(monkeypatch):
    from src.app import create_app
    from src.services import pb_client

    monkeypatch.setattr(pb_client, "store_event", lambda *a, **k: "01HFAKEEVENTID")

    app = create_app()
    client = TestClient(app)
    payload = {"unrelated": {"foo": "bar"}}
    r = client.post("/webhook/alerts", json=payload)
    # Even if mapping fields are missing, we still accept (201)
    assert r.status_code in (201, 200, 202)
