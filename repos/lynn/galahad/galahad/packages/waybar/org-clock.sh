#!/usr/bin/env bash
FILE="$HOME/.cache/org-clock-current"

if [[ -s "$FILE" ]]; then
    TEXT=$(cat "$FILE")
    echo "{\"text\": \"$TEXT\", \"tooltip\": \"Org Clock\", \"class\": \"running\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"No active clock\", \"class\": \"idle\"}"
fi
