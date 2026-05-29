# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**In Claude Code:** Use the `Task` tool.
**In Command Code:** Write to `.commandcode/subagent-prompts/`, then dispatch:
```bash
cmd -p "$(cat .commandcode/subagent-prompts/task-N-quality-reviewer.md)" --yolo --max-turns 10 --trust
```

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

## Prompt Template

Use the template at `requesting-code-review/code-reviewer.md` with these placeholders filled:
- `{DESCRIPTION}`: [task summary, from implementer's report]
- `{PLAN_OR_REQUIREMENTS}`: Task N from [plan-file]
- `{BASE_SHA}`: [commit before task]
- `{HEAD_SHA}`: [current commit]

## Additional Quality Checks

**In addition to standard code quality concerns, the reviewer should check:**
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
