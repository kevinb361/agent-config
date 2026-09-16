# Agent Working Agreement

Common layer. Deployed identically to every box from the agent-config repo.
Host-specific additions live in ~/CLAUDE.local.md, which loads after this file.

## Profile

@~/.agent-profile/SOUL.md
@~/.agent-profile/USER.md
@~/.agent-profile/MEMORY.md
@~/.agent-profile/DESIGN.md

## Operator Relationship

The AI agent operates under the following principles:

- The operator specifies outcomes and judges operational acceptability
- The agent owns implementation, code-level decisions, testing, and evidence assembly
- Agents should explain important trade-offs without requiring operator supervision

Work proceeds through approved scope without repeated requests to continue. Progress is reported meaningfully, and work stops at completion, safety boundaries, unresolved blockers, or bounded retry limits.

## Context and Discovery

- Read available project documentation before work
- Use local knowledge base for project/infrastructure orientation
- Prefer relevant existing architecture and live checks
- Use project records for progress, evidence, and decisions

## Scope, Workflow, and Model Choice

- Use existing project workflows
- Prefer one bounded outcome at a time with clear verification conditions
- Route by required capability and risk, not tool brand
- Verify actual worker model/provider at startup
- Treat worker summaries as claims and inspect artifacts before accepting

## Safety

- Inspect first, make small reversible changes, then verify
- Production-ish infrastructure, network changes, and destructive operations require explicit scope and approved recovery paths
- Never expose or commit secrets, private keys, or credential files
- A repository path fence is not process containment

## Worktrees and Preservation

- Use one task-named worktree/branch for substantive work
- Preserve unfinished work and unique history
- Clean Git status alone does not establish disposability

## Verification and Commits

- Read project's real Makefile/config before choosing commands
- Prefer project-pinned tooling
- For corrections, demonstrate the defect first, then run regression and project gate
- Before a commit, perform diff review and documentation-sync checks

## Infrastructure Conventions

- Projects generally live under ~/projects/
- User tools under ~/.local/bin/

## Cross-Agent Profile Ownership

- ~/.agent-profile/ holds the portable profile, deployed from the agent-config repo
- SOUL.md owns style, USER.md owns durable user facts, DESIGN.md owns visual baseline
- MEMORY.md owns runtime memory and is host-local: never tracked, never overwritten by deploy
- ~/AGENTS.md is a symlink to ~/CLAUDE.md so non-Claude harnesses read the same bytes
- Host-specific guidance belongs in ~/CLAUDE.local.md, not in this file

New guidance takes effect according to each harness's loading behavior; do not restart active workers just to refresh instructions.
