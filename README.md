# agent-config

Portable AI agent configuration, deployed to every box from one repo.

## Layout

```
CLAUDE.md                      common working agreement, deployed to every box
profile/
  SOUL.md                      thinking and working style
  USER.md                      durable operator facts and preferences
  DESIGN.md                    visual baseline for generated UI
hosts/
  <hostname>/CLAUDE.local.md   host-specific overlay, loads after CLAUDE.md
deploy.yml                     Ansible deploy
inventory.example.ini          example inventory
```

## What lands on a box

| Path | Type | Source |
|---|---|---|
| `~/git/agent-config` | clone | this repo |
| `~/CLAUDE.md` | symlink | `repo/CLAUDE.md` |
| `~/AGENTS.md` | symlink | `~/CLAUDE.md` |
| `~/CLAUDE.local.md` | symlink | `repo/hosts/<host>/CLAUDE.local.md` |
| `~/.agent-profile/SOUL.md` | symlink | `repo/profile/SOUL.md` |
| `~/.agent-profile/USER.md` | symlink | `repo/profile/USER.md` |
| `~/.agent-profile/DESIGN.md` | symlink | `repo/profile/DESIGN.md` |
| `~/.agent-profile/MEMORY.md` | real file | created empty, never tracked, never overwritten |

Because every deployed path is a symlink into the clone, `git pull` in
`~/git/agent-config` updates the live profile. The playbook is only needed for
the first deploy or when the set of linked files changes.

## Deploy

```sh
ansible-playbook -i inventory.ini deploy.yml
ansible-playbook -i inventory.ini deploy.yml --limit dev --check --diff
```

## Adding a box

1. `mkdir -p hosts/<hostname>` and add a `CLAUDE.local.md`
2. Add the host to the inventory with `agent_host=<hostname>`
3. Run the playbook

A host with no overlay directory gets the common layer only and the playbook
says so rather than failing.

## How these files get loaded

Claude Code reads `CLAUDE.md` and `CLAUDE.local.md` from the working directory
and every parent up to root, concatenating them root-first so the file closest
to where you launched is read last. It does **not** read arbitrary `.md` files,
which is why `CLAUDE.md` pulls the profile in with `@` imports rather than
relying on the files merely existing. Import depth is capped at four hops; this
repo uses one.

`~/CLAUDE.md` loads via the parent-directory walk, so it applies to anything
under `/home/<user>` and to nothing outside it. Work launched from `/srv`,
`/opt`, or a mounted share gets no profile. The cwd-independent location is
`~/.claude/CLAUDE.md` — if you move there, keep it a real file, since Cowork
desktop sessions skip a `~/.claude/CLAUDE.md` that is itself a symlink.

## Verifying a deploy

```sh
ls -l ~/CLAUDE.md ~/AGENTS.md ~/CLAUDE.local.md ~/.agent-profile/
```

Then from a project directory run `/memory` inside Claude Code and confirm all
four profile files appear. `~/.agent-profile/` is outside the working directory,
so the imports may require approving external imports once per project.
