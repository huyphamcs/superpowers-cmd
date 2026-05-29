---
name: requesting-code-review
description: Use when completing tasks or before merging to verify work meets requirements - dispatches a code reviewer subagent via cmd -p
allowed-tools: Bash, Read, Grep, Glob
---

# Requesting Code Review

Dispatch a code reviewer subagent to catch issues before they cascade. The reviewer gets precisely crafted context via `cmd -p` for evaluation — never your session's history.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:**
- After each task in subagent-driven development
- Before merging to main
- Before creating a PR
- After completing a feature

**Whenever:**
- You've made non-trivial changes
- You want a second opinion
- Before handing off to someone else

## The Review Pattern

### Step 1: Prepare Review Context

Get the git range:
```bash
BASE_SHA=$(git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null)
HEAD_SHA=$(git rev-parse HEAD)
```

### Step 2: Create Reviewer Prompt

Write `.commandcode/subagent-prompts/review-<feature>.md`:

```
You are a Senior Code Reviewer with expertise in software architecture,
design patterns, and best practices. Review the completed work.

## What Was Implemented
{DESCRIPTION}

## Requirements / Plan
{PLAN_OR_REQUIREMENTS}

## Git Range to Review
**Base:** {BASE_SHA}
**Head:** {HEAD_SHA}

Review the diff and check:
- Plan alignment: does it match requirements?
- Code quality: separation of concerns, error handling, type safety
- Architecture: sound design, scalable, secure
- Testing: tests verify real behavior, edge cases covered
- Production readiness: no obvious bugs, migrations handled

Categorize issues by actual severity. Not everything is Critical.

## Output Format
### Strengths
[What's well done? Be specific.]

### Issues
#### Critical (Must Fix)
[Bugs, security, data loss, broken functionality]

#### Important (Should Fix)
[Architecture, missing features, poor error handling, test gaps]

#### Minor (Nice to Have)
[Style, optimization, documentation]

### Recommendations
### Assessment
**Ready to merge?** [Yes | No | With fixes]
```

### Step 3: Dispatch Reviewer

```bash
cmd -p "$(cat .commandcode/subagent-prompts/review-<feature>.md)" \
  --yolo --max-turns 12 --trust \
  2>&1 | tee .commandcode/subagent-results/review-<feature>.txt
```

### Step 4: Process Results

Review the output. Address Critical and Important issues before proceeding. Minor issues are advisory.

## Critical Rules

**DO:**
- Categorize by actual severity
- Be specific (file:line, not vague)
- Explain WHY each issue matters
- Acknowledge strengths
- Give a clear verdict

**DON'T:**
- Say "looks good" without checking
- Mark nitpicks as Critical
- Give feedback on code you didn't read
- Be vague ("improve error handling")
- Avoid giving a clear verdict
