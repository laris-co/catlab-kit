# Retrospective Command (rrr)

Create a detailed session retrospective following CLAUDE.md workflow.

## Usage
```
rrr
rrr "additional session notes"
```

## Example
```
rrr
rrr "Completed authentication system, found JWT issues"
```

## What this command does

I will create a comprehensive session retrospective following the CLAUDE.md template:

1. **Gather Session Data**: `git diff --name-only main...HEAD`, `git log --oneline main...HEAD`, session timestamps
2. **Create Retrospective Document**: Markdown file in `retrospectives/` with ALL required sections
3. **Validate Completeness**: Ensure AI Diary and Honest Feedback sections are complete
4. **Update CLAUDE.md**: Copy new lessons learned
5. **Link to GitHub**: Commit retrospective and comment on relevant issue/PR

## Retrospective Structure

The retrospective will include:

- **📅 Session Metadata**: Date, time, duration, focus area
- **📊 Repository State**: Branch, commits, modified files
- **🔍 Key Discoveries**: Important findings and insights
- **📝 Progress Summary**: What was accomplished
- **💭 AI Diary (MANDATORY)**: First-person narrative of session experience
- **💭 Honest Feedback (MANDATORY)**: Frank assessment of what worked/didn't work
- **📋 Lessons Learned**: Actionable insights for future sessions
- **➡️ Next Steps**: Recommended actions

## Key Features

✅ **Complete session capture** - All relevant information documented
✅ **Mandatory introspection** - AI Diary and Honest Feedback required
✅ **Historical tracking** - Timestamped records for context
✅ **Continuous improvement** - Lessons learned integration
✅ **GitHub integration** - Links to relevant issues/PRs

This follows the established CLAUDE.md retrospective workflow pattern.