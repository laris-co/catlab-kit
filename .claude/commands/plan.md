# /plan

**Description**: Analyze GitHub issue and create implementation plan
**Arguments**: Optional: issue-number
**Flags**:
  - `--verbose`: Show detailed analysis steps
  - `--dry-run`: Preview plan content without creating issue

## Usage Examples

### Basic Usage
```bash
/plan
```

### With Arguments
```bash
/plan 123
/plan #456
```

### With Flags
```bash
/plan --verbose
/plan 123 --dry-run
/plan --verbose --dry-run
```

## Implementation

### What This Command Does
Analyzes a GitHub issue (latest if none specified) and creates a comprehensive implementation plan. Automatically runs context creation (`ccc`) if no recent context exists, then performs deep analysis of the codebase and creates a detailed plan issue.

### Original Short Code Reference
This command replaces the `nnn` short code and maintains identical functionality:
- Smart context checking (runs `ccc` if needed)
- Deep codebase analysis and pattern research
- Comprehensive implementation plan creation
- Integration with existing project workflows

### Command Logic
1. Check for recent context issue, create if missing
2. Analyze specified issue or find the latest relevant issue
3. Perform deep codebase analysis to understand patterns
4. Research affected components and dependencies
5. Create comprehensive plan issue with detailed steps
6. Provide plan summary and issue number

## Flag Behavior

### --verbose Flag
When used, this flag will:
- Show detailed analysis steps and reasoning
- Display codebase research findings
- Include verbose output from pattern analysis
- Show all components and files being examined

### --dry-run Flag
When used, this flag will:
- Show what would be executed
- Preview the implementation plan content
- Display analysis results without creating issue
- Skip the actual plan issue creation

## Error Handling

### Common Errors
- **Error**: Invalid issue number provided
  **Solution**: Verify issue exists and use correct format (number only)

- **Error**: No recent issues found
  **Solution**: Create an issue first or specify a valid issue number

- **Error**: GitHub CLI not authenticated
  **Solution**: Run `gh auth login` to authenticate with GitHub

### Prerequisites
This command requires:
- Git repository context
- GitHub CLI (`gh`) installed and authenticated
- At least one GitHub issue in the repository
- Internet connection for GitHub API access

## Backward Compatibility

### Original Short Code
The original `nnn` short code continues to work exactly as before.

### Migration Path
Users can:
1. Continue using the original `nnn` short code
2. Start using the new `/plan` slash command
3. Mix both approaches as needed
4. Use either `nnn #123` or `/plan 123` format

## Testing

### Manual Test Cases
1. **Basic functionality**: Test `/plan` analyzes latest issue correctly
2. **With issue number**: Test `/plan 123` analyzes specific issue
3. **Verbose mode**: Test `--verbose` flag shows analysis details
4. **Dry run**: Test `--dry-run` shows preview without execution
5. **Auto-complete**: Verify command appears in suggestion list
6. **Backward compatibility**: Test original `nnn` short code still works

### Expected Results
- Comprehensive implementation plan issue created
- Deep analysis of codebase patterns completed
- Clear implementation steps with dependencies
- Both old and new commands produce identical results
- Context issue created automatically if missing

## Notes

### Development Guidelines
- Keep implementation simple
- Reference existing `nnn` short code logic
- Maintain backward compatibility
- Ensure comprehensive analysis workflow

### Future Enhancements
- Support for multiple issue analysis
- Integration with project estimation tools
- Custom plan templates based on issue type
- Automatic task breakdown and assignment
