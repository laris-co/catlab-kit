from pathlib import Path
from src.services.config_loader import ConfigLoader


def test_config_loader_reads_yaml(tmp_path: Path):
    p = tmp_path / "cfg.yaml"
    p.write_text(
        """
sources:
  demo:
    fields:
      name: foo.name
    destinations: []
    template: "{name}"
""",
        encoding="utf-8",
    )
    loader = ConfigLoader(p)
    assert loader.get_source("demo") is not None
