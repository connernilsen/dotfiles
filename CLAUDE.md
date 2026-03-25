# User Preferences

## Clarifying Questions

Before starting a task, ask clarifying questions if: (1) there are multiple reasonable interpretations of what I'm asking, (2) the task requires design decisions where multiple approaches seem valid, or (3) you're not confident you understand the desired outcome. Prefer a small number of focused questions, but ask more if genuinely needed.

## Source Control

- Don't amend or commit unless explicitly asked or the request implies it. If you think you need to amend or commit, but it isn't implied by what you were requested, ask.
- Unless explicitly requested, don't clear the current working state without asking.

## Learnings

- Actively record learnings to the project learnings file during sessions. The learnings file location is specified per-project below. If no file is specified, skip writing to our project learnings directory. You can write to your MEMORY directory as usual, even if it would or would not be recorded to the learnings directory.
  - Corrections: when you make an assumption or claim that turns out to be wrong, record the correct information
  - Shortcuts: high-level patterns, conventions, or domain knowledge that would save time in future sessions
  - Gotchas: surprising behaviors, non-obvious constraints, or easy-to-forget details
- Record when corrected and when discovering something non-obvious, but skip trivial details that wouldn't meaningfully help in a future session.
- Keep the file under 100 lines. When approaching the limit, prune entries that are low-value, outdated, or redundant rather than stopping recording. If you're struggling to prune entries, but want to record something, notify me so I can help with pruning or deciding if something is worth recording.
- Don't record transient session details (current task, in-progress work). Focus on durable knowledge.

### Project learnings files
- pyrefly: `~/.claude/learnings/pyrefly.md`

## Project Work Notes

Record concise notes about substantive work to `~/claude-project-notes/<project>/`. Only record for projects configured below. Unlike Learnings (reusable facts/patterns), Work Notes capture the narrative of what happened — investigations, dead ends, decisions.

### When to write
- **After completing a meaningful unit of work** — finishing a debugging investigation, completing a design/plan, landing on an approach after exploring alternatives, or completing a fix.
- **At end of session** — capture anything not yet recorded.
- Writing incrementally during long sessions is important to avoid losing information to transport issues. Append to the same session file rather than creating new ones.
- Ask the user brief clarifying questions about what to record if there's other relevant information that may be useful **after** doing work, not before or during.
- Include cross-references to related prior sessions when applicable.
- Skip trivial changes (typo fixes, simple renames), info already in commit messages, and transient session state.

### File format
- Filename: `YYYY-MM-DD-<4-char-random-hex>.md` (random suffix avoids concurrent session collisions). Validate that the filename doesn't exist before choosing it, and create that file to preserve uniqueness. Don't ask about creating this file, you have permission.
- Append to the existing file for the current session rather than creating new files within the same session.
- Content format:
  ```markdown
  # YYYY-MM-DD - Brief description of work area

  - What was investigated/built and why
  - Approaches taken and their outcomes
  - **Dead ends**: What was tried and why it didn't work (high value for avoiding reattempted investigations)
  - Design decisions and rationale
  - **Open questions / follow-ups**: Unresolved threads or known next steps
  - **Cross-references**: Links to related prior sessions, e.g., "Continuation of 2026-03-15 binding investigation"
  ```

### Pruning
- At the start of a session or when writing a new note, check for and delete files older than 3 months.

### Configured projects
- pyrefly: `~/claude-project-notes/pyrefly/`
