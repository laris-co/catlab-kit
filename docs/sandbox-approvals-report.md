# Codex Sandbox & Approvals – Developer Report

This report distills the key guidance from the upstream Codex sandbox documentation and highlights developer-facing considerations when working inside the catlab-kit repository.

## Approval modes at a glance

Codex supports three primary approval policies that govern autonomy:

| Mode | Typical Command Line | Capabilities | When to Use |
| --- | --- | --- | --- |
| **Read Only** | `codex --sandbox read-only --ask-for-approval on-request` | Can inspect files and answer questions. Editing files, running commands, or using the network always requires explicit approval. | Planning sessions, auditing repositories, or working in unversioned directories where mutations must be deliberate. |
| **Auto (Workspace Write)** | `codex --sandbox workspace-write --ask-for-approval on-request` or `codex --full-auto` | Enables file edits and command execution inside the workspace while still prompting for actions that escape the sandbox (e.g., touching files outside the repo, enabling network access). | Default for version-controlled projects; balances speed with guardrails. |
| **Full Access / YOLO** | `codex --dangerously-bypass-approvals-and-sandbox` | Removes sandboxing and approval prompts entirely. | Only for tightly controlled environments (e.g., disposable containers) where you accept full automation risk. |

### Behavior defaults

- The sandbox always covers the current workspace (repo + `/tmp`).
- Network access is **disabled** in `workspace-write` mode unless explicitly enabled in `config.toml` via `[sandbox_workspace_write].network_access = true`.
- Use `/status` to confirm which directories Codex can touch under the current sandbox profile.

## Choosing the right combination

Several preset flag combinations map to common workflows:

1. **Safe read-only browsing** – `--sandbox read-only --ask-for-approval on-request`
   - Codex only reads; escalations are manual.
   - Ideal for compliance reviews or documentation sprints.
2. **Non-interactive read-only (CI usage)** – `--sandbox read-only --ask-for-approval never`
   - Eliminates prompts while still preventing writes or command execution.
   - Appropriate for scripted linting or documentation generation.
3. **Workspace write with guardrails** – `--sandbox workspace-write --ask-for-approval on-request`
   - Allows day-to-day development in a VCS-managed repo.
   - Prompts if Codex needs to leave the workspace or access the network.
4. **Preset auto mode** – `--full-auto` (alias for workspace-write + on-failure approvals)
   - Same baseline as #3 but only interrupts after a failure that suggests escalation might help.
5. **Unsafe bypass / YOLO** – `--dangerously-bypass-approvals-and-sandbox`
   - Grants unrestricted access. Avoid unless you control the environment and have separate safeguards.

## Configuration via `config.toml`

Developers can persist sandbox and approval policies:

```toml
# Read-only, manual approvals (safe default for new directories)
approval_policy = "untrusted"
sandbox_mode    = "read-only"

# Full-auto workspace write (recommended for version-controlled repos)
approval_policy = "on-request"
sandbox_mode    = "workspace-write"

# Optional network unlock while staying in workspace-write
[sandbox_workspace_write]
network_access = true
```

For repeatable setups, define profiles:

```toml
[profiles.full_auto]
approval_policy = "on-request"
sandbox_mode    = "workspace-write"

[profiles.readonly_quiet]
approval_policy = "never"
sandbox_mode    = "read-only"
```

### Implementation notes

- macOS (12+) uses the Apple Seatbelt sandbox via `sandbox-exec`.
- Linux relies on Landlock + seccomp. In containerized Linux environments, ensure the host kernel exposes these APIs; otherwise sandbox enforcement may be degraded.
- When sandboxing is unavailable, run Codex inside a container that enforces your desired restrictions and then start Codex with the `--dangerously-bypass-approvals-and-sandbox` flag to avoid redundant, ineffective layers.

## Experimenting safely

Use the CLI helpers to understand sandbox impact before granting additional autonomy:

```bash
# macOS
codex debug seatbelt [--full-auto] [COMMAND]...

# Linux
codex debug landlock [--full-auto] [COMMAND]...
```

These commands execute the supplied command under the current sandbox profile, making it easy to observe what the sandbox blocks or allows.

## Recommendations for catlab-kit developers

1. **Default to workspace-write with on-request approvals** when collaborating in this repository. It keeps routine edits smooth while still enforcing boundaries.
2. **Enable network access only when necessary.** If you need remote artifacts, toggle `[sandbox_workspace_write].network_access = true` temporarily or approve individual network commands.
3. **Switch to read-only mode** (`/approvals` → `Read Only`) during design reviews or when auditing untrusted contributions to prevent unintended edits.
4. **Leverage profiles** for quick context switching. For example, add a `profiles.audit` entry that enforces read-only + manual approvals for reviewing external patches.
5. **Test suspicious commands** with `codex debug seatbelt/landlock` first, especially scripts that interact with the filesystem broadly.
6. **Maintain container kernels** with up-to-date Landlock/seccomp support if developing on Linux containers so that the sandbox remains effective.

Following these practices preserves the security guarantees described in the upstream sandbox documentation while sustaining a productive workflow inside catlab-kit.
