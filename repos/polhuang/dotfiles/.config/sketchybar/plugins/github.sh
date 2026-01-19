#!/bin/bash

# GitHub notifications
# Requires GitHub CLI: brew install gh
# Run: gh auth login

if ! command -v gh &> /dev/null; then
  sketchybar --set "$NAME" label=""
  exit 0
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
  sketchybar --set "$NAME" label=""
  exit 0
fi

NOTIFICATIONS=$(gh api notifications --silent 2>/dev/null | jq '. | length')

if [ -z "$NOTIFICATIONS" ] || [ "$NOTIFICATIONS" = "0" ]; then
  LABEL=""
else
  LABEL="$NOTIFICATIONS"
fi

sketchybar --set "$NAME" label="$LABEL"
