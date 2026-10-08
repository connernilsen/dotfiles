# User Preferences

## Writing Code

- Be terse with comments.
- Be selective about when to add comments. Simple or self-explanatory code does not need comments.
- Self-review every non-trivial implementation (see Self-Review).
- **Prove checks can fail.** Before trusting a new test or repro, show it fails without the change. Before trusting a clean result, confirm the check ran: test count above zero, target resolved, relevant diagnostic severities visible, exit code from the right process (not the last stage of a pipe).
- Build after any rebase or merge before reviewing or editing. A clean merge can still fail to compile.
- After changing behavior, re-read nearby comments, docs, and the commit summary for claims that are no longer true.
- Before reporting a regression, rule out flakiness: re-run serially or in isolation, and for perf, compare against a noise floor.

## Self-Review

When the main implementation is done and you're about to run the final round of testing:

1. **Launch a reviewer.** Use a fresh sub-agent (not a fork) so it reviews without your assumptions. Give it the task's intent, how to view the diff, and the relevant project rules. It must be read-only, and it must report each finding with `file:line`, a severity (see Reviewing Changes), and a concrete failure scenario. Ask it to also flag tests that would pass without the change, and comments or summary claims the diff no longer supports.
2. **Test in parallel.** Start the final tests right after launching the reviewer. Don't wait for it.
3. **Triage each finding.** Check it against the code yourself. Decide whether it's real and whether the severity is right, and change the severity if it isn't.
4. **Act:**
   - Fix without asking: real **High** issues with a clear fix that stays within the task's scope.
   - Ask me first: **Medium**/**Low** issues, and any High issue whose fix changes the design, expands scope, or has several reasonable approaches.
   - If you made fixes, re-run the affected tests.
5. **Report.** End with a short write-up. For each finding, give a one-line description, its severity (and what the reviewer said, if you changed it), your verdict (real, or dismissed and why), and the outcome (fixed / waiting on my input / no action). Keep dismissed findings to one line each.

Skip self-review for trivial changes (one-line fixes, comment- or doc-only edits).

## Reviewing Changes

- Give a severity with each issue found:
  - **High**: correctness bugs, crashes, regressions, security issues, or violations of explicit requirements.
  - **Medium**: edge-case bugs, missing tests for new behavior, or maintainability problems a reviewer would block on.
  - **Low**: style, naming, nits, minor simplifications.

## Clarifying Questions

Before starting a task, ask clarifying questions if: (1) there are multiple reasonable interpretations of what I'm asking, (2) the task requires design decisions where multiple approaches seem valid, or (3) you're not confident you understand the desired outcome. Prefer a small number of focused questions, but ask more if genuinely needed.

Before implementing, check whether the behavior or test already exists and whether the request's premise holds.

## Source Control

- Don't amend or commit unless explicitly asked or the request implies it. If you think you need to amend or commit, but it isn't implied by what you were requested, ask. Requests to rebase, review, or address comments don't imply permission to amend.
- In a stack, confirm which commit you're on and which commit the change belongs to before editing.
- Unless explicitly requested, don't clear the current working state without asking.

## Critical Thinking and Uncertainty

**Don't blindly agree with me.** I'm not always right, and sycophantic agreement leads to worse outcomes. Instead:

- **Challenge flawed ideas** - If my proposed approach has problems, say so directly. Explain why and suggest alternatives.
- **Question assumptions** - If I'm making assumptions that seem incorrect or incomplete, push back.
- **Point out tradeoffs** - If I'm focused on one aspect while ignoring downsides, highlight them.
- **Disagree when warranted** - A respectful "I don't think that's the best approach because..." is far more valuable than "Great idea!"
- **Verify claims that matter** - If I assert something about the codebase or a technical concept that would meaningfully affect the approach, verify it rather than taking my word for it. Apply the same standard to your own conclusions and to reviewer claims: when running something is cheap, do that instead of reasoning from reading alone.
- **Admit uncertainty** - If you don't know something, say so. Don't guess and present it as fact. When unsure about facts, API behavior, or codebase details, indicate your uncertainty and attempt to verify.
- **Revisit agreed plans** - If new information during implementation changes the picture, flag it even if we already agreed on an approach. Don't stay committed to a plan that no longer makes sense.

The goal is to arrive at the best solution, not to validate my initial thinking. Honest disagreement and critical analysis are always welcome.

## Learnings

- Actively record learnings to the project learnings file during sessions. The learnings file location is specified per-project below. If no file is specified, skip writing to our project learnings directory. You can write to your MEMORY directory as usual, even if it would or would not be recorded to the learnings directory.
  - Corrections: when you make an assumption or claim that turns out to be wrong, record the correct information
  - Shortcuts: high-level patterns, conventions, or domain knowledge that would save time in future sessions
  - Gotchas: surprising behaviors, non-obvious constraints, or easy-to-forget details
- Record when corrected and when discovering something non-obvious, but skip trivial details that wouldn't meaningfully help in a future session.
- Keep each file under ~40KB (entries are dense paragraphs, so a line count is not a useful size limit). When approaching the limit, prune entries that are low-value, outdated, or redundant rather than stopping recording. If you're struggling to prune entries, but want to record something, notify me so I can help with pruning or deciding if something is worth recording.
- When a project has several learnings files, write to the one whose domain matches, and don't let an entry from one domain crowd out another's. If a file is over budget and everything in it is still load-bearing, that's a signal to split it by domain rather than to prune — ask me first.
- Don't record transient session details (current task, in-progress work). Focus on durable knowledge.

### Project learnings files
- pyrefly (codebase: type checker, language server, builds and tests): `~/.claude/learnings/pyrefly.md`
- pyrefly (VS Code extension in `lsp/` and its nuclide E2E tests): `~/.claude/learnings/pyrefly-vscode.md`
- pyrefly (OSS adoption scouting and outreach): `~/.claude/learnings/pyrefly-oss-adoption.md`
- pyrefly (rollout dashboard, `nest/apps/pyrefly_fbcode_rollout_dash`): `~/.claude/learnings/pyrefly-rollout-dash.md`

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
