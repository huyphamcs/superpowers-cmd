# Superpowers for Command Code

The complete [Superpowers](https://github.com/obra/superpowers) methodology — design-first, TDD, systematic debugging, subagent-driven development — ported to run natively on [Command Code](https://commandcode.ai) with `cmd -p` subagent dispatch.

## One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/huyphamcs/superpowers-cmd/main/install.sh | bash
```

That's it. 14 skills installed, bootstrap injected into `~/.commandcode/AGENTS.md`. Your next `cmd` session has Superpowers.

## Built-In Command Install

Command Code has native skill installation. Install all 14 skills in one shot:

```bash
cmd skills add huyphamcs/superpowers-cmd --global --force
```

This installs every skill. Then add the bootstrap manually:

```bash
cat >> ~/.commandcode/AGENTS.md << 'EOF'

## Superpowers

You have Superpowers installed. Before ANY response or action — including
clarifying questions — check if a superpowers skill applies. If there's even
a 1% chance, invoke the skill.

"Let's build X" → brainstorming first.
"Fix this bug" → systematic-debugging first.
Writing code → test-driven-development.
EOF
```

Or install individual skills:

```bash
cmd skills add huyphamcs/superpowers-cmd/skills/brainstorming --global
cmd skills add huyphamcs/superpowers-cmd/skills/test-driven-development --global
cmd skills add huyphamcs/superpowers-cmd/skills/systematic-debugging --global
cmd skills add huyphamcs/superpowers-cmd/skills/cmd-dispatch --global
```

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
├── using-superpowers/            ← Bootstrap. Auto-triggers on every session.
├── brainstorming/                ← Design-first. No code without approval.
├── using-git-worktrees/          ← Isolated workspaces.
├── writing-plans/                ← Bite-sized implementation plans.
├── subagent-driven-development/  ← Dispatches cmd -p per task + 2-stage review.
├── test-driven-development/      ← RED-GREEN-REFACTOR enforcement.
├── systematic-debugging/         ← 4-phase root cause process.
├── dispatching-parallel-agents/  ← Parallel cmd -p for independent tasks.
├── requesting-code-review/       ← Subagent code review.
├── receiving-code-review/        ← Technical evaluation of feedback.
├── executing-plans/              ← Sequential fallback execution.
├── finishing-a-development-branch/ ← Merge/PR/cleanup workflow.
├── verification-before-completion/ ← Evidence before claims.
├── writing-skills/               ← Skill authoring methodology.
└── cmd-dispatch/                 ← Subagent dispatch adapter (cmd -p bridge)
```

### Subagent Dispatch Bridge

Command Code has no native `Task` tool for subagent dispatch. `cmd-dispatch` bridges this using `cmd -p` headless mode:

```
Claude Code:    Task(description="implement task 3", prompt="...")
Command Code:   cmd -p "$(cat prompt.md)" --yolo --max-turns 15 --trust
```

Each subagent: isolated context, fresh session, turn limits, auto-accept (`--yolo`), two-stage review.

### Skill Auto-Triggering

Skills match based on their `description` frontmatter. The bootstrap teaches the agent to check before *any* response.

| User says | Auto-triggers |
|-----------|---------------|
| "Let's build X" | brainstorming |
| "Fix this bug" | systematic-debugging |
| "Write code for..." | test-driven-development |
| "Review my PR" | requesting-code-review |
| "I'm done" | verification-before-completion |

## Comparison to Original Superpowers

| Feature | Superpowers (Claude Code) | Superpowers for Command Code |
|---------|---------------------------|------------------------------|
| Skills | 13 skills | 14 skills (+ cmd-dispatch) |
| Subagent dispatch | Native `Task` tool | `cmd -p --yolo` headless mode |
| Parallel agents | Native parallel `Task` | Background `cmd -p &` + `wait` |
| Context isolation | Built-in | Self-contained prompt files |
| Two-stage review | Task tool dispatch | Sequential `cmd -p` calls |
| Worktree isolation | Native `EnterWorktree` | `git worktree` commands |
| Install | Plugin marketplace | `cmd skills add` or curl |
| Bootstrap | Plugin auto-load | AGENTS.md injection |
| All workflows | Full preservation | Full preservation |
| Iron Law enforcement | Identical | Identical |

## Installing a Subset

```bash
# Just the core workflow (no subagents needed)
cmd skills add huyphamcs/superpowers-cmd/skills/brainstorming --global
cmd skills add huyphamcs/superpowers-cmd/skills/writing-plans --global
cmd skills add huyphamcs/superpowers-cmd/skills/test-driven-development --global
cmd skills add huyphamcs/superpowers-cmd/skills/systematic-debugging --global
cmd skills add huyphamcs/superpowers-cmd/skills/verification-before-completion --global
cmd skills add huyphamcs/superpowers-cmd/skills/using-superpowers --global
```

## Requirements

- [Command Code](https://commandcode.ai) — `npm i -g command-code` then `cmd login`
- Git
- Unix shell (macOS, Linux, WSL)

## Uninstall

```bash
cmd skills remove brainstorming --global
cmd skills remove cmd-dispatch --global
cmd skills remove dispatching-parallel-agents --global
cmd skills remove executing-plans --global
cmd skills remove finishing-a-development-branch --global
cmd skills remove receiving-code-review --global
cmd skills remove requesting-code-review --global
cmd skills remove subagent-driven-development --global
cmd skills remove systematic-debugging --global
cmd skills remove test-driven-development --global
cmd skills remove using-git-worktrees --global
cmd skills remove using-superpowers --global
cmd skills remove verification-before-completion --global
cmd skills remove writing-plans --global
cmd skills remove writing-skills --global
```

Then remove the Superpowers section from `~/.commandcode/AGENTS.md`.

## License

MIT — [LICENSE](LICENSE)

Original Superpowers skills by [Jesse Vincent](https://blog.fsck.com) / [Prime Radiant](https://primeradiant.com) (MIT). Command Code port and `cmd-dispatch` adapter by Anderson Li.
