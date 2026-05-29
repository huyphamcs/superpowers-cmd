# Command Code Tool Mapping

Skills were originally written for Claude Code. When you encounter tool names
in a skill, map them to Command Code equivalents:

| Claude Code Tool | Command Code Equivalent |
|---|---|
| `Read` | Same — `Read` tool |
| `Bash` | Same — `shell_command` / Bash |
| `Edit` | Same — `edit_file` |
| `Write` | Same — `write_file` |
| `Glob` | Same — `glob` |
| `Grep` | Same — `grep` |
| `TodoWrite` (task tracking) | `todo_write` |
| `Task` (subagent dispatch) | `cmd -p` via `cmd-dispatch` skill |
| `Skill` (skill invocation) | Auto-triggered in system prompt |
| `EnterWorktree` (platform isolation) | `git worktree add` commands |

### Subagent Dispatch (Task → cmd -p)

```
Claude Code:  Task(description="implement task 3", prompt="...")
Command Code: cmd -p "$(cat .commandcode/subagent-prompts/task-3.md)" --yolo --max-turns N --trust
```

See `cmd-dispatch` skill for full dispatch patterns.

### Skill Invocation

Command Code doesn't have an explicit `Skill` tool. Skills are auto-discovered
from `~/.agents/skills/` and `~/.commandcode/skills/`. When a skill says
"invoke the Skill tool" or "use the <skill-name> skill," just follow the
skill's instructions directly — you already have access.

### Worktree Isolation

Command Code has no native `EnterWorktree` tool. Use `git worktree` directly:

```bash
git worktree add .worktrees/feature-name -b feature-name
cd .worktrees/feature-name
```
