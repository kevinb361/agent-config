# agent-config

Portable AI agent configuration, pushed to every box from one repo.

The content is one operator's. `CLAUDE.md` is a working agreement, `profile/` is style,
durable facts and a visual baseline; fork the repo and replace both. What is meant to be
reused is the mechanism: the push model, the rules-directory layout, the removal of the
layers it supersedes, and a gate that keeps personal content out of a repo that gets
published.

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
directory.

Two paths are symlinks anyway, for different reasons:

- `~/.claude/rules/03-memory.md` is deployed as a link to the host's live memory source.
  Runtime memory changes while sessions run, so a copy would be a stale snapshot the
  moment it landed. The cost is real: a desktop session that skips symlinked rules will
  not see memory. The CLI does.
- `~/.agent-profile/MEMORY.md` is never deployed at all. The playbook writes a stub when
  the file is absent and otherwise leaves it alone, so a host that has already pointed it
  at a live memory source keeps that link.

Both are annotated where they happen in `deploy.yml`.

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
  sync-agent-profile           regenerates the Codex instruction snapshot; the
                               playbook does not run it, see below
  scrub-check.sh               fails if personal content reaches the tree,
                               its history or its commit messages
deploy.yml                     the push playbook
inventory.example.ini          example inventory
LICENSE                        MIT
```

`tools/sync-agent-profile` is deliberately outside the deploy. Codex reads one generated
file at `~/.codex/AGENTS.md` rather than a rules directory, so that snapshot goes stale on
a profile change and has to be rebuilt. Run it by hand on hosts that run Codex; hosts that
do not never need it.

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
| `~/.agent-profile/MEMORY.md` | stub if absent | host-local, never tracked, never overwritten |
| `~/private/USER.local.md` | stub if absent | host-local personal context, never tracked |
| `~/.claude/skills/design-baseline/SKILL.md` | real file | `skills/` |

The playbook also **removes** `~/CLAUDE.md`, `~/.claude/CLAUDE.md` and the five rules
files from the previous hand-maintained layout. Leaving any of them in place would load
the profile twice. Everything removed is backed up on the host first, under
`~/.claude/backups/agent-config-<timestamp>/`.

`DESIGN.md` is deployed to the profile directory but is deliberately **not** a rules
file. It is ~240 lines relevant only to UI work; it lives in a skill instead.

## Deploy

```sh
cp inventory.example.ini inventory.ini    # real hostnames; gitignored, never committed

# always look first -- this is also the drift check
ansible-playbook -i inventory.ini deploy.yml --check --diff

ansible-playbook -i inventory.ini deploy.yml --limit dev
```

The control node needs ansible, this repo, and SSH to every target. Targets need none
of those. The playbook uses only `ansible.builtin` modules, so there is no collection to
install and no `requirements.yml` to keep current.

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
tools/scrub-check.sh --history
```

Three lanes: the working tree, every commit message, and every blob in history. The tree
lane on its own is not enough to publish behind. Publishing ships history and messages
too, and a tree-only gate passes a repo whose early commits still carry what the current
tree does not.

The term list is not in this repo. It lives in the private sibling as
`scrub-patterns.txt`, found at `../agent-config-private/scrub-patterns.txt` or via
`AGENT_SCRUB_PATTERNS`. A list kept here would be published, spelling out exactly what it
exists to catch. A missing list fails the gate rather than passing silently.

## Verifying a deploy

```sh
ls -la ~/.claude/rules/                     # exactly the intended set, no leftovers
ansible-playbook -i inventory.ini deploy.yml --check --diff
```

A second run is never reported as fully clean: this run's timestamped backup directory
is always a change. That one aside, every deployed path should come back `ok`. Anything
else reported as changed is drift, and the diff says what moved.

Then start a session and confirm it reports the expected rules and no duplicates. File
listings prove what is on disk; only a real session proves what actually loads.

## License

MIT. The mechanism is the part worth copying; take it and replace the content.
