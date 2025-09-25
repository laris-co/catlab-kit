from src.services.mapping import extract_fields


def test_extract_fields_returns_empty_for_missing():
    payload = {"a": {"b": 1}}
    rules = {"x": "a.c", "y": "a.b"}
    out = extract_fields(payload, rules)
    assert out["x"] == ""
    assert out["y"] == 1

