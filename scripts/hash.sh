#!/usr/bin/env bash
# Content hash of a binding directory — the rule gtme's `.source.json` and
# index entries use: sha256 over files sorted by slash path, each written as
# path NUL body NUL, excluding .source.json.
set -euo pipefail
dir="${1:?usage: hash.sh <binding-dir>}"
cd "$dir"
{
  while IFS= read -r f; do
    printf '%s\0' "${f#./}"
    cat "$f"
    printf '\0'
  done < <(find . -type f ! -name .source.json | LC_ALL=C sort)
} | shasum -a 256 | cut -d' ' -f1
