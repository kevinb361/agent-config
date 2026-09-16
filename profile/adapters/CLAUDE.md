# Claude Code adapter

Harness-specific differences only. The shared working agreement, `SOUL.md` and `USER.md`
carry everything common; do not restate them here.

Claude Code loads this profile from the user rules directory automatically, so there is no
startup ritual to perform — the files are already in context. Project-local `CLAUDE.md`
still wins for project specifics.

- Read the project's `CLAUDE.md` first for project constraints.
- For UI/design work, read the project's `DESIGN.md`; if absent, load the design baseline
  skill rather than assuming a visual style.
- Run the project's finalizer workflow before committing when the project defines one.
- Use project tests and linters before claiming a code change works.
- Use subagents and second opinions for complex troubleshooting or review, but verify their
  claims against files, diffs and tests. A worker's summary is a claim, not a result.
- Skills and slash commands are discovered at runtime. Load the installed ones rather than
  relying on any command list written down here.
