#!/usr/bin/env bash
set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo -e "${CYAN}  Superpowers for Command Code — Installer${NC}"
echo -e "${CYAN}═══════════════════════════════════════════${NC}"
echo ""

# ── Step 1: Install all 14 skills ──────────────────────────
echo -e "📦 Installing 14 skills from GitHub..."
if cmd skills add huyphamcs/superpowers-cmd --global --force 2>&1; then
    echo -e "${GREEN}✓ All 14 skills installed${NC}"
else
    echo -e "${RED}✗ Some skills failed to install. Check output above.${NC}"
    echo "  You can retry: cmd skills add huyphamcs/superpowers-cmd --global --force"
    exit 1
fi

echo ""

# ── Step 2: Add bootstrap to AGENTS.md ─────────────────────
AGENTS_FILE="${HOME}/.commandcode/AGENTS.md"
BOOTSTRAP_MARKER="## Superpowers"

if [ ! -f "$AGENTS_FILE" ]; then
    mkdir -p "$(dirname "$AGENTS_FILE")"
fi

if grep -qF "$BOOTSTRAP_MARKER" "$AGENTS_FILE" 2>/dev/null; then
    echo -e "${GREEN}✓ Bootstrap already present in AGENTS.md${NC}"
else
    echo -e "🔧 Adding bootstrap to ${AGENTS_FILE}..."
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
    echo -e "${GREEN}✓ Bootstrap added${NC}"
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Superpowers installed successfully!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo -e "Your next ${CYAN}cmd${NC} session will have Superpowers."
echo ""
echo -e "Try it:  ${CYAN}cmd${NC}  →  \"let's build a todo app\""
echo -e "  (brainstorming will auto-trigger before any code is written)"
echo ""
