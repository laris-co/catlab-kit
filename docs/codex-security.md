# Codex Security Implementation Guide (catlab-kit)

## Source
- Document: "Codex security guide"
- Publisher: OpenAI Developers
- URL: https://developers.openai.com/codex/security/
- Accessed: September 25, 2025

## 1. Security Posture Overview
- Codex agents start with network access disabled and write permissions constrained to the active workspace (repository root plus OS temp directories). All other filesystem paths and outbound requests require explicit approval or configuration changes.
- Approvals govern every sandbox escape: workspace-scoped reads/writes and command execution are allowed automatically in trusted, version-controlled projects; leaving the sandbox, touching other directories, or enabling networking forces a user prompt unless you override policy.
- Codex treats the agent as an untrusted collaborator. Human operators remain responsible for reviewing changes, managing secrets, and verifying outputs before they reach production systems.

## 2. Execution Environments
| Environment      | Isolation Mechanism                                     | Default Network | Notes |
|------------------|----------------------------------------------------------|-----------------|-------|
| Codex Cloud      | OpenAI-managed container per task; ephemeral filesystem  | Disabled post-setup | Internet allowed briefly during dependency installation; domain allowlists managed via the Internet Access guide. |
| CLI / IDE (macOS)| Seatbelt sandbox profile plus process-level approval gate | Disabled         | Use `codex debug seatbelt` to inspect enforced rules. |
| CLI / IDE (Linux)| Landlock filesystem sandbox + seccomp syscall filtering  | Disabled         | Validate with `codex debug landlock`; container runtimes must expose Landlock/seccomp. |
| Windows Hosts    | Run inside WSL or hardened container to keep sandbox intact | Disabled         | Native Windows runs are unsupported for sandbox guarantees. |

## 3. Sandbox & Approval Controls
- Inspect active policy with `/status`; adjust approvals in-session via `/approvals`.
- Preset behavior:
  - `Auto` (default for Git repositories): workspace-write with on-request approvals.
  - `Read Only`: used outside version control; Codex cannot modify files without approval.
  - `Manual`: prompts before any command execution.
- CLI overrides:
  - `codex --sandbox workspace-write --ask-for-approval on-request`
  - `codex --sandbox read-only --ask-for-approval on-request`
  - `codex --sandbox manual`
  - `codex --full-auto` (alias for workspace-write with on-failure approvals)
  - `codex --ask-for-approval never` (disables prompts—use only within fortified environments).
- Common sandbox/approval presets:
  - Safe read-only browsing → `codex --sandbox read-only --ask-for-approval on-request`
  - CI-style read-only → `codex --sandbox read-only --ask-for-approval never`
  - Workspace edits with guardrails → `codex --sandbox workspace-write --ask-for-approval on-request`
  - Full-auto preset → `codex --full-auto`
  - YOLO (not recommended) → `codex --dangerously-bypass-approvals-and-sandbox`
- Emergency bypass: `codex --dangerously-bypass-approvals-and-sandbox` (aka `--yolo`); only acceptable in disposable sandboxes or controlled CI.

## 4. Network & Tool Enablement
- Workspace networking toggle (`config.toml`):
  ```toml
  [sandbox_workspace_write]
  network_access = true
  ```
- Command-line shortcut: `codex --network workspace`.
- Note: even in `workspace-write`, network stays disabled until explicitly flipped via config or CLI.
- Web search opt-in:
  ```toml
  [tools]
  web_search = true
  ```
  or launch with `codex --search`.
- Risk management:
  - Treat each network allowlist change as a security exception; record requester, domains, and expiration.
  - Review the Internet Access guide before enabling prompt-informed tools; implement prompt-injection detection and sanitization where feasible.

## 5. Host Hardening & Secrets Hygiene
- Validate sandbox enforcement during onboarding using `codex debug seatbelt` or `codex debug landlock` with representative commands.
- Keep credentials out of the workspace; inject them at runtime (env vars, secret managers) so sandbox relaxations do not expose static secrets.
- For containerized development, ensure the host kernel supports Landlock/seccomp; otherwise, nest Codex inside a pre-secured container or VM with equivalent isolation.

## 6. Operational Playbook
- **Before engaging Codex**
  - Run `git status` and ensure a clean working tree or stash unrelated changes.
  - Confirm sandbox/approval mode with `/status`; tighten if performing exploratory tasks.
  - Plan tasks so each Codex session is scoped to a feature branch.
- **During collaboration**
  - Request patches (`codex patch` or diff-based workflows) instead of blind file writes.
  - Inspect proposed diffs manually; reject anything that touches out-of-scope directories.
  - When approvals prompt for external access, capture rationale and expected rollback.
- **After accepting changes**
  - Execute unit/integration tests or linters related to the modifications.
  - Commit with context summarizing approvals granted, tests run, and follow-up actions.
  - Revoke temporary network/tool enablements and re-run `/status` to confirm baseline.
- **Onboarding/Periodic Review**
  - Audit developer `config.toml` files quarterly.
  - Run sandbox debug utilities and archive logs/screenshots in compliance records.
  - Simulate failure scenarios (e.g., blocked network call) to ensure prompts surface correctly.

## 7. Risk Scenarios & Mitigations
- **Prompt Injection via Web Search**: Restrict index domains, pre-validate retrieved content, and require human review before executing suggestions.
- **Supply-chain Manipulation**: Lock dependency versions; when Codex requests installs, perform manual verification or mirror packages internally.
- **Secrets Leakage**: Never paste tokens into chat; rotate credentials if approvals escalated unexpectedly.
- **Sandbox Escape Attempt**: Deny approvals lacking clear justification; escalate to security if persistent unusual requests occur.
- **Host Misconfiguration**: Incorporate sandbox checks into CI or management scripts; enforce via policy that `--yolo` is prohibited outside temporary sandboxes.

## 8. catlab-kit Action Plan
- **Immediate (This Week)**
  - Adopt `Auto` preset across all developers; document fallback to `Read Only` for reconnaissance tasks.
  - Publish an approval log template (requester, command, scope, expiry) in the team tracker.
- **Near Term (Next Sprint)**
  - Integrate sandbox verification into onboarding checklist and publish how-to run `codex debug` with sample outputs.
  - Draft a network access SOP describing allowed domains, approval process, and rollback steps.
- **Ongoing**
  - Enforce feature branch + code review workflow for all Codex-generated changes.
  - Schedule quarterly audits of local `config.toml` and documented exceptions.
  - Track incidents (unexpected approvals, sandbox errors) and feed lessons learned into policy updates.

## 9. Reference CLI Commands
```
codex --sandbox workspace-write --ask-for-approval on-request
codex --sandbox read-only --ask-for-approval on-request
codex --full-auto
codex --search --sandbox workspace-write
codex debug seatbelt "ls -R /"
codex debug landlock "touch /etc/forbidden"
```

## 10. Appendix: Configuration Snippets
```toml
# ~/.config/codex/config.toml
# approval mode
approval_policy = "on-request"
sandbox_mode    = "workspace-write"

[sandbox_workspace_write]
network_access = false
ask_for_approval = "on-request"

[sandbox_read_only]
network_access = false
ask_for_approval = "never"

[tools]
web_search = false

[profiles.full_auto]
approval_policy = "on-failure"
sandbox_mode    = "workspace-write"

[profiles.readonly_quiet]
approval_policy = "never"
sandbox_mode    = "read-only"
```

```toml
# Example temporary override (document and revert)
[sandbox_workspace_write]
network_access = true
allowlisted_domains = ["api.example.dev", "pypi.org"]
allowlist_expiry = "2025-10-15"
```

---
This guide distills the official Codex security controls and aligns them with catlab-kit's workflows so technical contributors can collaborate safely while maintaining a defensible audit trail.
