# agent-config

Portable AI agent configuration, pushed to every box from one repo.

## Model

**Push, not pull.** The control node holds this repo and writes real files to each
target. Targets never clone and never pull.

This is forced, not a preference: one target cannot resolve the internal Git host, has
no ansible, and its home is not a Git repository. A pull-based deploy cannot reach it.

Two consequences worth stating plainly:

- `git pull` on a target does **not** update its live profile. The playbook is the only
  update path.
- A hand-edit to a deployed file is overwritten by the next run. In exchange,
  `--check --diff` is a drift detector for free.

Deployed paths are real files rather than symlinks because desktop sessions skip a user
rules directory that is itself a symlink, or a rule file pointing outside the working
directory. There are exactly two deliberate exceptions, both documented in `deploy.yml`.

## Layout

```
CLAUDE.md                      shared working agreement
profile/
  SOUL.md                      thinking, working and communication style
  USER.md                      durable operator facts and preferences
  DESIGN.md                    visual baseline (deployed, but NOT always-on)
  README.md                    what the profile directory is
  adapters/                    harness-specific differences only
skills/
  design-baseline/SKILL.md     the visual baseline, loaded on demand
tools/
  sync-agent-profile           generates the Codex global instruction bundle
  scrub-check.sh               fails if personal content reaches the tracked tree
deploy.yml                     the push playbook
inventory.example.ini          example inventory
```

Host overlays, host backups and the real inventory live in a separate private repo,
cloned beside this one on the control node. They name real infrastructure, so keeping
them out of this repo is what lets it take a public remote without a scrubbing pass or a
public/private split over the same files. `deploy.yml` finds them via
`agent_overlay_root`, which defaults to `../agent-config-private/hosts`.

## What lands on a box

| Path | Type | Source |
|---|---|---|
| `~/.claude/rules/00-soul.md` | real file | `profile/SOUL.md` |
| `~/.claude/rules/01-user.md` | real file | `profile/USER.md` |
| `~/.claude/rules/02-user-local.md` | real file | the target's own `~/private/USER.local.md` |
| `~/.claude/rules/03-memory.md` | symlink | the target's live memory source, where declared |
| `~/.claude/rules/10-agreement.md` | real file | `CLAUDE.md` |
| `~/.claude/rules/11-adapter-claude.md` | real file | `profile/adapters/CLAUDE.md` |
| `~/.claude/rules/20-host.md` | real file | `<private repo>/hosts/<host>/CLAUDE.local.md` |
| `~/AGENTS.md` | real file | `CLAUDE.md`, for non-Claude harnesses |
| `~/.agent-profile/{SOUL,USER,DESIGN,README}.md`, `adapters/` | real files | `profile/` |
| `~/.agent-profile/MEMORY.md` | untouched | host-local, never tracked, never overwritten |
| `~/private/USER.local.md` | untouched | host-local personal context, never tracked |
| `~/.claude/skills/design-baseline/SKILL.md` | real file | `skills/` |

The playbook also **removes** `~/CLAUDE.md`, `~/.claude/CLAUDE.md` and the five rules
files from the previous hand-maintained layout. Leaving any of them in place would load
the profile twice. Everything removed is backed up on the host first, under
`~/.claude/backups/agent-config-<timestamp>/`.

`DESIGN.md` is deployed to the profile directory but is deliberately **not** a rules
file. It is ~240 lines relevant only to UI work; it lives in a skill instead.

## Deploy

```sh
# always look first -- this is also the drift check
ansible-playbook -i inventory.ini deploy.yml --check --diff

ansible-playbook -i inventory.ini deploy.yml --limit dev
```

The control node needs ansible, this repo, and SSH to every target. Targets need none
of those.

## Adding a box

1. In the private repo, `mkdir -p hosts/<name>` and write a `CLAUDE.local.md`. Say what
   is **not** available on that host, not only what is.
2. Add it to the inventory with `agent_host=<name>`, plus `agent_memory_source=<path>`
   if it has a live runtime memory file.
3. `--check --diff`, then apply.

A host with no overlay is a hard failure, not a warning. Shipping the common layer alone
is how a box ends up carrying guidance for tooling it does not have.

## Personal content

Nothing personal is tracked here. Personal context lives in `~/private/USER.local.md` on
each host, is created empty by the playbook when absent, and is never overwritten.

The gate before any publish:

```sh
tools/scrub-check.sh
```

It holds the term list itself rather than spelling it out here, so that documenting the
gate cannot trip it.

## Verifying a deploy

```sh
ls -la ~/.claude/rules/                     # exactly the intended set, no leftovers
ansible-playbook -i inventory.ini deploy.yml --check   # a clean second run means no drift
```

Then start a session and confirm it reports the expected rules and no duplicates. File
listings prove what is on disk; only a real session proves what actually loads.
