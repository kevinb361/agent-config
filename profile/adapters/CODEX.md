# Codex adapter

Harness-specific differences only. The shared working agreement, `SOUL.md` and `USER.md`
carry everything common; do not restate them here.

Repo-local `AGENTS.md` wins for repo specifics.

- Read the repo's `AGENTS.md`, then its `CLAUDE.md`, for project constraints.
- The global `~/.codex/AGENTS.md` bundle is generated from this profile, not hand-written.
  Regenerate it with the profile sync tool and verify with its check mode; never maintain a
  divergent manual copy.
- Prefer read-only analysis for second opinions and reviews unless implementation was
  explicitly requested.
- Use sandboxed or read-only mode for cautious validation when the task allows it.
- Keep scopes tight; do not roam a large repo without a concrete target.
