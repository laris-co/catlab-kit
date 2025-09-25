from __future__ import annotations

import argparse


def purge_events() -> int:
    # Placeholder: implement via PocketBase REST in a later task.
    print("purge-events: dry-run (not implemented)")
    return 0


def main() -> None:
    parser = argparse.ArgumentParser(prog="admin")
    sub = parser.add_subparsers(dest="cmd", required=True)
    sub.add_parser("purge-events")
    args = parser.parse_args()
    if args.cmd == "purge-events":
        raise SystemExit(purge_events())


if __name__ == "__main__":  # pragma: no cover
    main()
