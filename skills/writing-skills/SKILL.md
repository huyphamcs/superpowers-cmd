---
name: writing-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment - skill writing methodology
allowed-tools: Read, Write, Edit, Bash, Grep
---

# Writing Skills

## Overview

**Writing skills IS Test-Driven Development applied to process documentation.**

Skills are stored in `~/.agents/skills/<skill-name>/SKILL.md` with YAML frontmatter containing `name` and `description` fields.

## Skill Anatomy

```markdown
---
name: skill-name
description: Clear description with trigger keywords
allowed-tools: Bash, Read, Write
---

# Skill Title

## Overview
What this skill does and when to use it.

## Core Principles
Non-negotiable rules.

## Process / Checklist
Step-by-step workflow.

## Red Flags
What to watch out for — things that mean you're rationalizing.

## References
Links to supporting files (if any).
```

## Testing Skills

Test skills by using them. Write a prompt that should trigger the skill, then verify the agent follows the skill's workflow exactly. Common test scenarios:

1. **Positive test**: Prompt that should trigger the skill → agent uses it
2. **Negative test**: Prompt that shouldn't trigger → agent doesn't use it
3. **Pressure test**: Agent tries to rationalize skipping → skill prevents it
4. **Edge case**: Ambiguous prompt → agent correctly decides

## Guidelines

- **Be prescriptive** — "MUST" not "should"
- **Be specific** — don't leave room for interpretation
- **Include red flags** — help agents recognize when they're rationalizing
- **Test with pressure** — if an agent can rationalize out of it, it needs strengthening
