## Revolutionary Approach: Direct Process Execution
### Overview
Instead of using tmux send-keys to interact with Codex CLI, use direct process execution with `codex exec` for cleaner, faster, and more reliable automation.
### Basic Usage
```bash
# Direct execution with custom settings
codex exec -s danger-full-access -c model_reasoning_effort="low" "Your task here"
# Examples
codex exec -s danger-full-access -c model_reasoning_effort="high" "Refactor the API to use TypeScript interfaces"
codex exec -s danger-full-access -c model_reasoning_effort="low" "List all files in src/"
```
### Helper Script Usage
A helper script `codex-exec.sh` simplifies common operations:
```bash
# Usage: ./codex-exec.sh [reasoning_level] "task"
./codex-exec.sh low "Quick file listing"
./codex-exec.sh high "Complex refactoring task"
./codex-exec.sh "Default task" # defaults to low reasoning
```
### Background Execution with Monitoring
For long-running tasks, use background execution:
```bash
# In Claude, use run_in_background parameter:
# Bash tool with run_in_background: true
# Then monitor with BashOutput tool using the returned bash_id
```
### Parallel Execution
Multiple Codex instances can run simultaneously:
```bash
# Start multiple background tasks
codex exec -s danger-full-access "Task 1" &
codex exec -s danger-full-access "Task 2" &
wait # Wait for all to complete
```
### Key Advantages Over TMux Approach
1. **No timing issues** - No sleep/wait commands needed
2. **Clean output** - Direct JSON/text without UI elements  
3. **Exit codes** - Proper error handling with return codes
4. **Parallel execution** - Run multiple instances simultaneously
5. **Scriptable** - Easy integration with CI/CD pipelines
### Reasoning Levels
- `minimal` - Fastest, limited reasoning (~5-10s for simple tasks)
- `low` - Balanced speed with some reasoning (~10-15s)
- `medium` - Default, solid reasoning (~15-25s)
- `high` - Maximum reasoning depth (~30-60s+)
### Safety Considerations
- Using `danger-full-access` grants full system access
- Auto-approval with `--ask-for-approval never` bypasses confirmations
- Consider permission models for production use
### Common Patterns
```bash
# Add new API endpoint
codex exec -s danger-full-access -c model_reasoning_effort="high" \
  "Add a new REST endpoint /api/users that returns user data"
# Refactor code
codex exec -s danger-full-access -c model_reasoning_effort="high" \
  "Refactor the authentication module to use JWT tokens"
# Generate tests
codex exec -s danger-full-access -c model_reasoning_effort="medium" \
  "Write unit tests for the user service module"
# Quick fixes
codex exec -s danger-full-access -c model_reasoning_effort="low" \
  "Fix the typo in README.md"
```
### Integration with Claude
When Claude needs to use Codex:
1. Use direct `codex exec` commands instead of tmux
2. For long tasks, use `run_in_background: true`
3. Monitor progress with `BashOutput` tool
4. Check exit codes for success/failure
5. Parse clean output without UI filtering
### Discovered Capabilities
- ✅ Non-interactive execution with `codex exec`
- ✅ Parallel task execution
- ✅ Background monitoring
- ✅ Custom reasoning levels
- ✅ Direct file modifications
- ✅ Automatic git patches
- ✅ TypeScript/JavaScript understanding
- ✅ API endpoint creation
- ✅ Code refactoring

### Helper Script
The `codex-exec.sh` helper script is available in the repository root for simplified execution. 
# Claude-Codex Orchestrator/Worker Architecture (2025-09-01)
## Paradigm: Claude as Orchestrator, Codex as Workers
### Division of Responsibilities
#### Claude (Orchestrator - Opus/Sonnet)
**Primary Role**: High-level thinking, planning, and GitHub operations
- 🧠 **Thinking & Analysis**: Strategic planning, decision making, result interpretation
- 📋 **GitHub Operations**: All `gh` CLI operations (issues, PRs, comments, merges)
- 🎛️ **Worker Management**: Spawn, monitor, and coordinate multiple Codex instances
- 📊 **Progress Monitoring**: Track worker status using `BashOutput`
- 🔄 **Result Aggregation**: Combine outputs from multiple workers
- 📝 **Documentation**: Write retrospectives, update AGENTS.md
- 🔍 **Quality Control**: Review worker outputs before GitHub operations
#### Codex (Workers)
**Primary Role**: Execution, implementation, and file operations
- ⚙️ **Code Execution**: Run commands, analyze code, implement features
- 📁 **File Operations**: Read, write, edit, search through codebases
- 🔧 **Implementation**: Make code changes, refactor, fix bugs
- 🚀 **Parallel Processing**: Multiple instances for concurrent tasks
- 📈 **Analysis Tasks**: Deep code analysis, pattern detection
- 🧪 **Testing**: Run tests, validate changes
### Implementation Patterns
#### Single Worker Pattern
```bash
# Claude delegates a single task to Codex
codex exec -s danger-full-access -c model_reasoning_effort="low" "Task description"
```
#### Multiple Worker Pattern
```bash
# Claude spawns multiple Codex workers for parallel execution
# Worker 1: Frontend analysis
codex exec -s danger-full-access "Analyze all React components" &  # Returns bash_1
# Worker 2: Backend analysis  
codex exec -s danger-full-access "Review API endpoints" &  # Returns bash_2
# Worker 3: Test coverage
codex exec -s danger-full-access "Check test coverage" &  # Returns bash_3
# Claude monitors all workers
BashOutput bash_1  # Monitor frontend analysis
BashOutput bash_2  # Monitor backend analysis
BashOutput bash_3  # Monitor test coverage
# Claude aggregates results and creates GitHub issue/PR
```
#### Background Worker Pattern
```bash
# For long-running tasks, use background execution
codex exec -s danger-full-access -c model_reasoning_effort="high" \
  "Complex refactoring task" \
  run_in_background: true  # Returns bash_id
# Claude continues other work while monitoring
BashOutput bash_id  # Check progress periodically
```
### Workflow Examples
#### Example 1: Multi-File Refactoring
```
1. Claude analyzes requirements
2. Claude spawns 3 Codex workers:
   - Worker A: Refactor components
   - Worker B: Update tests
   - Worker C: Update documentation
3. Claude monitors all three in parallel
4. Claude aggregates changes
5. Claude creates PR with gh CLI
```
#### Example 2: Codebase Analysis
```
1. Claude plans analysis strategy
2. Claude delegates to Codex:
   - "Analyze security vulnerabilities"
   - "Check code quality metrics"
   - "Review dependency updates"
3. Codex executes and returns findings
4. Claude creates comprehensive GitHub issue
```
#### Example 3: Bug Fix Workflow
```
1. Claude reads GitHub issue
2. Claude delegates investigation to Codex
3. Codex finds root cause and implements fix
4. Claude reviews the fix
5. Claude creates PR and updates issue
```
### Best Practices
#### For Claude (Orchestrator)
1. **Always think first**: Plan before delegating to workers
2. **Use TodoWrite**: Track worker tasks and progress
3. **Batch operations**: Spawn multiple workers when tasks are independent
4. **Handle GitHub**: All `gh` operations should be done by Claude
5. **Aggregate intelligently**: Combine worker outputs meaningfully
6. **Monitor actively**: Use `BashOutput` to track worker progress
7. **Kill stuck workers**: Use `KillBash` if workers hang
#### For Codex (Workers)
1. **Focused tasks**: Give Codex specific, well-defined tasks
2. **Appropriate reasoning**: Use `low` for simple, `high` for complex
3. **Parallel when possible**: Independent tasks should run concurrently
4. **Clear output**: Request structured output for easy aggregation
5. **Error handling**: Expect and handle worker failures gracefully
6. **CRITICAL - Planning vs Implementation**:
   - For `nnn` (planning): ALWAYS include "DO NOT modify/implement/write files"
   - For `gogogo` (implementation): Allow file modifications
   - Use explicit instructions: "Analyze and DESIGN ONLY" vs "Implement the following"
### Communication Patterns
#### Claude → Codex
```bash
# Direct execution with results
result=$(codex exec -s danger-full-access "task")
# Background with monitoring
codex exec -s danger-full-access "task" & # run_in_background: true
BashOutput bash_id
```
#### Codex → Claude
- Returns via stdout/stderr
- Exit codes indicate success/failure
- Structured output (JSON, markdown) for easy parsing
#### Claude → GitHub
```bash
# All GitHub operations handled by Claude
gh issue create --title "Title" --body "Body"
gh pr create --title "Title" --body "Body"
gh issue comment 123 --body "Comment"
```
### Anti-Patterns to Avoid
1. ❌ **Codex doing GitHub operations** - Only Claude should interact with GitHub
2. ❌ **Claude doing file operations** - Delegate file work to Codex
3. ❌ **Serial execution of independent tasks** - Use parallel workers
4. ❌ **Not monitoring workers** - Always track progress with BashOutput
5. ❌ **Over-reasoning for simple tasks** - Use appropriate reasoning levels
6. ❌ **Under-utilizing parallelism** - Spawn multiple workers when possible
### Performance Guidelines
#### Reasoning Levels by Task Type
- **minimal**: File listing, simple searches (~5-10s)
- **low**: Code formatting, simple refactoring (~10-15s)
- **medium**: Feature implementation, bug fixes (~15-25s)
- **high**: Complex analysis, architecture changes (~30-60s+)
#### Parallel Execution Limits
- Maximum recommended concurrent workers: 5-10
- Monitor system resources when spawning many workers
- Use `ps aux | grep codex` to check running instances
### Example: Complete Feature Implementation
```bash
# Claude's workflow for implementing a new feature
# 1. Claude analyzes requirements and creates plan
TodoWrite "Plan feature implementation"
# 2. Claude spawns multiple Codex workers
worker1=$(codex exec -s danger-full-access "Implement backend API endpoint" &)
worker2=$(codex exec -s danger-full-access "Create frontend components" &)
worker3=$(codex exec -s danger-full-access "Write unit tests" &)
worker4=$(codex exec -s danger-full-access "Update documentation" &)
# 3. Claude monitors all workers
BashOutput $worker1
BashOutput $worker2
BashOutput $worker3
BashOutput $worker4
# 4. Claude aggregates results
# (Combine outputs, resolve conflicts, ensure consistency)
# 5. Claude handles GitHub
gh issue comment $issue_number --body "Feature implemented"
gh pr create --title "feat: New feature" --body "Details..."
```
### Metrics & Monitoring
Track these metrics for optimization:
- Worker completion times by reasoning level
- Parallel vs serial execution time savings
- Worker failure rates by task type
- GitHub operation success rates
- Overall workflow completion times
### Migration Path
For existing workflows:
1. Identify file-heavy operations → Delegate to Codex
2. Identify GitHub operations → Keep with Claude
3. Identify independent tasks → Parallelize with multiple workers
4. Identify complex analysis → Use high-reasoning Codex
5. Test and optimize reasoning levels
**Last Updated**: 2025-09-02
**Architecture Version**: 2.0
**Key Innovation**: Orchestrator/Worker pattern with Claude/Codex