from __future__ import annotations

import os
import time
from pathlib import Path
from typing import Any, Dict, Optional

import yaml


DEFAULT_CONFIG_PATH = Path(os.environ.get("WEBHOOK_PROXY_CONFIG", "config/webhook-proxy.yaml"))


class ConfigLoader:
    def __init__(self, path: Path | str):
        self.path = Path(path)
        self._mtime: Optional[float] = None
        self._config: Dict[str, Any] = {"sources": {}}
        self.reload()

    def reload(self) -> None:
        if not self.path.exists():
            self._config = {"sources": {}}
            self._mtime = None
            return
        text = self.path.read_text(encoding="utf-8")
        self._config = yaml.safe_load(text) or {"sources": {}}
        self._mtime = self.path.stat().st_mtime

    def maybe_reload(self) -> None:
        if not self.path.exists():
            return
        mtime = self.path.stat().st_mtime
        if self._mtime is None or mtime > self._mtime:
            self.reload()

    @property
    def config(self) -> Dict[str, Any]:
        return self._config

    def get_source(self, name: str) -> Optional[Dict[str, Any]]:
        return (self._config or {}).get("sources", {}).get(name)


loader = ConfigLoader(DEFAULT_CONFIG_PATH)

