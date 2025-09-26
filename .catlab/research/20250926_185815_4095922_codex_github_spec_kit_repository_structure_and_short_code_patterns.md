## Research Report: GitHub spec-kit repository structure and short code patterns

### Executive Summary
GitHub Spec Kit, announced on September 15, 2025, packages the Specify CLI with curated agent-specific prompt bundles so AI coding assistants across tools such as GitHub Copilot, Claude Code, Gemini CLI, Cursor, Qwen Code, Roo Code, Kilo Code, Auggie CLI, Codex, opencode, and Windsurf can follow Spec-Driven Development with shared governance artifacts. (https://developer.microsoft.com/blog/spec-driven-development-spec-kit, https://github.com/github/spec-kit/blob/main/README.md)
Visual Studio Magazine’s September 16, 2025 coverage highlights the experiment’s rapid uptake and GitHub’s request for measured contributions while the tooling remains in preview. (https://visualstudiomagazine.com/articles/2025/09/16/github-spec-kit-experiment-a-lot-of-questions.aspx)

### Key Findings
- The Specify CLI scaffolds `.github/prompts` alongside `.specify/memory`, `.specify/scripts`, and `.specify/templates`, ensuring each agent starts with curated constitutions, scripts, and templates after `specify init`. (https://developer.microsoft.com/blog/spec-driven-development-spec-kit)
- Spec Kit prescribes a sequential slash-command loop—`/constitution`, `/specify`, `/clarify`, `/plan`, `/tasks`, `/analyze`, and `/implement`—encoding repeatable short code patterns for AI-assisted delivery. (https://developer.microsoft.com/blog/spec-driven-development-spec-kit, https://github.com/github/spec-kit/blob/main/README.md)
- GitHub’s release channel published template bundle v0.0.54 on September 25, 2025, underscoring rapid iteration of agent-specific prompt packs for each assistant. (https://github.com/github/spec-kit/releases/tag/v0.0.54)
- Issue #417, opened September 20, 2025, shows Codex CLI ignores project-local prompts unless they live in `~/.codex/prompts`, underscoring integration gaps teams must mitigate. (https://github.com/github/spec-kit/issues/417)
- Visual Studio Magazine’s September 16, 2025 article documents developer interest and reiterates GitHub’s request for measured experimentation rather than sweeping pull requests. (https://visualstudiomagazine.com/articles/2025/09/16/github-spec-kit-experiment-a-lot-of-questions.aspx)

### Technical Specifications
- Supported environments require Linux, macOS, or WSL2, Python 3.11+, uv, Git, and compatible AI agents including Claude Code, GitHub Copilot, Gemini CLI, Cursor, Qwen Code, opencode, Codex CLI, Windsurf, Kilo Code, Roo Code, and Auggie CLI. (https://github.com/github/spec-kit/blob/main/README.md)
- Persistent installation uses `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`, while one-off runs use `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>`, with CLI switches for agent selection, scripts, diagnostics, Git initialization, and token management. (https://github.com/github/spec-kit/blob/main/README.md)
- Project initialization produces `.github/prompts`, `.specify/memory`, `.specify/scripts`, `.specify/templates`, and agent-specific assets that enforce governance and automation steps across assistants. (https://developer.microsoft.com/blog/spec-driven-development-spec-kit)
- Slash-command workflows `/constitution`, `/specify`, `/clarify`, `/plan`, `/tasks`, `/analyze`, and `/implement` embed short operational patterns that advance work from specification through implementation under the Spec Kit constitution. (https://developer.microsoft.com/blog/spec-driven-development-spec-kit, https://github.com/github/spec-kit/blob/main/README.md)
- Template artifacts ship as versioned ZIP bundles per agent from the releases page, enabling offline bootstrapping or manual template refreshes. (https://github.com/github/spec-kit/releases)
- Specify CLI is shipped as version 0.0.17, requires Python ≥3.11, and depends on Typer, Rich, HTTPX[socks], Platformdirs, Readchar, Truststore ≥0.10.4, with Hatchling as the build backend. (https://github.com/github/spec-kit/blob/main/pyproject.toml)

### References & Sources
- https://github.com/github/spec-kit
- https://github.com/github/spec-kit/blob/main/README.md
- https://developer.microsoft.com/blog/spec-driven-development-spec-kit
- https://visualstudiomagazine.com/articles/2025/09/16/github-spec-kit-experiment-a-lot-of-questions.aspx
- https://github.com/github/spec-kit/releases
- https://github.com/github/spec-kit/releases/tag/v0.0.54
- https://github.com/github/spec-kit/issues/417
- https://github.com/github/spec-kit/blob/main/pyproject.toml

### Conclusion
Spec Kit combines a Python-based CLI, agent-specific prompt packs, and prescribed slash-command patterns to standardize Spec-Driven Development while remaining explicitly experimental; teams should monitor fast-moving releases and Codex CLI compatibility gaps while leveraging the curated scaffolding to accelerate onboarding. (https://developer.microsoft.com/blog/spec-driven-development-spec-kit, https://github.com/github/spec-kit/releases/tag/v0.0.54, https://github.com/github/spec-kit/issues/417, https://visualstudiomagazine.com/articles/2025/09/16/github-spec-kit-experiment-a-lot-of-questions.aspx)
