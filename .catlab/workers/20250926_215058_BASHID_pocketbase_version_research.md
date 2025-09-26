# PocketBase Version Research (as of 2025-09-26)

## Snapshot
| Component | Latest Version | Release Date | Key Highlights |
| --- | --- | --- | --- |
| Core server (GitHub release) | v0.30.0 | 2025-09-07 | Adds Lark OAuth2 provider, new JSVM `os.Root` helpers, eager S3 path escaping, and raises the minimum Go toolchain to 1.24.0. [1] |
| Go module (`github.com/pocketbase/pocketbase`) | v0.30.0 | 2025-09-07 (published on pkg.go.dev) | Module mirror of the release; pkg.go.dev lists v0.30.0 with Sep 7 publication and highlights MIT licensing. [2] |
| JavaScript SDK (`npm install pocketbase`) | v0.26.2 | 2025-07-23 | Allows body submissions from plain objects without constructors, continuing 0.26.x transport and error handling polish. [3] |
| Python SDK (`pip install pocketbase`) | v0.15.0 | 2025-02-18 | Improves `ClientResponseError` logging and renames the `schema` attribute to `fields` for clearer APIs. [4][5] |
| Python binary distribution (`pip install pocketbase-bin`) | 0.30.0 | 2025-09-07 | Distributes the PocketBase v0.30.0 executable via PyPI with directories created in the working tree and the self-update command disabled by default. [6] |

## Core Server Release (GitHub)
- **Version:** v0.30.0 (tag `a095549`), released 2025-09-07 by `github-actions`. [1]
- **Highlights:**
  - Escapes S3 request paths using the same rules as the signing header to avoid signature mismatches. [1]
  - Adds Lark OAuth2 provider support and `os.Root` bindings (`$os.openRoot`, `$os.openInRoot`) in JSVM for safer filesystem access. [1]
  - Introduces `osutils.IsProbablyGoRun()` and UI refinements (collection index overview, datepicker seconds, helper texts). [1]
  - Raises the minimum supported Go version to 1.24.0 alongside dependency bumps. [1]

## Go Module Registry
- **Module:** `github.com/pocketbase/pocketbase`
- **Latest tag:** v0.30.0, published 2025-09-07 on pkg.go.dev. [2]
- pkg.go.dev reflects the tagged release with MIT licensing and import metrics, confirming `go get github.com/pocketbase/pocketbase@v0.30.0` resolves successfully. [2]

## JavaScript SDK (npm)
- **Package:** `pocketbase`
- **Latest version:** 0.26.2 (released 2025-07-23). [3]
- **Recent changes:** Allows body objects without constructors during submission, continuing the 0.26.x streamlining of error serialization. [3]

## Python SDK (PyPI)
- **Package:** `pocketbase`
- **Latest version:** 0.15.0 (uploaded 2025-02-18). [4][5]
- **Highlights:**
  - Improves `ClientResponseError` logging for easier debugging. [4]
  - Renames the `schema` attribute to `fields`, aligning terminology with the PocketBase API. [4]

## Python Binary Distribution (`pocketbase-bin`)
- **Package:** `pocketbase-bin`
- **Latest version:** 0.30.0 (uploaded 2025-09-07). [6]
- **Highlights:** Mirrors the PocketBase v0.30.0 executable while creating `pb_data`/`pb_migrations` in the current working directory and disabling the built-in `pocketbase update` command, as noted in package metadata. [6]

## Recent Announcements & Docs Updates
- Official download documentation now points to v0.30.0 binaries across Linux, Windows, and macOS (x64/ARM64). [7]

## Notes for Follow-up Research
- Monitor for v0.30.x hotfixes (GitHub releases + npm registry).
- Watch for downstream SDK updates (Dart, community Python async client) to align with core v0.30.0.
- Keep an eye on official blog/docs for roadmap news toward the eventual v1 milestone.

## Sources
1. GitHub — PocketBase v0.30.0 release notes (2025-09-07). [1]
2. pkg.go.dev — `github.com/pocketbase/pocketbase` module page showing v0.30.0 (published 2025-09-07). [2]
3. GitHub — pocketbase/js-sdk v0.26.2 release (2025-07-23). [3]
4. GitHub — vaphes/pocketbase v0.15.0 release notes (2025-02-18). [4]
5. PyPI — `pocketbase` project page listing version 0.15.0 (uploaded 2025-02-18). [5]
6. PyPI — `pocketbase-bin` project page listing version 0.30.0 (uploaded 2025-09-07). [6]
7. PocketBase documentation downloads page referencing v0.30.0 binaries. [7]

[1]: https://github.com/pocketbase/pocketbase/releases/tag/v0.30.0
[2]: https://pkg.go.dev/github.com/pocketbase/pocketbase
[3]: https://github.com/pocketbase/js-sdk/releases/tag/v0.26.2
[4]: https://github.com/vaphes/pocketbase/releases/tag/v0.15.0
[5]: https://pypi.org/project/pocketbase/
[6]: https://pypi.org/project/pocketbase-bin/
[7]: https://pocketbase.io/docs/
