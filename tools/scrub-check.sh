#!/usr/bin/env bash
# Fail if personal content has reached the tracked, publishable tree.
#
# Run before any publish, and after any edit to profile/USER.md.
#
# Scope: the whole tracked tree. Host overlays and host backups live in the
# private sibling repo, so nothing here is exempt.
#
# This script excludes itself. A gate that matches its own pattern definition
# reports a failure on correct content, which makes it useless.
set -euo pipefail

cd "$(dirname "$0")/.."

# Personal terms that must never appear in the shared layer.
PATTERN='REDACTED -- list moved to agent-config-private/scrub-patterns.txt'

if hits=$(grep -rinE "$PATTERN" \
	--exclude-dir=.git \
	--exclude="$(basename "$0")" \
	. 2>/dev/null); then
	echo "scrub check FAILED: personal content in the tracked tree" >&2
	echo "$hits" >&2
	exit 1
fi

echo "scrub check passed"
