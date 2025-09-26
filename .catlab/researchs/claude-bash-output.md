# Claude BashOutput Identifiers

## Background Jobs
- Set `run_in_background: true` on a `Bash` tool call to launch the command asynchronously and receive a response that includes `shellId` for later tracking.
- The initial `Bash` tool output bundles stdout/stderr and returns immediately with `shellId` when the process stays active.

## Retrieving Output
- Use the `bash_id` provided by the background launch when calling the `BashOutput` tool; you can optionally add a `filter` regex to focus on specific lines.
- Each `BashOutput` response streams only the new output since the previous poll and reports the shell `status` (`running`, `completed`, or `failed`) plus the exit code when finished.
- Background shell identifiers surface as incremental strings such as `bash_3`, making it straightforward to monitor multiple jobs in parallel.

## References
- Claude Code TypeScript SDK reference (Bash and BashOutput tool schemas). https://docs.claude.com/en/docs/claude-code/sdk/sdk-typescript (accessed 2025-09-26)
- Claude Code Bash tool overview (run_in_background behavior). https://docs.claude.com/en/docs/agents-and-tools/tool-use/bash-tool (accessed 2025-09-26)
- Example background command workflow illustrating `bash_N` identifiers. https://github.com/ruvnet/claude-flow/wiki/background-commands (accessed 2025-09-26)
