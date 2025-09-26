# Create Context & Compact Command (ccc)

Save current session state and context, then compact the conversation for forward compatibility.

## Usage
```
ccc
ccc "additional context notes"
```

## Example
```
ccc
ccc "Working on user authentication, found issue with JWT tokens"
```

## What this command does

I will capture the current session state and create a context issue for future reference:

1. **Gather Session Information**:
   - Current git status and recent commits
   - Modified files and working tree state
   - Recent discoveries and progress
   - Active branch and repository state

2. **Create GitHub Context Issue**:
   - Detailed template capturing current state
   - Changed files and their purposes
   - Key discoveries and insights
   - Next steps and recommendations
   - Session timestamps and duration

3. **Compact Conversation**:
   - Use `/compact` to summarize conversation
   - Preserve context while reducing token usage
   - Enable continued work in new session

## Context Issue Structure

The GitHub issue will include:

- **📅 Session Metadata**: Date, time, duration, focus area
- **📊 Repository State**: Branch, commits, modified files
- **🔍 Key Discoveries**: Important findings and insights
- **📝 Progress Summary**: What was accomplished
- **➡️ Next Steps**: Recommended actions for continuation
- **🔗 Related Issues**: Links to relevant issues/PRs
- **📋 Context Variables**: Important state information

## Key Features

✅ **Complete state capture** - All relevant session information
✅ **GitHub issue creation** - Persistent context storage
✅ **Conversation compacting** - Reduces token usage
✅ **Forward compatibility** - Easy session continuation
✅ **Timestamped records** - Historical context tracking

## When to Use

- End of coding session
- Before switching tasks
- When conversation gets long
- Before complex refactoring
- When starting new features

## Command Flow

1. Gather git status, recent commits, and modified files
2. Analyze current working state and progress
3. Create comprehensive context issue with `context:` label
4. Add session metadata and next steps
5. Execute `/compact` to summarize conversation
6. Provide issue number and compact summary

This enables the `ccc` → `nnn` → `gogogo` workflow from CLAUDE.md.