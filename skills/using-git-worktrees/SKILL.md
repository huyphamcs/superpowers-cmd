---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via git worktree
allowed-tools: Bash
---

# Using Git Worktrees

## Overview

Ensure work happens in an isolated workspace. Command Code doesn't have native worktree tools, so use git worktrees directly.

**Core principle:** Detect existing isolation first. Then create if needed. Never fight the harness.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an isolated workspace."

## Step 0: Detect Existing Isolation

**Before creating anything, check if you are already in an isolated workspace.**

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
BRANCH=$(git branch --show-current)
```

**Submodule guard:** Verify you're not in a submodule:
```bash
git rev-parse --show-superproject-working-tree 2>/dev/null
```

**If `GIT_DIR != GIT_COMMON` (and not a submodule):** Already in a worktree. Skip to Step 3 (Project Setup).

**If `GIT_DIR == GIT_COMMON` (or in a submodule):** In a normal repo. Ask consent:
> "Would you like me to set up an isolated worktree? It protects your current branch from changes."

If user declines, work in place and skip to Step 3.

## Step 1: Create Worktree

```bash
# Determine directory
if [ -d .worktrees ]; then
  LOCATION=".worktrees"
elif [ -d worktrees ]; then
  LOCATION="worktrees"
else
  LOCATION=".worktrees"
  # Verify .worktrees is gitignored
  git check-ignore -q .worktrees 2>/dev/null || echo ".worktrees/" >> .gitignore
fi

# Create worktree
BRANCH_NAME="feature/$(date +%Y-%m-%d)-${NAME}"
git worktree add "$LOCATION/$BRANCH_NAME" -b "$BRANCH_NAME"
cd "$LOCATION/$BRANCH_NAME"
```

## Step 2: Project Setup

Auto-detect and run setup:
```bash
if [ -f package.json ]; then npm install || pnpm install; fi
if [ -f Cargo.toml ]; then cargo build; fi
```

## Step 3: Verify Clean Baseline

Run tests to ensure workspace starts clean. If tests fail, report and ask whether to proceed.

## Report

```
Worktree ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Red Flags

**Never:**
- Create a worktree when Step 0 detects existing isolation
- Proceed with failing tests without asking
- Skip baseline test verification
