import importlib
from pathlib import Path
import yaml

REPO_ROOT = Path(__file__).resolve().parents[2]
OPENAPI_PATH = REPO_ROOT / "specs" / "001-build-a-simple" / "contracts" / "openapi.yaml"


def test_openapi_contains_required_paths():
    with OPENAPI_PATH.open("r", encoding="utf-8") as f:
        spec = yaml.safe_load(f)
    paths = spec.get("paths", {})
    assert "/webhook/{source}" in paths, "webhook endpoint missing from OpenAPI"
    assert "post" in paths["/webhook/{source}"], "POST operation missing"


def test_service_entrypoint_exists_and_creates_app():
    # This test is expected to fail until the FastAPI app exists.
    module = importlib.import_module("src.app")
    assert hasattr(module, "create_app"), "create_app() factory not found in src.app"
