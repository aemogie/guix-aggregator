#!/bin/bash

# Count unread mail from Apple Mail
MAIL_COUNT=$(osascript -e 'tell application "Mail" to get unread count of inbox' 2>/dev/null)

if [ -z "$MAIL_COUNT" ] || [ "$MAIL_COUNT" = "0" ]; then
  LABEL=""
else
  LABEL="$MAIL_COUNT"
fi

sketchybar --set "$NAME" label="$LABEL"
