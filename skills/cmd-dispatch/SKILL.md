---
name: cmd-dispatch
description: Dispatches tasks to fresh Command Code headless sessions for isolated subagent execution. Use when any Superpowers skill tells you to dispatch a subagent - implementer, reviewer, or parallel agents. Provides the dispatch pattern using cmd -p.
allowed-tools: Bash(cmd:*)
---

# cmd-dispatch — Subagent Dispatch for Command Code

Dispatches focused tasks to fresh `cmd -p` headless sessions. Each subagent gets
isolated context — it sees only what you explicitly provide. This preserves your
main session context and keeps subagents focused.

## When to Use

When any Superpowers skill instructs you to dispatch a subagent:
- Dispatching an implementer subagent
- Dispatching a spec reviewer subagent
- Dispatching a code quality reviewer subagent
- Dispatching parallel agents for independent work
- Dispatching a plan reviewer subagent
- Dispatching a spec document reviewer subagent

## The Dispatch Pattern

### Step 1: Prepare the Prompt

Write the full subagent prompt to a file. The prompt must be self-contained —
the subagent has no access to your conversation history.

```
.commandcode/subagent-prompts/task-<N>-<role>.md
```

The prompt MUST include:
- **Task description**: Exactly what to do (full task text from plan)
- **Project context**: Where to work, architecture notes, dependencies
- **Expected output**: What status to return, what format
- **Constraints**: What NOT to change, boundaries of the task

### Step 2: Dispatch

```bash
cmd -p "$(cat .commandcode/subagent-prompts/task-N-role.md)" \
  --yolo \
  --max-turns 15 \
  --trust \
  2>&1 | tee .commandcode/subagent-results/task-N-role.txt
```

- `--yolo`: Bypasses permission prompts (critical — subagents can't interact)
- `--max-turns 15`: Caps turns to prevent runaway sessions
- `--trust`: Auto-trusts the project directory
- `tee`: Saves output AND shows it so you can monitor progress

**For simple mechanical tasks** (1-2 files, clear spec), reduce max-turns:
```bash
cmd -p "prompt" --yolo --max-turns 8 --trust
```

**For complex multi-file tasks**, increase:
```bash
cmd -p "prompt" --yolo --max-turns 25 --trust
```

### Step 3: Verify Changes

After dispatch completes, check what the subagent actually did:

```bash
git diff --stat HEAD
git diff HEAD
```

**Do not trust the subagent's report alone.** Verify:
- Files changed match the task scope
- No unexpected modifications outside the task
- Tests still pass (run the test suite)
- The output matches the task requirements

### Step 4: Interpret Result

Parse the subagent's output for status indicators. These appear at the end:
- `DONE` — Task completed successfully
- `DONE_WITH_CONCERNS` — Completed but subagent has doubts
- `BLOCKED` — Cannot complete (missing dependency, unclear spec)
- `NEEDS_CONTEXT` — Needs more information to proceed

## Parallel Dispatch

When dispatching independent tasks in parallel:

```bash
cmd -p "$(cat .commandcode/subagent-prompts/task-1.md)" \
  --yolo --max-turns 15 --trust \
  > .commandcode/subagent-results/task-1.txt 2>&1 &

cmd -p "$(cat .commandcode/subagent-prompts/task-2.md)" \
  --yolo --max-turns 15 --trust \
  > .commandcode/subagent-results/task-2.txt 2>&1 &

cmd -p "$(cat .commandcode/subagent-prompts/task-3.md)" \
  --yolo --max-turns 15 --trust \
  > .commandcode/subagent-results/task-3.txt 2>&1 &

wait

# Read all results
for f in .commandcode/subagent-results/task-*.txt; do
  echo "=== $(basename $f) ==="
  tail -30 "$f"
done
```

**Before parallel dispatch**, verify tasks are truly independent:
- No shared files being modified
- No sequential dependencies
- Each task can succeed or fail independently

## Model Selection

Use cheaper/faster models for mechanical tasks:

```bash
# Mechanical task (isolated function, 1-2 files)
cmd -p "prompt" --model deepseek/deepseek-v4-flash --yolo --max-turns 10 --trust

# Standard task (multi-file, integration)
cmd -p "prompt" --model deepseek/deepseek-v4-pro --yolo --max-turns 15 --trust
```

## Directory Setup

Create the subagent directories if they don't exist:

```bash
mkdir -p .commandcode/subagent-prompts
mkdir -p .commandcode/subagent-results
```

Add to `.gitignore`:
```
.commandcode/subagent-prompts/
.commandcode/subagent-results/
```

## Critical Rules

- **ALWAYS use `--yolo`** — subagents cannot respond to permission prompts
- **ALWAYS redirect output** — capture results for review
- **ALWAYS check `git diff`** — verify what the subagent actually changed
- **ALWAYS run tests after** — subagents can break things
- **NEVER dispatch without a focused prompt** — vague prompts produce garbage
- **NEVER trust subagent reports blindly** — verify independently

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Subagent hangs | Kill process, reduce max-turns, simplify task |
| Subagent produces no output | Check prompt file exists, check cmd is installed |
| Subagent modifies wrong files | Narrow the prompt constraints, re-dispatch |
| Tests fail after dispatch | Review diff, fix issues, re-dispatch or fix manually |
| Permission errors | Ensure `--yolo` and `--trust` flags are set |
