# Next Task Planning Command (nnn)

Create a comprehensive implementation plan based on gathered context and create a GitHub issue for tracking.

## Usage
```
nnn "feature description"
nnn #123  (analyze existing issue)
```

## Example
```
nnn "Add dark mode toggle to user settings"
nnn "Implement real-time chat functionality"
nnn #45  (create plan for existing issue #45)
```

## What this command does

I will create a comprehensive implementation plan following the CLAUDE.md workflow:

1. **Check for Recent Context**: Look for recent context issues or create one if needed
2. **Deep Analysis**: Research the codebase, analyze patterns, identify affected components
3. **Create Comprehensive Plan Issue**: Generate detailed GitHub issue with:
   - Problem statement and requirements
   - Technical research findings
   - Proposed solution architecture
   - Step-by-step implementation plan
   - Risk assessment and mitigation
   - Success criteria and acceptance tests

## Plan Issue Structure

The GitHub issue will include:

- **📋 Problem Statement**: Clear definition of what needs to be built
- **🔍 Technical Research**: Analysis of existing code patterns and dependencies
- **🏗️ Proposed Solution**: Architecture and implementation approach
- **📝 Implementation Steps**: Detailed, dependency-ordered tasks
- **⚠️ Risks & Considerations**: Potential challenges and mitigation strategies
- **✅ Success Criteria**: How to verify the implementation works
- **🧪 Testing Strategy**: Unit, integration, and manual testing approach

## Key Features

✅ **Context-aware** - References recent context issues
✅ **Codebase analysis** - Deep understanding of existing patterns
✅ **Dependency ordering** - Tasks organized by prerequisites
✅ **Risk assessment** - Identifies potential blockers
✅ **Testable criteria** - Clear success metrics

## Command Flow

1. Parse user input (feature description or issue number)
2. Check for recent context issue (last 24 hours)
3. If no context, run `ccc` workflow first
4. Analyze codebase for relevant patterns and components
5. Research similar implementations and best practices
6. Generate comprehensive plan with all required sections
7. Create GitHub issue with `plan:` label
8. Provide issue number and summary to user

This follows the established `ccc` → `nnn` → `gogogo` workflow pattern from CLAUDE.md.