# Memory

## Project Overview
**Superpowers for Command Code** — a port of [Jesse Vincent's Superpowers methodology](https://github.com/obra/superpowers) to run natively on [Command Code](https://commandcode.ai). No runtime code; this is a collection of 15 agent skills (SKILL.md files) plus an install script. Each skill is a markdown instruction set that teaches the AI agent a specific workflow.

The key innovation is `cmd-dispatch`, an adapter skill that bridges subagent dispatch using `cmd -p` headless sessions (since Command Code has no native `Task` tool like Claude Code).

### 15 Skills
| Skill | Purpose |
|-------|---------|
| `brainstorming` | Design-first thinking. No code without design approval. |
| `using-git-worktrees` | Isolated feature workspaces. |
| `writing-plans` | Bite-sized 2-5 min implementation tasks. |
| `subagent-driven-development` | Dispatches `cmd -p` per task + 2-stage review cycle. |
| `test-driven-development` | RED-GREEN-REFACTOR enforcement. |
| `systematic-debugging` | 4-phase root cause process. |
| `dispatching-parallel-agents` | Parallel `cmd -p` background dispatch. |
| `requesting-code-review` | Subagent code review via `cmd -p`. |
| `receiving-code-review` | Evaluate review feedback technically. |
| `executing-plans` | Sequential task execution with checkpoints. |
| `finishing-a-development-branch` | Merge/PR/cleanup workflow. |
| `verification-before-completion` | Evidence before claims. |
| `writing-skills` | Skill authoring methodology. |
| `using-superpowers` | Bootstrap skill; auto-triggers on every session. |
| `cmd-dispatch` | The dispatch bridge: `cmd -p --yolo --max-turns N --trust`. |

## Code Style Guidelines
- Skills are markdown with YAML frontmatter (`name`, `description`, optional `allowed-tools`)
- Follow the existing pattern: frontmatter → H1 heading → procedural instructions
- Use `<HARD-GATE>` for non-negotiable rules
- Descriptive variable names, follow existing patterns, extract complex conditions

## Architecture Notes
- **No `package.json`** — this is not a Node.js project. It's a flat skills directory.
- **install.sh** does two things: `cmd skills add huyphamcs/superpowers-cmd --global --force` then injects bootstrap into `~/.commandcode/AGENTS.md`.
- **Skills are auto-triggered** by the `description` frontmatter. The `using-superpowers` bootstrap teaches the agent to check skills before ANY response.
- **cmd-dispatch** is the only skill that uses `allowed-tools` (restricted to `Bash(cmd:*)`).

## Common Workflows
- **Install globally**: `cmd skills add huyphamcs/superpowers-cmd --global --force` or `curl ... | bash`
- **Install individual skill**: `cmd skills add huyphamcs/superpowers-cmd/skills/<name> --global`
- **Remove a skill**: `cmd skills remove <name> --global`
- **Subagent dispatch**: `cmd -p "$(cat prompt.md)" --yolo --max-turns 15 --trust`
- **Feature workflow**: brainstorming → using-git-worktrees → writing-plans → subagent-driven-dev → TDD → code review → verification → finishing-a-branch
- **Bug fix workflow**: systematic-debugging → TDD (reproduce test) → verification
