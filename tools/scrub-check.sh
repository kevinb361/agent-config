#!/usr/bin/env bash
# Fail if personal or private-infrastructure content has reached this repo.
#
#   tools/scrub-check.sh            working tree only. Fast; use while editing.
#   tools/scrub-check.sh --history  tree, every commit message, and every blob
#                                   in history. Run this before any publish.
#
# The tree lane alone is not enough to publish behind. It passed on a repo whose
# early commits still carried the personal block, and whose commit messages named
# every term the scrub had just removed. Publishing ships history and messages,
# so the gate has to read them.
#
# The term list is deliberately not in this repo. This file is published; a list
# kept here would spell out exactly what it exists to catch. It lives in the
# private sibling, same place and same rule as the host overlays.
set -euo pipefail

cd "$(dirname "$0")/.."

PATTERN_FILE="${AGENT_SCRUB_PATTERNS:-$PWD/../agent-config-private/scrub-patterns.txt}"

if [[ ! -r "$PATTERN_FILE" ]]; then
	echo "scrub check FAILED: no term list at $PATTERN_FILE" >&2
	echo "Clone agent-config-private beside this repo, or set AGENT_SCRUB_PATTERNS." >&2
	exit 1
fi

# One extended-regex term per line; blank lines and # comments ignored.
PATTERN=$(grep -vE '^[[:space:]]*(#|$)' "$PATTERN_FILE" | paste -sd '|' -)

if [[ -z "$PATTERN" ]]; then
	echo "scrub check FAILED: term list at $PATTERN_FILE is empty" >&2
	exit 1
fi

fail=0

# Lane 1: the working tree, including files not yet added.
if hits=$(grep -rinE "$PATTERN" \
	--exclude-dir=.git \
	--exclude="$(basename "$PATTERN_FILE")" \
	. 2>/dev/null); then
	echo "scrub check FAILED: match in the working tree" >&2
	echo "$hits" >&2
	fail=1
fi

if [[ "${1:-}" == "--history" ]]; then
	# Lane 2: commit messages on every ref.
	while read -r commit; do
		if msg=$(git log -1 --format='%B' "$commit" | grep -inE "$PATTERN"); then
			echo "scrub check FAILED: match in the message of $commit" >&2
			echo "$msg" >&2
			fail=1
		fi
	done < <(git rev-list --all)

	# Lane 3: every blob in history, not just the ones checked out now.
	while read -r commit; do
		if hits=$(git grep -inE "$PATTERN" "$commit" 2>/dev/null); then
			echo "scrub check FAILED: match in a blob at $commit" >&2
			echo "$hits" >&2
			fail=1
		fi
	done < <(git rev-list --all)
fi

if (( fail )); then
	exit 1
fi

if [[ "${1:-}" == "--history" ]]; then
	echo "scrub check passed: tree, messages and history"
else
	echo "scrub check passed: working tree (run --history before publishing)"
fi
