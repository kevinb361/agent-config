# Harness instruction formats

Where each agent harness reads its instructions, so a future change to this repo lands in
the right file rather than a plausible-looking one.

Every row below was checked against that harness's own documentation, or its installed
source, on **2026-09-15**. Versions are the ones that were installed when it was checked.
These formats move; re-verify before trusting this page, and update the date when you do.

The single most common mistake is assuming one harness reads another's file. Almost none
of them do. `~/.claude/rules/` is Claude Code only. `~/AGENTS.md` is read by harnesses
that walk parent directories from the working directory, and not by the ones that start at
the repository root.

## Claude Code

Docs: <https://code.claude.com/docs/en/memory> · <https://code.claude.com/docs/en/claude-directory>

| Scope | Path |
|---|---|
| Managed policy | `/etc/claude-code/CLAUDE.md` (Linux/WSL), `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) |
| User | `~/.claude/CLAUDE.md`, and `~/.claude/rules/*.md` |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md`, and `./.claude/rules/*.md` |
| Project, untracked | `./CLAUDE.local.md` |

- Rules files are discovered recursively. Ones without `paths:` frontmatter load at launch;
  ones with it load only when Claude reads a matching file.
- User-level rules load before project rules, giving project rules higher priority.
- **Order within a rules directory is not specified and is not stable.** Measured with the
  `InstructionsLoaded` hook on Claude Code 2.1.273: four runs on one host produced four
  different orders. The numeric prefixes in this repo group files for a human reading `ls`;
  nothing may depend on them. State precedence in the text of the file.
- `CLAUDE.md` files are concatenated from the filesystem root down to the working
  directory. `@path` imports expand at launch, to a maximum depth of four hops.
- Since 2.1.277 Claude Code also reads `AGENTS.md`, but only when no `CLAUDE.md`,
  `.claude/CLAUDE.md` or `CLAUDE.local.md` sits in or above the working directory;
  `~/.claude/CLAUDE.md` and rules files do not count. Under `$HOME` that is every session,
  because the deploy removes `~/CLAUDE.md`, so `~/AGENTS.md` loaded on top of the identical
  `10-agreement.md` rule. The deploy now adds `~/AGENTS.md` to `claudeMdExcludes` in
  `~/.claude/settings.json`; the setting takes absolute paths and applies to `AGENTS.md`.
  Verified against the memory docs and `/context` on 2.1.314, 2026-10-30.
- Cowork desktop sessions skip a `~/.claude/CLAUDE.md` that is itself a symlink, and a
  symlinked rules directory or rule file pointing outside the working directory. The CLI
  loads them normally. This is why everything here is deployed as a real file.
- Target under 200 lines per file. Files over 4 MiB are skipped entirely.
- Skills live at `~/.claude/skills/<name>/SKILL.md`, frontmatter between `---` markers,
  `description` being the field that decides when the skill is used.

## Codex

Docs: <https://learn.chatgpt.com/docs/agent-configuration/agents-md.md> · installed `codex-cli 0.153.4`

| Scope | Path |
|---|---|
| Global | `~/.codex/AGENTS.override.md`, else `~/.codex/AGENTS.md` (`CODEX_HOME` moves this) |
| Project | `AGENTS.override.md`, then `AGENTS.md`, then any `project_doc_fallback_filenames`, in each directory |

- The project walk starts at the **project root (typically the git root)** and goes down to
  the working directory — it does not walk up past the repo, so a `~/AGENTS.md` outside the
  repo is not picked up.
- Files are concatenated root-down, joined by blank lines. Files closer to the working
  directory win because they appear later in the prompt.
- Only the first matching filename per directory is used.
- **Size cap**: Codex stops adding files once the combined size reaches
  `project_doc_max_bytes`, 32 KiB by default. A bundle that grows past this silently loses
  its tail.
- The instruction chain is built once per run, so edits mid-session are not picked up.
- Because Codex reads a **single** global file, that file has to carry everything the
  Claude rules directory carries as separate files. In this repo it is generated on the
  target by `tools/sync-agent-profile` from `~/.agent-profile/`, and the generator refuses
  to write a bundle over the 32 KiB budget rather than letting Codex drop the tail.

## Pi

Docs: `docs/usage.md` and `README.md` in the installed package · installed `@earendil-works/pi-coding-agent 0.85.1`

| Scope | Path |
|---|---|
| Global | `~/.pi/agent/AGENTS.md` |
| Project | parent directories walking up from the working directory, plus the working directory |

- Reads `AGENTS.md` **or** `CLAUDE.md`. All matching files are concatenated.
- A directory containing `AGENTS.override.md` uses that instead of `AGENTS.md` or
  `CLAUDE.md` for that directory; other directories still contribute.
- Because it walks up from the working directory, `~/AGENTS.md` is picked up for any work
  under `$HOME` — and missed everywhere else. The global path is the reliable one.
- `--no-context-files` / `-nc` disables discovery entirely.
- Separate mechanism: the system prompt itself can be replaced by `~/.pi/agent/SYSTEM.md`
  (global) or `.pi/SYSTEM.md` (project), or extended with `APPEND_SYSTEM.md`. That replaces
  the agent's own prompt rather than adding context. This repo does not use it.

## opencode

Docs: <https://opencode.ai/docs/rules/>

| Scope | Path |
|---|---|
| Global | `~/.config/opencode/AGENTS.md`, falling back to `~/.claude/CLAUDE.md` |
| Project | `AGENTS.md`, falling back to `CLAUDE.md` |

- Lookup order is: local files walking up from the working directory, then the global file,
  then the Claude Code file. The first match **in each category** wins, so a local
  `AGENTS.md` suppresses a local `CLAUDE.md` but not the global file.
- It does **not** read `~/.claude/rules/`. A deploy that removes `~/.claude/CLAUDE.md`
  without writing `~/.config/opencode/AGENTS.md` leaves opencode with no global
  instructions at all.
- `opencode.json` has an `instructions` key taking paths, glob patterns and remote URLs.
- The Claude Code fallbacks can be switched off with `OPENCODE_DISABLE_CLAUDE_CODE`,
  `OPENCODE_DISABLE_CLAUDE_CODE_PROMPT` and `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS`.

## Hermes

Source: `~/.hermes/hermes-agent/agent/prompt_builder.py` on an installed host

| Scope | Path |
|---|---|
| Profile | `$HERMES_HOME/SOUL.md` |
| Profile memory | `$HERMES_HOME/memories/MEMORY.md` and `memories/USER.md` |
| Project | `AGENTS.override.md`, `AGENTS.md`, `agents.md` up the directory chain |
| Project, Claude | `CLAUDE.md` or `claude.md`, **working directory only** |
| Project, Cursor | `.cursorrules` and `.cursor/rules/*.mdc`, working directory only |

- `HERMES_HOME` defaults to `~/.hermes`, but the dispatcher sets it **per worker profile**
  to `~/.hermes/profiles/<name>/`. A worker therefore reads that profile's own `SOUL.md`,
  not the one in `~/.hermes/`. Fixing the top-level file alone does not reach workers.
- Keep each profile's `SOUL.md` a symlink to the canonical profile copy. Real files there
  drift silently and nothing reports it.
- Not every profile file is meant to be the operator profile. A harness-specific persona is
  a legitimate thing to find in a profile home; check the content before replacing it.
- Identical content repeated along the directory chain is deduplicated, and the merged
  chain is capped, so a deep tree cannot multiply the budget.

## The AGENTS.md convention

Docs: <https://agents.md>

Plain Markdown at the repository root, no required frontmatter, nested files supported with
the nearest one taking precedence. Stewarded by the Agentic AI Foundation under the Linux
Foundation, and claimed by 20+ agents.

Treat the list of supporting agents as a claim to verify, not a fact. Claude Code's
documentation said it read `CLAUDE.md` and not `AGENTS.md` until 2.1.277 changed that, so
re-check a vendor's docs rather than this table. Where a vendor's documentation and this
convention disagree, the vendor's wins.

## Adding a harness to the deploy

1. Find its global instruction path in its own docs, not by analogy with another tool.
2. Check whether it walks **up** from the working directory or **down** from a repo root.
   Only the first kind ever sees `~/AGENTS.md`, and then only under `$HOME`.
3. Check for a size cap before assuming a large bundle arrives intact.
4. Add the directory to `agent_harness_dirs` in `deploy.yml`. The play writes the file only
   where that directory already exists, so a host without the harness is untouched.
5. Record what you verified, and when, in the table above.
