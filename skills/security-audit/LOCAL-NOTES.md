# Local notes for the vendored security-audit skill

These notes sit on top of the unchanged upstream skill. Where they are stricter than
`SKILL.md`, they win. They come from one local trial (2026-10-22) of the pinned upstream
version, run static-only against a single application repository.

## When full audit mode may start

Full audit mode needs one of two explicit requests: the user invokes this skill by name for
an audit, or asks for a full security audit or pen test of a **named** codebase. Anything
else is guidance mode. That includes a "security review" of a diff, PR or branch, a request
to check some code for vulnerabilities, and a "comprehensive review" of a change.
Upstream's broader triggers (full, comprehensive or end-to-end reviews, or requested report
artifacts) do not start full mode on their own. If the request is ambiguous, ask.

Guidance mode stays bounded. Answer from the relevant sections, and do not fan out hunters,
critics or verifiers or write audit artifacts.

Having this skill installed or vendored does not authorize a full audit.

## Confirm scope and cost before full mode

Before any reconnaissance agent launches, state these to the requester and get explicit
confirmation:

- the target and its scope;
- the profile (`quick`, `standard` or `deep`);
- a strict agent-invocation budget;
- whether an approved OS sandbox exists (see below);
- the expected cost.

Cost reference: in the one measured trial, a `standard` profile on a repository of about
28 MB used 23 agent invocations, about 1.5M subagent tokens, and about 35 minutes of wall
clock. Parent tokens were not measured. That is one data point, not an estimate or a
guarantee for another target.

Run at most about **8 subagents concurrently**, and record the cap with the budget.

## Static-only runs produce leads, not confirmed findings

Without an approved OS sandbox that provides every control under *Universal execution
safety*, no target code runs. Results are then `needs_validation` leads plus hardening
notes, never `confirmed`, and never carry severity. Present them that way. Setting up such a
sandbox needs its own approval.

## Validation plans

Do not write validation plans that probe live or deployed services, post into real chat or
shared channels, or read credential values. Use a sandboxed dummy fixture or a passive
observation by the owner. This repeats the skill's own rules, which the trial still broke.

## Audience analysis before a self-impact rejection

When the person who triggers an action is also its apparent victim, check who else can
**see** the result before rejecting it as self-impact. Examples are a reply posted in a
shared channel, a group message, or a log that others read. The trial wrongly rejected one
such lead, and independent review caught it.

## Agent role mapping is prompt-level confinement

If the skill's `research` and `general` roles map onto platform agents such as a read-only
Explore agent, removing edit tools does not make that agent a sandbox. Those agents can
still run shell commands. Their write isolation is enforced only by the prompt, so treat it
that way.

## Parent helper tooling needs its own boundary

The workflow invites parent-side helpers: prompt assemblers, coverage-ID calculators,
consolidators and equality checks. The bundled validators count as well, because they are
third-party code. Run any of them only inside a reviewed execution boundary with bounded
memory, no network, a scratch `HOME`/temp/cache, and a finite timeout. Never run them
unbounded on the host. In the trial, unbounded helpers were a process failure.
