from pathlib import Path
import yaml
from fastapi.testclient import TestClient

REPO_ROOT = Path(__file__).resolve().parents[2]
OPENAPI_PATH = REPO_ROOT / "specs" / "001-build-a-simple" / "contracts" / "openapi.yaml"


def test_openapi_contains_healthz():
    spec = yaml.safe_load(OPENAPI_PATH.read_text())
    assert "/healthz" in spec["paths"], "healthz path missing in OpenAPI"


def test_healthz_endpoint_responds():
    from src.app import create_app

    app = create_app()
    client = TestClient(app)
    r = client.get("/healthz")
    assert r.status_code == 200
    assert r.json().get("status") == "ok"
