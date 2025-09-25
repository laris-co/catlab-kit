from fastapi.testclient import TestClient


def test_payload_over_1_mib_returns_413():
    from src.app import create_app

    app = create_app()
    client = TestClient(app)
    big = "x" * (1024 * 1024 + 1)
    r = client.post("/webhook/alerts", data=big, headers={"content-type": "application/json"})
    assert r.status_code == 413

