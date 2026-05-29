---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate - presents structured options for merge, PR, or cleanup
allowed-tools: Bash
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → Detect environment → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
pnpm test  # or npm test, cargo test, pytest, go test ./...
```

**If tests fail:** Report failures. Cannot proceed until fixed.

**If tests pass:** Continue to Step 2.

## Step 2: Detect Environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
```

| State | Menu |
|-------|------|
| `GIT_DIR == GIT_COMMON` (normal repo) | Standard 4 options |
| `GIT_DIR != GIT_COMMON`, named branch | Standard 4 options |
| `GIT_DIR != GIT_COMMON`, detached HEAD | Reduced 3 options (no merge) |

## Step 3: Determine Base Branch

```bash
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

## Step 4: Present Options

**Normal repo / named branch:**
```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Detached HEAD:**
```
Implementation complete. Detached HEAD state.

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)
3. Discard this work

Which option?
```

## Step 5: Execute Choice

### Option 1: Merge Locally

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base-branch>
git pull
git merge <feature-branch>
# Run tests on merged result
# Cleanup worktree if applicable
git branch -d <feature-branch>
```

### Option 2: Push and Create PR

```bash
git push -u origin <feature-branch>
gh pr create --title "<title>" --body "<description>"
```
Do NOT clean up worktree — user needs it for PR iteration.

### Option 3: Keep As-Is

Report: "Keeping branch <name>." Don't cleanup.

### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits in this branch
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation. Then force-delete.
