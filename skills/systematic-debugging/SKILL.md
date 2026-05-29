---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes - 4-phase root cause process with strict no-guessing discipline
allowed-tools: Bash, Read, Grep, Glob, Edit, explore
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue: test failures, bugs in production, unexpected behavior, performance problems, build failures, integration issues.

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

## The Four Phases

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully** — Don't skip past errors or warnings. They often contain the exact solution. Read stack traces completely. Note line numbers, file paths, error codes.

2. **Reproduce Consistently** — Can you trigger it reliably? What are the exact steps? Does it happen every time? If not reproducible → gather more data, don't guess.

3. **Check Recent Changes** — What changed that could cause this? Git diff, recent commits. New dependencies, config changes. Environmental differences.

4. **Gather Evidence in Multi-Component Systems** — When system has multiple components (CI → build → signing, API → service → database): add diagnostic instrumentation at each component boundary. Log what data enters and exits each component. Run once to gather evidence. THEN analyze.

5. **Trace Data Flow** — Where does bad value originate? What called this with bad value? Keep tracing up until you find the source. Fix at source, not at symptom.

### Phase 2: Pattern Analysis

1. **Find Working Examples** — Locate similar working code in same codebase
2. **Compare Against References** — If implementing pattern, read reference implementation COMPLETELY
3. **Identify Differences** — What's different between working and broken? List every difference.
4. **Understand Dependencies** — What other components does this need?

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis** — State clearly: "I think X is the root cause because Y"
2. **Test Minimally** — Make the SMALLEST possible change. One variable at a time.
3. **Verify Before Continuing** — Did it work? Yes → Phase 4. No → Form NEW hypothesis. DON'T add more fixes on top.

### Phase 4: Implementation

1. **Create Failing Test Case** — Simplest possible reproduction. Use test-driven-development for proper tests.
2. **Implement Single Fix** — Address the root cause. ONE change at a time. No "while I'm here" improvements.
3. **Verify Fix** — Test passes now? No other tests broken? Issue actually resolved?
4. **If Fix Doesn't Work** — STOP. Count: How many fixes have you tried? If < 3: Return to Phase 1. **If ≥ 3: STOP and question the architecture.** Discuss with your human partner.

## Red Flags - STOP

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "One more fix attempt" (when already tried 2+)
- Proposing solutions before tracing data flow

**ALL of these mean: STOP. Return to Phase 1.**

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| 1. Root Cause | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| 2. Pattern | Find working examples, compare | Identify differences |
| 3. Hypothesis | Form theory, test minimally | Confirmed or new hypothesis |
| 4. Implementation | Create test, fix, verify | Bug resolved, tests pass |
