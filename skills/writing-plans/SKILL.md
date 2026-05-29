---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code - writes comprehensive implementation plans with bite-sized tasks
allowed-tools: Read, Write, Bash, Edit
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`

## Scope Check

If the spec covers multiple independent subsystems, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for.

- Design units with clear boundaries and well-defined interfaces
- Prefer smaller, focused files over large ones that do too much
- Files that change together should live together
- In existing codebases, follow established patterns

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers-subagent-driven-development (recommended) or superpowers-executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.ts`
- Modify: `exact/path/to/existing.ts:123-145`
- Test: `tests/exact/path/to/test.ts`

- [ ] **Step 1: Write the failing test**

```typescript
test('specific_behavior', () => { ... });
```

- [ ] **Step 2: Verify test fails correctly**

```bash
pnpm test -- path/to/test.ts
```

- [ ] **Step 3: Implement minimal code to pass test**

- [ ] **Step 4: Verify test passes**

- [ ] **Step 5: Commit**

```bash
git add -A && git commit -m "feat: [description]"
```
```

## Task Ordering

- Tasks that set up infrastructure come before tasks that depend on it
- Core types/interfaces before implementations
- Happy path before edge cases
- Each task produces self-contained, testable, committable changes

## Before Finalizing

Run a Plan Document Review: check for TODOs, placeholders, spec alignment, task clarity, and whether an engineer could follow the plan without getting stuck. Fix issues inline.

## Transition

After plan is complete and committed, invoke superpowers-subagent-driven-development or superpowers-executing-plans to implement.
