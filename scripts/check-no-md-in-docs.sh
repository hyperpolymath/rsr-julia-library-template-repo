#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# check-no-md-in-docs.sh — enforce "AsciiDoc by default for general docs".
#
# Estate rule: .adoc for general docs (TOPOLOGY, READINESS, ROADMAP, etc.);
# .md only for files GitHub's community-health rules special-case by name
# (CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, CHANGELOG, etc.) — those live at
# root or in .github/, never under docs/.
#
# Fails if any .md files exist under docs/. Add justified entries to the
# ALLOWED list below if a docs/-rooted .md is genuinely needed (rare).
#
# Exit codes:
#   0 — no .md files under docs/ (or all matches are allow-listed)
#   1 — disallowed .md files found
#   2 — usage / setup error

set -euo pipefail

REPO_ROOT="${1:-.}"
DOCS_DIR="$REPO_ROOT/docs"

# Justified exceptions, relative to repo root. Entries ending in "/" are
# directory prefixes.
# docs/src/ — Julia variant: Documenter.jl sources are Markdown by toolchain
# requirement (Documenter has no AsciiDoc input); the AsciiDoc-by-default rule
# keeps applying to everything else under docs/.
ALLOWED=("docs/src/")

if [ ! -d "$DOCS_DIR" ]; then
    echo "PASS: no docs/ directory (nothing to check)"
    exit 0
fi

mapfile -t HITS < <(find "$DOCS_DIR" -name '*.md' -type f 2>/dev/null | sort)

EXTRAS=()
for hit in "${HITS[@]}"; do
    rel="${hit#"$REPO_ROOT/"}"
    skip=0
    for allowed in "${ALLOWED[@]}"; do
        case "$allowed" in
            */) case "$rel" in "$allowed"*) skip=1; break;; esac ;;
            *)  if [ "$rel" = "$allowed" ]; then skip=1; break; fi ;;
        esac
    done
    if [ $skip -eq 0 ]; then EXTRAS+=("$rel"); fi
done

if [ ${#EXTRAS[@]} -eq 0 ]; then
    echo "PASS: no .md files under docs/ (${#HITS[@]} total found, ${#ALLOWED[@]} allow-listed)"
    exit 0
fi

echo "FAIL: ${#EXTRAS[@]} .md files found under docs/ (estate rule: AsciiDoc by default):" >&2
for e in "${EXTRAS[@]}"; do
    echo "  - $e" >&2
done
echo "" >&2
echo "Convert these to .adoc, or add a justified entry to the ALLOWED list" >&2
echo "in scripts/check-no-md-in-docs.sh." >&2
exit 1
