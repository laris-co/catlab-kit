## Research Report: nazt gist 3f9188eb0a5114fffa5d8cb4f14fe5a4 short codes and workflow patterns

### Executive Summary
The NAzT-maintained CLAUDE.md gist (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw) consolidates safety guardrails and automation shortcuts that orchestrate AI-assisted development flows. It centers on the `ccc → nnn → gogogo` pattern to preserve context, plan work, and execute incrementally, while reinforcing mandatory retrospectives (`rrr`) and strict non-destructive Git/GitHub practices captured as of August 26, 2025.

### Key Findings
- The two-issue workflow splits persistent context (`ccc`) from actionable planning (`nnn`) so execution (`gogogo`) always pulls from validated plans; this keeps histories clean and prevents work without recorded rationale (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw).
- Safety rules prohibit force pushes, merges, or deletions and require approvals before repository-altering actions, ensuring reversible operations when following the short codes (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw).
- Short codes extend beyond planning: `lll` snapshots project status, `rrr` enforces retrospectives with mandatory AI Diary and Honest Feedback, `ttt` runs full tests, and `sss` provisions tmux-based environments for repeatable setup (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw).
- Lessons learned dated 2025-08-26 highlight a trend toward phased, one-hour execution chunks and emphasize the `ccc → nnn` cadence as a proven productivity pattern (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw).
- External commentary on CLAUDE.md workflows underscores industry adoption of the short-code approach for maintaining context-rich AI development sessions (https://stevekinney.com/courses/ai-development/claude-dot-md). citeturn3search0

### Technical Specifications
- Baseline tooling checks (`node --version`, `python --version`, `git --version`, `gh --version`, `tmux --version`) are embedded in the Quick Start to validate the environment before invoking automation short codes (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw).
- GitHub CLI remains the integration point for issue/PR automation; the official manual confirms ongoing support for GitHub.com and Enterprise Server 2.20+ as of September 26, 2025 (https://docs.github.com/en/github-cli/github-cli/github-cli-reference). citeturn5search2
- The workflow standardizes on GMT+7 as the primary timezone for retrospectives and scheduling, with UTC provided secondarily for technical artifacts (https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw).

### References & Sources
- https://gist.githubusercontent.com/nazt/3f9188eb0a5114fffa5d8cb4f14fe5a4/raw
- https://stevekinney.com/courses/ai-development/claude-dot-md
- https://cli.github.com/manual/gh
- https://docs.github.com/en/github-cli/github-cli/github-cli-reference

### Conclusion
The NAzT CLAUDE.md blueprint operationalizes a closed-loop workflow where context capture (`ccc`), deep planning (`nnn`), disciplined execution (`gogogo`), and reflective retrospectives (`rrr`) are codified through lightweight short codes. Adhering to the prescribed toolchain checks, GitHub CLI-driven issue automation, and timezone conventions keeps sessions consistent and auditable, enabling repeatable delivery while honoring strict safety constraints.
