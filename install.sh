#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.agents/skills"
AGENTS_FILE="${HOME}/.commandcode/AGENTS.md"
BOOTSTRAP_MARKER="## Superpowers"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Superpowers for Command Code ==="
echo ""

# Create skills directory if needed
mkdir -p "$SKILLS_DIR"

# Install all skills
echo "Installing skills..."
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    if [ -f "${skill_dir}SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        rm -rf "${SKILLS_DIR}/${skill_name}"
        cp -r "$skill_dir" "${SKILLS_DIR}/${skill_name}"
        echo "  ✓ ${skill_name}"
    fi
done

# Add bootstrap to AGENTS.md
if [ -f "$AGENTS_FILE" ]; then
    if grep -qF "$BOOTSTRAP_MARKER" "$AGENTS_FILE"; then
        echo ""
        echo "Bootstrap already present in ${AGENTS_FILE}"
    else
        echo ""
        echo "Adding bootstrap to ${AGENTS_FILE}..."
        cat >> "$AGENTS_FILE" << 'BOOTSTRAP'

## Superpowers

You have Superpowers installed. Before ANY response or action — including
clarifying questions — check if a superpowers skill applies. If there's even
a 1% chance, invoke the skill.

### Available Superpowers Skills

- **brainstorming** — Design-first thinking before ANY creative work. No code without design approval.
- **using-git-worktrees** — Isolated feature workspaces via git worktrees.
- **writing-plans** — Bite-sized implementation plans (2-5 min tasks) from approved designs.
- **subagent-driven-development** — Fresh cmd -p subagent per task with two-stage review.
- **test-driven-development** — RED-GREEN-REFACTOR cycle. No production code without failing test first.
- **systematic-debugging** — 4-phase root cause process. No fixes without investigation.
- **dispatching-parallel-agents** — Parallel cmd -p subagents for independent tasks.
- **requesting-code-review** — Subagent code review via cmd -p.
- **receiving-code-review** — Technical evaluation of review feedback. Verify before implementing.
- **executing-plans** — Sequential task execution with checkpoints.
- **finishing-a-development-branch** — Merge/PR/cleanup workflow after implementation completes.
- **verification-before-completion** — Evidence before claims. Always verify before saying "done".

### The Rule

Skills check BEFORE any action. Not optional. Not negotiable.

"Let's build X" → brainstorming first.
"Fix this bug" → systematic-debugging first.
Writing code → test-driven-development.

### Subagents

Dispatch subagents via `cmd -p` for isolated task execution. See `cmd-dispatch` for the dispatch pattern.

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
BOOTSTRAP
        echo "  ✓ Bootstrap added"
    fi
else
    echo ""
    echo "Creating ${AGENTS_FILE}..."
    mkdir -p "$(dirname "$AGENTS_FILE")"
    cat > "$AGENTS_FILE" << 'BOOTSTRAP'
## Superpowers

You have Superpowers installed. Before ANY response or action — including
clarifying questions — check if a superpowers skill applies. If there's even
a 1% chance, invoke the skill.

### Available Superpowers Skills

- **brainstorming** — Design-first thinking before ANY creative work. No code without design approval.
- **using-git-worktrees** — Isolated feature workspaces via git worktrees.
- **writing-plans** — Bite-sized implementation plans (2-5 min tasks) from approved designs.
- **subagent-driven-development** — Fresh cmd -p subagent per task with two-stage review.
- **test-driven-development** — RED-GREEN-REFACTOR cycle. No production code without failing test first.
- **systematic-debugging** — 4-phase root cause process. No fixes without investigation.
- **dispatching-parallel-agents** — Parallel cmd -p subagents for independent tasks.
- **requesting-code-review** — Subagent code review via cmd -p.
- **receiving-code-review** — Technical evaluation of review feedback. Verify before implementing.
- **executing-plans** — Sequential task execution with checkpoints.
- **finishing-a-development-branch** — Merge/PR/cleanup workflow after implementation completes.
- **verification-before-completion** — Evidence before claims. Always verify before saying "done".

### The Rule

Skills check BEFORE any action. Not optional. Not negotiable.

"Let's build X" → brainstorming first.
"Fix this bug" → systematic-debugging first.
Writing code → test-driven-development.

### Subagents

Dispatch subagents via `cmd -p` for isolated task execution. See `cmd-dispatch` for the dispatch pattern.

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
BOOTSTRAP
    echo "  ✓ AGENTS.md created with bootstrap"
fi

echo ""
echo "=== Installation complete ==="
echo ""
echo "Skills installed to: ${SKILLS_DIR}"
echo "Bootstrap in:        ${AGENTS_FILE}"
echo ""
echo "Your next Command Code session will have Superpowers."
echo "Try: 'cmd' and say 'let's build a todo app' — brainstorming will auto-trigger."
