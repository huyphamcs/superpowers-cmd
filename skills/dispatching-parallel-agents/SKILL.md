---
name: dispatching-parallel-agents
description: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies - dispatches parallel cmd -p subagents
allowed-tools: Bash
---

# Dispatching Parallel Agents

When you have multiple independent tasks, dispatch them simultaneously via `cmd -p` background processes.

**Core principle:** One subagent per independent problem domain. Let them work concurrently.

## When to Use

**Use when:**
- 3+ test files failing with different root causes
- Multiple subsystems broken independently
- Each problem can be understood without context from others
- No shared state between investigations
- Independent plan tasks that don't modify the same files

**Don't use when:**
- Failures are related (fix one might fix others)
- Need to understand full system state
- Subagents would edit the same files

## The Pattern

### 1. Identify Independent Domains

Group work by what's affected — each domain is independent.

### 2. Create Focused Prompts

Each prompt gets:
- **Specific scope:** One file or subsystem
- **Clear goal:** What to accomplish
- **Constraints:** What NOT to change

Write each to `.commandcode/subagent-prompts/parallel-N.md`.

### 3. Dispatch in Parallel

```bash
# Setup
mkdir -p .commandcode/subagent-prompts .commandcode/subagent-results

# Dispatch all in background
cmd -p "$(cat .commandcode/subagent-prompts/parallel-1.md)" \
  --yolo --max-turns 15 --trust \
  > .commandcode/subagent-results/parallel-1.txt 2>&1 &

cmd -p "$(cat .commandcode/subagent-prompts/parallel-2.md)" \
  --yolo --max-turns 15 --trust \
  > .commandcode/subagent-results/parallel-2.txt 2>&1 &

cmd -p "$(cat .commandcode/subagent-prompts/parallel-3.md)" \
  --yolo --max-turns 15 --trust \
  > .commandcode/subagent-results/parallel-3.txt 2>&1 &

# Wait for all to complete
wait
```

### 4. Review and Integrate

```bash
# Read all results
for f in .commandcode/subagent-results/parallel-*.txt; do
  echo "=== $(basename $f) ==="
  tail -30 "$f"
done

# Check for conflicts
git diff --stat
# Run full test suite
```

## Verification

After agents return:
1. Review each summary — understand what changed
2. Check for conflicts — did agents edit same code?
3. Run full suite — verify all fixes work together

## Common Mistakes

- ❌ Too broad: "Fix all the tests" — agent gets lost
- ✅ Specific: "Fix agent-tool-abort.test.ts" — focused scope
- ❌ No context: "Fix the race condition" — agent doesn't know where
- ✅ Context: Paste error messages and test names
- ❌ Vague output: "Fix it" — you don't know what changed
- ✅ Specific: "Return summary of root cause and changes"
