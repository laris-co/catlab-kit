from __future__ import annotations

from typing import Any, Dict


def _get_dotted(source: Dict[str, Any], path: str) -> Any:
    cur: Any = source
    for part in path.split("."):
        if isinstance(cur, dict) and part in cur:
            cur = cur[part]
        else:
            return ""  # default empty for missing
    return cur


def extract_fields(payload: Dict[str, Any], rules: Dict[str, str]) -> Dict[str, Any]:
    return {
        alias: _get_dotted(payload, dotted) for alias, dotted in (rules or {}).items()
    }
