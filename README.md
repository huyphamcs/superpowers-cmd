# Superpowers for Command Code

The complete [Superpowers](https://github.com/obra/superpowers) software development methodology, ported to [Command Code](https://commandcode.ai).

Every skill from the original. Every workflow. Design-first thinking, test-driven development, systematic debugging, subagent-driven implementation — all running natively on Command Code with `cmd -p` subagent dispatch.

## Quick Install

```bash
# Clone the repo
git clone https://github.com/huyphamcs/superpowers-cmd.git
cd superpowers-cmd

# Install skills
./install.sh
```

Or install individual skills:

```bash
cp -r skills/brainstorming ~/.agents/skills/brainstorming
cp -r skills/cmd-dispatch ~/.agents/skills/cmd-dispatch
cp -r skills/using-superpowers ~/.agents/skills/using-superpowers
# ... etc
```

Then add the bootstrap to your `~/.commandcode/AGENTS.md`:

```markdown
## Superpowers

You have Superpowers installed. Before ANY response or action — including
clarifying questions — check if a superpowers skill applies. If there's even
a 1% chance, invoke the skill.
```

That's it. Your next Command Code session has Superpowers.

## The Full Workflow

```
User: "Let's build X"
  ↓
brainstorming           No code without design. Questions, alternatives,
                        design doc, user approval.
  ↓
using-git-worktrees     Isolated feature branch. Clean test baseline.
  ↓
writing-plans           Bite-sized tasks (2-5 min each). Every file path,
                        code, test, commit. DRY, YAGNI, TDD.
  ↓
subagent-driven-dev     Fresh cmd -p subagent per task. Two-stage review:
                        spec compliance, then code quality. Continuous
                        execution — no pauses between tasks.
  ↓
test-driven-dev         RED-GREEN-REFACTOR. No production code without
                        failing test first. Delete code written before tests.
  ↓
requesting-code-review  Subagent review between tasks. Catches issues
                        before they cascade.
  ↓
verification            Evidence before claims. Always verify before
                        saying "done".
  ↓
finishing-a-branch      Structured merge/PR/cleanup. Four options — no
                        ambiguity.
```

For bugs:

```
User: "Fix this bug"
  ↓
systematic-debugging    4-phase root cause. No fixes without investigation.
  ↓
test-driven-dev         Failing test reproduces the bug.
  ↓
verification            Test passes, bug is gone. Prove it.
```

## Architecture

### Skills Layer (14 skills)

```
skills/
├── using-superpowers/          ← Bootstrap. Auto-triggers on every session.
├── brainstorming/              ← Design-first. No code without approval.
├── using-git-worktrees/        ← Isolated workspaces.
├── writing-plans/              ← Bite-sized implementation plans.
├── subagent-driven-development/ ← Dispatches cmd -p per task + 2-stage review.
├── test-driven-development/    ← RED-GREEN-REFACTOR enforcement.
├── systematic-debugging/       ← 4-phase root cause process.
├── dispatching-parallel-agents/ ← Parallel cmd -p for independent tasks.
├── requesting-code-review/     ← Subagent code review.
├── receiving-code-review/      ← Technical evaluation of feedback.
├── executing-plans/            ← Sequential fallback execution.
├── finishing-a-development-branch/ ← Merge/PR/cleanup workflow.
├── verification-before-completion/ ← Evidence before claims.
└── writing-skills/             ← Skill authoring methodology.
```

### Subagent Dispatch Bridge

Command Code has no native `Task` tool for subagent dispatch. The `cmd-dispatch` skill bridges this gap using `cmd -p` headless mode:

```
Claude Code:    Task(description="implement task 3", prompt="...")
Command Code:   cmd -p "$(cat prompt.md)" --yolo --max-turns 15 --trust
```

Each subagent gets:
- **Isolated context** — only what the prompt provides, no conversation history
- **Fresh session** — no state pollution between tasks
- **Turn limits** — capped at 15-25 turns to prevent runaway sessions
- **Auto-accept** — `--yolo` bypasses permission prompts
- **Two-stage review** — spec compliance reviewer then code quality reviewer

Parallel dispatch for independent tasks:

```bash
cmd -p "$(cat task-1.md)" --yolo --max-turns 15 --trust > result-1.txt 2>&1 &
cmd -p "$(cat task-2.md)" --yolo --max-turns 15 --trust > result-2.txt 2>&1 &
cmd -p "$(cat task-3.md)" --yolo --max-turns 15 --trust > result-3.txt 2>&1 &
wait
```

### Skill Auto-Triggering

Skills match based on their `description` frontmatter. The `using-superpowers` skill teaches the agent to check for applicable skills before *any* response — even clarifying questions.

| User says | Auto-triggers |
|-----------|---------------|
| "Let's build X" | brainstorming |
| "Fix this bug" | systematic-debugging |
| "Write code for..." | test-driven-development |
| "Review my PR" | requesting-code-review |
| "I'm done" | verification-before-completion |

### Instruction Priority

1. **User instructions** (AGENTS.md, direct requests) — highest
2. **Superpowers skills** — override defaults where they conflict
3. **System prompt** — lowest

If you say "don't use TDD," the skill respects it. The user is always in control.

## Skill Catalog

### Process Skills

**`brainstorming`** — Design-first thinking. Explores project context, asks clarifying questions, proposes 2-3 approaches, presents design in sections for incremental validation, writes spec document. <HARD-GATE> blocks all implementation until design is approved.

**`using-git-worktrees`** — Isolated feature workspaces. Detects existing isolation, creates git worktrees with `.worktrees/` convention, runs project setup, verifies clean test baseline.

**`writing-plans`** — Bite-sized implementation plans (2-5 min tasks). Maps file structure, defines exact paths, includes complete code and tests. Assumes engineer has zero context and questionable taste.

**`subagent-driven-development`** — Fresh `cmd -p` subagent per task. Two-stage review after each: spec compliance (did they build what was asked?), then code quality (is it well-built?). Continuous execution without human-in-loop.

**`executing-plans`** — Sequential fallback when subagent dispatch isn't preferred. Batch execution with checkpoints.

**`dispatching-parallel-agents`** — Parallel `cmd -p` dispatch for independent tasks. One agent per problem domain, concurrent execution.

### Quality Skills

**`test-driven-development`** — Iron Law: no production code without a failing test first. RED (write failing test) → verify RED (watch it fail) → GREEN (minimal code) → verify GREEN (watch it pass) → REFACTOR. Code written before tests must be deleted. Start over.

**`systematic-debugging`** — 4-phase root cause process. Phase 1: read errors, reproduce, check changes, trace data flow. Phase 2: find working examples, compare patterns. Phase 3: form hypothesis, test minimally. Phase 4: create failing test, implement fix, verify. 3+ failed fixes = architectural problem.

**`verification-before-completion`** — Evidence before claims. No completion claims without fresh verification output. Run the command, read the output, THEN make the claim.

### Collaboration Skills

**`requesting-code-review`** — Dispatches code reviewer subagent via `cmd -p`. Reviews against plan/requirements. Issues categorized by severity (Critical / Important / Minor).

**`receiving-code-review`** — Technical evaluation of review feedback. Verify before implementing. No performative agreement ("You're absolutely right!"). Push back with technical reasoning when feedback is wrong.

**`finishing-a-development-branch`** — Structured completion workflow. Verify tests → detect environment → present 4 options (merge / push PR / keep / discard) → execute → cleanup. Typed confirmation for destructive actions.

### Meta Skills

**`writing-skills`** — TDD applied to skill authoring. Skill anatomy (frontmatter, overview, principles, process, red flags), testing methodology, guidelines for prescriptive specificity.

**`using-superpowers`** — The bootstrap. Teaches the agent to invoke skills before any response. Red flags table for rationalization prevention. Skill priority ordering.

### Adapter

**`cmd-dispatch`** — Maps Claude Code `Task` tool patterns to `cmd -p --yolo --max-turns N --trust`. Prompt preparation, dispatch, verification, result interpretation, parallel patterns, model selection.

## Comparison to Original Superpowers

| Feature | Superpowers (Claude Code) | Superpowers for Command Code |
|---------|---------------------------|------------------------------|
| Skills | 13 skills | 14 skills (+ cmd-dispatch adapter) |
| Subagent dispatch | Native `Task` tool | `cmd -p --yolo` headless mode |
| Parallel agents | Native parallel `Task` | Background `cmd -p &` + `wait` |
| Context isolation | Built-in | Self-contained prompt files |
| Two-stage review | Task tool dispatch | Sequential `cmd -p` calls |
| Worktree isolation | Native `EnterWorktree` | Direct `git worktree` commands |
| Skill auto-trigger | Plugin marketplace | File-based skill discovery |
| Bootstrap | `using-superpowers` skill | Same skill + AGENTS.md |
| All 13 skill workflows | Full preservation | Full preservation |
| Iron Law enforcement | Identical | Identical |
| Red Flag tables | Identical | Identical |
| Instruction priority | User > skills > system | User > skills > system |

The methodology is identical. The dispatch mechanism is different. Every skill has the same gates, the same red flags, the same "Violating the letter is violating the spirit" enforcement.

## Requirements

- [Command Code](https://commandcode.ai) installed (`npm i -g command-code` then `cmd login`)
- Git
- Unix shell (macOS, Linux, WSL)

## Installing a Subset

Don't want all 14 skills? Install just the ones you need:

```bash
# Just the core workflow (no subagents needed)
cp -r skills/using-superpowers ~/.agents/skills/using-superpowers
cp -r skills/brainstorming ~/.agents/skills/brainstorming
cp -r skills/writing-plans ~/.agents/skills/writing-plans
cp -r skills/test-driven-development ~/.agents/skills/test-driven-development
cp -r skills/systematic-debugging ~/.agents/skills/systematic-debugging
cp -r skills/verification-before-completion ~/.agents/skills/verification-before-completion
```

## How Skills Are Structured

Each skill is a directory under `skills/` containing a `SKILL.md` with YAML frontmatter:

```markdown
---
name: brainstorming
description: "You MUST use this before any creative work..."
allowed-tools: Read, Bash, Write, Edit, Glob, Grep, explore, todo_write
---

# Brainstorming Ideas Into Designs
...
```

The `name` field matches the directory name. The `description` is what Command Code matches against your task. The `allowed-tools` list restricts tool access.

To install: copy the entire directory to `~/.agents/skills/<skill-name>/`.

## Contributing

This is a port of [obra/superpowers](https://github.com/obra/superpowers). Contributions should:
- Preserve the original methodology's intent and enforcement
- Work within Command Code's tool ecosystem
- Use `cmd -p` for subagent dispatch
- Follow the original's philosophical principles (TDD, YAGNI, DRY, evidence-before-claims)

Skill changes should be tested by verifying the agent follows the skill's workflow under pressure.

## License

MIT — see [LICENSE](LICENSE)

## Credits

All skill content derives from [Superpowers](https://github.com/obra/superpowers) by [Jesse Vincent](https://blog.fsck.com) and [Prime Radiant](https://primeradiant.com). The original Superpowers is MIT licensed.

The `cmd-dispatch` adapter, bootstrap, and Command Code-specific adaptations were built by Anderson Li.

---

*"Violating the letter of the rules is violating the spirit of the rules."*
