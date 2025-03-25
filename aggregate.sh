#!/usr/bin/env bash
set -xeuo pipefail

REPOS_FILE="repositories.txt"
LOCK_FILE="repositories.lock"
REPOS_DIR="repos"

# PURGE!!
rm -rf "$REPOS_DIR"
mkdir -p "$REPOS_DIR"
rm -f "$LOCK_FILE"

# the `||` is for when there's no trailing new line, but we still have content in the last line
while read -r path url branch || [[ -n "$path" ]]; do
  # empty lines and comments allowed
  [[ -z "$path" || "$path" == \#* ]] && continue

  dir="$REPOS_DIR/$path"

  mkdir -p "$dir"
  git clone --depth 1 --no-tags --branch "$branch" "$url" "$dir"

  hash=$(git -C "$dir" rev-parse HEAD)
  echo "$dir $hash" >> "$LOCK_FILE"

  rm -rf "$dir/.git"
done < "$REPOS_FILE"

last_update=$(git log -1 --format=%cd --date=short 2>/dev/null || echo "initial")
current_date=$(date +%Y-%m-%d)
commit_title="Update repositories: $last_update to $current_date"
commit_body="$(git diff --word-diff HEAD -- "$LOCK_FILE" | tail -n +6)"

git add .
git commit --quiet -m "$commit_title" -m "$commit_body" || true
git push origin HEAD
