# /retrospective

**Description**: Generate detailed session retrospective report
**Arguments**: None
**Flags**:
  - `--verbose`: Include detailed timeline and metrics
  - `--dry-run`: Preview retrospective content without saving

## Usage Examples

### Basic Usage
```bash
/retrospective
```

### With Flags
```bash
/retrospective --verbose
/retrospective --dry-run
/retrospective --verbose --dry-run
```

## Implementation

### What This Command Does
Documents the session's activities, learnings, and outcomes in a comprehensive retrospective report. Gathers session data, creates a markdown file in the retrospectives/ directory with all required sections, and links it to relevant GitHub issues.

### Original Short Code Reference
This command replaces the `rrr` short code and maintains identical functionality:
- Session data gathering and timeline creation
- Comprehensive retrospective document generation
- AI Diary and Honest Feedback sections (mandatory)
- Integration with git commits and GitHub issues

### Command Logic
1. Gather session data (git diff, log, timestamps)
2. Create retrospective document with all required sections
3. Validate completeness using retrospective checklist
4. Update CLAUDE.md with new lessons learned
5. Commit retrospective and link to GitHub issues
6. Provide file path and summary

## Flag Behavior

### --verbose Flag
When used, this flag will:
- Include detailed timeline with timestamps
- Show comprehensive git change analysis
- Display session metrics and statistics
- Include verbose logging during retrospective creation

### --dry-run Flag
When used, this flag will:
- Show what would be executed
- Preview the retrospective content
- Display gathered session data without saving
- Skip file creation and git operations

## Error Handling

### Common Errors
- **Error**: No git changes found in session
  **Solution**: Ensure you've made commits during the session

- **Error**: Cannot determine session duration
  **Solution**: Provide explicit start time or use verbose mode

- **Error**: Missing AI Diary or Honest Feedback sections
  **Solution**: Complete all mandatory sections before validation

### Prerequisites
This command requires:
- Git repository context
- Active session with some changes or commits
- Write access to retrospectives/ directory
- GitHub CLI for issue linking (optional)

## Backward Compatibility

### Original Short Code
The original `rrr` short code continues to work exactly as before.

### Migration Path
Users can:
1. Continue using the original `rrr` short code
2. Start using the new `/retrospective` slash command
3. Mix both approaches as needed

## Testing

### Manual Test Cases
1. **Basic functionality**: Test `/retrospective` creates comprehensive report
2. **Verbose mode**: Test `--verbose` flag includes detailed metrics
3. **Dry run**: Test `--dry-run` shows preview without saving
4. **Auto-complete**: Verify command appears in suggestion list
5. **Backward compatibility**: Test original `rrr` short code still works

### Expected Results
- Retrospective markdown file created in retrospectives/ directory
- All mandatory sections completed (AI Diary, Honest Feedback)
- Session timeline and technical details documented
- File committed to git with appropriate message
- Both old and new commands produce identical results

## Notes

### Development Guidelines
- Keep implementation simple
- Reference existing `rrr` short code logic
- Maintain backward compatibility
- Ensure all mandatory sections are included

### Critical Requirements
- **AI Diary section is MANDATORY** - provides crucial context
- **Honest Feedback section is MANDATORY** - ensures continuous improvement
- Retrospectives without these sections lose significant value
- Time zone display preference: GMT+7 first, UTC in parentheses

### Future Enhancements
- Custom retrospective templates by session type
- Integration with project metrics and analytics
- Automatic lesson learned extraction
- Session comparison and trend analysis