#!/usr/bin/env bash
set -xeuo pipefail

REPOS_FILE="README.org"
LOCK_FILE="repositories.lock"
REPOS_DIR="repos" # if changed, also remember to change in $REPOS_FILE

# PURGE!!
rm -rf "$REPOS_DIR"
mkdir -p "$REPOS_DIR"
rm -f "$LOCK_FILE"

# the `||` is for when there's no trailing new line, but we still have content in the last line
while IFS='|' read -r first dir url branch _ || [[ -n "$first" ]]; do
  # empty lines and comments allowed
  [[ -z "$dir" || "$first" == \#* ]] && continue

  # echo with no " to strip whitespace
  dir=$(echo $dir | tr -d "[]")
  url=$(echo $url)
  branch=$(echo $branch)

  mkdir -p "$dir"
  if git clone --depth 1 --no-tags --branch "$branch" "$url" "$dir"; then
     hash=$(git -C "$dir" rev-parse HEAD)
     echo "$dir $hash" >> "$LOCK_FILE"
     rm -rf "$dir/.git"
  else
     git show HEAD:"$LOCK_FILE" | grep "$dir" >> "$LOCK_FILE"
     git reset --hard HEAD -- "$dir"
  fi
done <<< $(sed -n '/# BEGIN REPOLIST/,/# END REPOLIST/{//!p}' "$REPOS_FILE")

if ! git diff --quiet -- "$LOCK_FILE"; then
    last_update=$(git log -1 --format=%cd --date=short 2>/dev/null || echo "initial")
    current_date=$(date +%Y-%m-%d)
    commit_title="Update repositories: $last_update to $current_date"
    # get lines starting with `+` or `-`, but skip first two results (---,+++)
    commit_body="$(git diff -- "$LOCK_FILE" | grep '^[\+\-]' | tail -n +3)"
    git add .
    git commit --quiet -m "$commit_title" -m "$commit_body"
    git push origin HEAD
else
    echo all up to date
fi
