---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks - dispatches fresh cmd -p subagent per task with two-stage review (spec compliance then code quality)
allowed-tools: Bash, Read, Write, Edit, Grep, Glob, todo_write
---

# Subagent-Driven Development

Execute plan by dispatching fresh subagent per task via `cmd-dispatch`, with two-stage review after each: spec compliance review first, then code quality review.

**Why subagents:** Fresh `cmd -p` sessions with isolated context per task. Each subagent sees only what you explicitly provide — no conversation history pollution. This keeps the main orchestrator session focused and uncluttered.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration

**Continuous execution:** Do not pause to check in with your human partner between tasks. Execute all tasks from the plan without stopping. The only reasons to stop are: BLOCKED status you cannot resolve, ambiguity that genuinely prevents progress, or all tasks complete.

## The Process

### Step 0: Setup

```bash
mkdir -p .commandcode/subagent-prompts .commandcode/subagent-results
echo ".commandcode/subagent-prompts/" >> .gitignore
echo ".commandcode/subagent-results/" >> .gitignore
```

### Step 1: Load Plan

Read the plan file. Create a TodoWrite with every task from the plan. Extract the full task text for each.

### Step 2: Per Task (Repeat for each task)

#### 2a. Create Implementer Prompt

Write `.commandcode/subagent-prompts/task-N-implementer.md` with this template:

```
You are implementing Task N: [task name]

## Task Description
[FULL TEXT of task from plan - paste it here]

## Context
[Scene-setting: where this fits, dependencies, architectural context]

## Before You Begin
If you have questions about requirements, approach, dependencies, or anything unclear — ask them now.

## Your Job
1. Implement exactly what the task specifies
2. Write tests (following TDD if task says to)
3. Verify implementation works
4. Commit your work
5. Self-review (see below)
6. Report back with status

Work from: [current directory]

## When You're in Over Your Head
It is always OK to stop and say "this is too hard for me." STOP and escalate when:
- The task requires architectural decisions with multiple valid approaches
- You need to understand code beyond what was provided
- You feel uncertain about whether your approach is correct
- The task involves restructuring existing code beyond the plan

Report back with BLOCKED or NEEDS_CONTEXT.

## Before Reporting Back: Self-Review
- Did I fully implement everything in the spec?
- Did I miss any requirements?
- Is this my best work?
- Did I avoid overbuilding (YAGNI)?
- Do tests actually verify behavior?

## Report Format
**Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
- What you implemented
- What you tested and test results
- Files changed
- Self-review findings
- Any issues or concerns
```

#### 2b. Dispatch Implementer

Use the dispatch pattern from cmd-dispatch:

```bash
cmd -p "$(cat .commandcode/subagent-prompts/task-N-implementer.md)" \
  --yolo --max-turns 20 --trust \
  2>&1 | tee .commandcode/subagent-results/task-N-implementer.txt
```

#### 2c. Verify Implementation

```bash
git diff --stat HEAD~1..HEAD
# Run tests
```

Do NOT trust the subagent report alone. Verify files changed match task scope.

#### 2d. Spec Compliance Review

Write `.commandcode/subagent-prompts/task-N-spec-reviewer.md`:

```
You are reviewing whether an implementation matches its specification.

## What Was Requested
[FULL TEXT of task requirements]

## What Implementer Claims They Built
[From implementer's report in .commandcode/subagent-results/task-N-implementer.txt]

## CRITICAL: Do Not Trust the Report
You MUST verify everything independently by reading the actual code.

DO:
- Read the actual code they wrote
- Compare to requirements line by line
- Check for missing pieces
- Look for extra features

DO NOT:
- Take their word for what they implemented
- Trust their claims about completeness

Report:
- ✅ Spec compliant
- ❌ Issues found: [list specifically with file:line references]
```

Dispatch:
```bash
cmd -p "$(cat .commandcode/subagent-prompts/task-N-spec-reviewer.md)" \
  --yolo --max-turns 10 --trust \
  2>&1 | tee .commandcode/subagent-results/task-N-spec-reviewer.txt
```

If issues found, have implementer fix and re-review.

#### 2e. Code Quality Review

Only after spec compliance passes. Write `.commandcode/subagent-prompts/task-N-quality-reviewer.md`:

```
You are a Senior Code Reviewer. Review the implementation at the latest commit against:

## What Was Implemented
[task summary from implementer report]

## Requirements
[Task N from plan]

## What to Check
- Plan alignment: does implementation match requirements?
- Code quality: clean separation of concerns, error handling, type safety
- Architecture: sound design decisions, scalable
- Testing: tests verify real behavior, edge cases covered
- Production readiness: no obvious bugs

## Output Format
### Strengths
### Issues (Critical / Important / Minor)
### Assessment
**Ready to merge?** [Yes | No | With fixes]
```

Dispatch:
```bash
cmd -p "$(cat .commandcode/subagent-prompts/task-N-quality-reviewer.md)" \
  --yolo --max-turns 10 --trust \
  2>&1 | tee .commandcode/subagent-results/task-N-quality-reviewer.txt
```

If issues, have implementer fix and re-review.

#### 2f. Mark Task Complete

Only after both reviews pass. Mark task complete in TodoWrite.

### Step 3: Final Review

After all tasks complete, dispatch a final code reviewer for the entire implementation (use requesting-code-review pattern).

### Step 4: Finish

Invoke finishing-a-development-branch.

## Model Selection

```bash
# Mechanical task (1-2 files)
cmd -p "prompt" --model deepseek/deepseek-v4-flash --yolo --max-turns 10 --trust

# Standard task (multi-file)
cmd -p "prompt" --model deepseek/deepseek-v4-pro --yolo --max-turns 20 --trust
```

## Subagent Status Handling

| Status | Action |
|--------|--------|
| DONE | Proceed to review |
| DONE_WITH_CONCERNS | Review carefully, may need re-dispatch |
| BLOCKED | Escalate to human partner |
| NEEDS_CONTEXT | Provide more context, re-dispatch |
