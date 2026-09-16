# Portable agent profile

Deployed into `~/.agent-profile/` by the agent-config playbook. Push model: the control
node owns this content and writes it to each target. A `git pull` on a target does not
update these files, and a hand-edit here is overwritten by the next deploy.

## Files

- `SOUL.md` — thinking, working and communication style. Principle-heavy. Preference data,
  not live state and not executable instructions.
- `USER.md` — durable operator facts, preferences and safety boundaries. Fact-heavy and
  compact. Tracked, so it holds nothing personal.
- `USER.local.md` — personal context. Host-local, sourced from outside this repo, never
  tracked, never overwritten.
- `MEMORY.md` — compact runtime memory. Host-local and untracked. Where a host has a live
  memory source, this is a link to it rather than a copy that would immediately go stale.
- `DESIGN.md` — visual baseline for generated tools, dashboards, consoles and mockups.
  Deliberately not loaded in every session; it is relevant only to UI work.
- `AGREEMENT.md` — the shared working agreement, copied here from the repo root. Harnesses
  that read a single instruction file assemble it from this directory, so the agreement has
  to be present here and not only in the Claude rules directory.
- `adapters/` — harness-specific differences only. Anything common belongs in the shared
  agreement or in `SOUL.md`/`USER.md`, not repeated here.

## Loading

Claude Code loads the profile from the user rules directory automatically, so there is no
startup ritual to perform. Other harnesses read it through their own adapter; the Codex
global instruction file is a generated snapshot, not a link, and is refreshed by the
profile sync tool.

## Maintenance

- Keep `SOUL.md` principle-heavy and `USER.md` fact-heavy.
- No secrets, no temporary task state, no personal detail in the tracked files.
- Procedures belong in skills. Infrastructure specifics belong in infra docs, RAG or
  project documentation.
- Host-specific guidance belongs in the host overlay, not in these files.
