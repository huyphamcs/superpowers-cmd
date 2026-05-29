---
name: executing-plans
description: Use when you have a written implementation plan to execute with review checkpoints - sequential task-by-task execution
allowed-tools: Read, Bash, Write, Edit, Grep, Glob, todo_write
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks sequentially, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** If you're on a platform with cmd -p subagent support (Command Code supports this), use subagent-driven-development instead for faster parallel execution. This skill is the sequential fallback.

## The Process

### Step 1: Load and Review Plan

1. Read plan file
2. Review critically - identify questions or concerns
3. If concerns: raise with your human partner before starting
4. If no concerns: create TodoWrite and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Invoke finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## Required Workflow Skills

- **using-git-worktrees** — Ensures isolated workspace
- **superpowers-writing-plans** — Creates the plan this executes
- **finishing-a-development-branch** — Complete development after all tasks
