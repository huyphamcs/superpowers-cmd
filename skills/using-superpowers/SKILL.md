---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use Superpowers skills, requiring skill invocation before ANY response including clarifying questions. This is the bootstrap that teaches Command Code about the Superpowers methodology.
allowed-tools: Bash
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## Instruction Priority

Superpowers skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (AGENTS.md, .commandcode/AGENTS.md, direct requests) — highest priority
2. **Superpowers skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills in Command Code

Superpowers skills are installed as Command Code skills in `~/.agents/skills/*/`. They appear in the system prompt as `<available_skills>` and auto-activate when their description matches your task.

When a skill applies, follow its instructions directly. Skills contain their own checklists — create TodoWrite items for each checklist step.

## Skill Names in Command Code

All Superpowers skills are named after their skill directory:
- `brainstorming` — Design-first thinking, no code without design
- `using-git-worktrees` — Isolated feature workspaces
- `writing-plans` — Bite-sized implementation plans
- `subagent-driven-development` — Dispatch subagents per task
- `test-driven-development` — RED-GREEN-REFACTOR cycle
- `systematic-debugging` — Root cause before fixes
- `dispatching-parallel-agents` — Parallel subagent dispatch
- `requesting-code-review` — Pre-merge review
- `receiving-code-review` — Technical evaluation of feedback
- `executing-plans` — Batch execution with checkpoints
- `finishing-a-development-branch` — Merge/PR/cleanup
- `verification-before-completion` — Evidence before claims

## Using Skills

### The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

### Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (TDD, plans) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

### Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

### Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
