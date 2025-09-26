# /context

**Description**: Create GitHub context issue and compact conversation
**Arguments**: None
**Flags**:
  - `--verbose`: Show detailed git status and file listings
  - `--dry-run`: Preview context issue content without creating

## Usage Examples

### Basic Usage
```bash
/context
```

### With Flags
```bash
/context --verbose
/context --dry-run
/context --verbose --dry-run
```

## Implementation

### What This Command Does
Creates a comprehensive GitHub context issue that captures the current session state, including git status, changed files, key discoveries, and next steps. After creating the issue, it compacts the conversation to save context.

### Original Short Code Reference
This command replaces the `ccc` short code and maintains identical functionality:
- Gathers git status and log information
- Creates a detailed GitHub context issue
- Compacts the conversation to preserve context
- Provides issue number for reference

### Command Logic
1. Gather current git status and recent commit history
2. Create GitHub issue with comprehensive context template
3. Include changed files, discoveries, and next steps
4. Compact conversation to save context
5. Return issue number for tracking

## Flag Behavior

### --verbose Flag
When used, this flag will:
- Show detailed git status output
- Display full file listings and changes
- Include verbose logging during issue creation

### --dry-run Flag
When used, this flag will:
- Show what would be executed
- Preview the context issue content
- Display git information without creating issue
- Skip the conversation compacting step

## Error Handling

### Common Errors
- **Error**: Not in a git repository
  **Solution**: Navigate to a git repository before running the command

- **Error**: GitHub CLI not authenticated
  **Solution**: Run `gh auth login` to authenticate with GitHub

### Prerequisites
This command requires:
- Git repository context
- GitHub CLI (`gh`) installed and authenticated
- Internet connection for GitHub API access

## Backward Compatibility

### Original Short Code
The original `ccc` short code continues to work exactly as before.

### Migration Path
Users can:
1. Continue using the original `ccc` short code
2. Start using the new `/context` slash command
3. Mix both approaches as needed

## Testing

### Manual Test Cases
1. **Basic functionality**: Test `/context` creates GitHub issue correctly
2. **Verbose mode**: Test `--verbose` flag shows additional output
3. **Dry run**: Test `--dry-run` shows preview without execution
4. **Auto-complete**: Verify command appears in suggestion list
5. **Backward compatibility**: Test original `ccc` short code still works

### Expected Results
- GitHub context issue created with comprehensive information
- Conversation compacted successfully (unless dry-run)
- Issue number provided for reference
- Both old and new commands produce identical results

## Notes

### Development Guidelines
- Keep implementation simple
- Reference existing `ccc` short code logic
- Maintain backward compatibility
- Document all behaviors clearly

### Future Enhancements
- Consider adding custom issue templates
- Option to specify issue labels or assignees
- Integration with project boards