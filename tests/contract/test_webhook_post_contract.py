from pathlib import Path
import yaml

REPO_ROOT = Path(__file__).resolve().parents[2]
OPENAPI_PATH = REPO_ROOT / "specs" / "001-build-a-simple" / "contracts" / "openapi.yaml"


def test_openapi_contains_webhook_post():
    spec = yaml.safe_load(OPENAPI_PATH.read_text())
    assert "/webhook/{source}" in spec["paths"], "webhook path missing"
    post = spec["paths"]["/webhook/{source}"]
    assert "post" in post, "POST missing for webhook path"
    resp = post["post"]["responses"].get("201")
    assert resp is not None, "201 response missing"

