#!/usr/bin/env bash
set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}══════════════════════════════════════════════${NC}"
echo -e "${CYAN}  Superpowers for Command Code — Uninstaller ${NC}"
echo -e "${CYAN}══════════════════════════════════════════════${NC}"
echo ""

SKILLS=(
  brainstorming
  using-git-worktrees
  writing-plans
  subagent-driven-development
  test-driven-development
  systematic-debugging
  dispatching-parallel-agents
  requesting-code-review
  receiving-code-review
  executing-plans
  finishing-a-development-branch
  verification-before-completion
  writing-skills
  using-superpowers
  cmd-dispatch
)

# ── Step 1: Remove all 15 skills ─────────────────────────
echo "🗑️  Removing 15 Superpowers skills..."
REMOVED=0
FAILED=0

for skill in "${SKILLS[@]}"; do
  if cmd skills remove "$skill" --global --yes 2>&1; then
    REMOVED=$((REMOVED + 1))
  else
    echo -e "${RED}  ⚠ Failed to remove skill: $skill (may not be installed)${NC}"
    FAILED=$((FAILED + 1))
  fi
done

echo ""
echo -e "${GREEN}✓ Removed ${REMOVED}/${#SKILLS[@]} skills${NC}"
if [ "$FAILED" -gt 0 ]; then
  echo -e "  ${FAILED} skill(s) were not installed — nothing to remove"
fi

echo ""

# ── Step 2: Remove bootstrap from AGENTS.md ────────────
AGENTS_FILE="${HOME}/.commandcode/AGENTS.md"
BOOTSTRAP_MARKER="## Superpowers"

if [ -f "$AGENTS_FILE" ] && grep -qF "$BOOTSTRAP_MARKER" "$AGENTS_FILE" 2>/dev/null; then
  echo "🧹 Removing Superpowers bootstrap from ${AGENTS_FILE}..."

  # Remove everything from "## Superpowers" through the "EOF" of the bootstrap block.
  # The bootstrap section starts with "## Superpowers" and ends at the blank line
  # before whatever follows (or end of file).
  TMPFILE=$(mktemp)
  awk '
    BEGIN { skip = 0; blank = 0 }
    /^## Superpowers$/ { skip = 1; next }
    skip && /^$/        { blank++; if (blank >= 1) next }
    skip && blank >= 1 && /^./ { skip = 0; blank = 0 }
    !skip { print }
    END { if (skip) { } }
  ' "$AGENTS_FILE" > "$TMPFILE"

  # Clean up leading blank lines left by removal
  awk 'BEGIN { empty=0 } NF { if (empty) { print ""; empty=0 } print; next } { empty++ }' "$TMPFILE" > "${TMPFILE}.clean"
  mv "${TMPFILE}.clean" "$AGENTS_FILE"
  rm -f "$TMPFILE" "${TMPFILE}.clean"

  echo -e "${GREEN}✓ Bootstrap removed${NC}"
else
  echo -e "  Bootstrap not found in AGENTS.md — nothing to remove"
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Superpowers uninstalled successfully!${NC}"
echo -e "${GREEN}══════════════════════════════════════════════${NC}"
echo ""
echo "Skills are removed. Your next cmd session runs without Superpowers."
echo ""
echo "Reinstall anytime:"
echo "  curl -fsSL https://raw.githubusercontent.com/huyphamcs/superpowers-cmd/main/install.sh | bash"
