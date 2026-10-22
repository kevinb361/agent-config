# Vendored: security-audit

| | |
|---|---|
| Upstream | <https://github.com/cloudflare/security-audit-skill>, path `skills/security-audit/` |
| Pinned commit | `c1c8a8c1471069fb0e188eeaff69b8e8db6564a8` (2026-09-14, "Clarify guidance and full audit modes") |
| Vendored | 2026-10-22 |
| License | MIT, Copyright (c) 2025-2026 Cloudflare, Inc. `LICENSE` here is a byte-identical copy of the upstream repository-root `LICENSE` |

## Local changes

Every other file is byte-identical to the pinned upstream, including file modes. The two
validators keep their executable bit.

1. `SKILL.md` frontmatter `description` is narrowed. Full audit mode now needs an explicit
   invocation of this skill by name, or an explicit full audit or pen test of a named
   codebase. A security review of a diff, PR or change stays in guidance mode.
2. `SKILL.md` gains one blockquote line under the H1 that points to `LOCAL-NOTES.md` and to
   this file.
3. `LOCAL-NOTES.md`, `VENDORED.md` and `LICENSE` are added.

No other upstream byte is changed. That covers the body, references, schema, validators and
validator tests.

Original upstream `description`, verbatim:

```text
Security guidance and vulnerability review for codebases, APIs, services, CLI tools, libraries, and daemons. Use for security questions, focused reviews, vulnerability research, security audits, or pen tests. Run the complete workflow only for explicit codebase audit or pen-test requests, full/comprehensive/end-to-end reviews, or requested report artifacts.
```

## Upstream file hashes (sha256, at the pinned commit)

```text
5e3e96a1e438d8f35fef0a1e38f02d4f00e2bdf910401b7dfe00e6779c6dac85  SKILL.md (upstream original; modified here)
e598e694aa506650c7192d5ea3be0e50aca0d356ea00551c53429f0b01eb6391  LICENSE (repository root)
7335a95c43554eadefcf03ece639291bb0e038c398a179299e3887ffe06bd2ef  AI-AND-LLM.md
3ee4f00c6e8c9dcf6dd02dd5ac2a4ceb322e2085f3e9fbe79cf0c6330bc7ef83  ATTACK-CLASSES.md
613f6b98f86083e045525c5b60154ffdab122bac35f1e05eb17488e6e453370c  CLIENT-SIDE.md
3c80f3088be22345e07b057c056d6ed99fe2b0304f794398964f7ccd5a496ca3  CLOUD-AND-DEPLOYMENT.md
307dcb3e24d292715c4a041190e7bb135646a37eb6187619ae01d000a634a4ad  DATA-ISOLATION-AND-LIFECYCLE.md
58eae8ee0ca6a46611c501ec5a3ab47fdff88dd7db0d8d74789bbf8bb19d8cb2  DESKTOP-MOBILE-AND-LOCAL-IPC.md
71c121decea1322c47c718f6e110f1a892980bb4266bd7ac55ef043a213ade09  HUNTING.md
7c8b0dccfb35315cca2455509674d49632b2fe37e1f3aac16c1a496a7e9924a7  MEMORY-SAFETY-AND-BINARY.md
8b73816fa5b3697c9c40977f0c836b40f01d6e81929ff2720fe83ce089e9a619  PROTOCOLS-RPC-AND-MESSAGING.md
02ca887aca84de8ae137f1891bd2f0a54f28d3fa6da92a27f54734382b3381a2  RECONNAISSANCE.md
4326fab5c92a0b4c420a70196254040105cd794026562130b59bf1a6db3e4baa  RESOURCE-EXHAUSTION-AND-AVAILABILITY.md
f372e919940e335468ba1ae09f99026c3986a345f7fe26f8068f132e199f52a5  SUPPLY-CHAIN-AND-RELEASE.md
b892470cb89bb31f33403e050d4bdfbe2cdaef940ade1496fa65e32b2e129449  VALIDATION-AND-REPORTING.md
4f3066dffa23c5635859187be9b96c32f2aff29a688186b91ff0c63e47d62b5c  WEB-PROTOCOL-AND-AUTH.md
6575c9de4a62255699ea052ebf9a49ebfb373a32891bcd89af6f55cc84b35519  report-schema.json
2eb280bd2e33c002916f86db9b29f9edfedb6454e5db973c766290465b868ac8  validate-coverage-ledger.cjs
cfb9df26b03469a4279a70e7664a2a5434dd6f8c2c204e91f9b0aeb9dd71e648  validate-coverage-ledger.test.cjs
e85f232e36bfac0f866f244da50376692d6b45c690beadcb00608b0e6c8b5283  validate-findings.cjs
b92001117a92c4161d43777a0ba2fa182a8a4d97f2304cc8c0cee5331497b73b  validate-findings.test.cjs
```

## Deployment status

The skill is **not** listed in `agent_skills` in `deploy.yml`. It would also not deploy
correctly if it were, because that task copies only `SKILL.md` and this skill depends on its
companion files and validators. Wiring it up means copying the whole directory. Global
install versus per-project install is a separate decision.

## Updating

1. Get the new upstream commit, then read the full upstream diff of `skills/security-audit/`
   and the root `LICENSE` since the pinned commit. Pay particular attention to the
   validators and to execution or safety rules.
2. Copy the upstream files over this directory, then reapply local changes 1 and 2 to the
   new `SKILL.md`. If upstream has changed the mode rules, update `LOCAL-NOTES.md` to match.
3. Update the pin, the date and the hash list above. If the upstream description changed,
   update the original text too.
4. Run `diff -r <upstream>/skills/security-audit skills/security-audit`. It should show only
   the `SKILL.md` description and pointer line, plus `Only in` lines for `LOCAL-NOTES.md`,
   `VENDORED.md` and `LICENSE`. Compare file modes against `git ls-tree` upstream.
5. Do not run the upstream validators or tests as part of an update unless they are inside
   a reviewed execution boundary. They are third-party code; see `LOCAL-NOTES.md`.
