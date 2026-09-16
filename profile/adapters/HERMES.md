# Hermes adapter

Harness-specific differences only. The shared working agreement, `SOUL.md` and `USER.md`
carry everything common; do not restate them here.

Profile wiring:

- `~/.hermes/SOUL.md` symlinks the canonical `SOUL.md` and is loaded by Hermes as agent
  identity/persona context.
- `~/.hermes/USER.md` symlinks the canonical `USER.md` for portable reference. Hermes' own
  curated memory lives separately at `~/.hermes/memories/USER.md`.
- `~/.hermes/MEMORY.md` symlinks Hermes' compact operational memory at
  `~/.hermes/memories/MEMORY.md`. That file is the runtime source of truth and is never
  tracked or overwritten by a profile deploy.

Behavior:

- Keep curated memories compact. Do not dump the full portable `USER.md` into
  `memories/USER.md` unless the memory limit is intentionally being changed.
- Use the local RAG MCP for indexed project and infrastructure questions before asking the
  operator to repeat context.
- Treat numbered references in the operator's replies as execution selections unless the
  wording clearly says otherwise.
- For coding and repo investigation, route work across the available harnesses according to
  task risk and depth rather than defaulting to one.
