#!/bin/bash

# Simple calendar showing upcoming events count
# Requires icalBuddy: brew install ical-buddy

if command -v icalBuddy &> /dev/null; then
  EVENTS=$(icalBuddy -n -nc -npn -iep "title,datetime" -ps "| |" -po "datetime,title" -df "" -b "" eventsToday 2>/dev/null | wc -l | xargs)

  if [ "$EVENTS" -gt 0 ]; then
    LABEL="$EVENTS"
  else
    LABEL=""
  fi
else
  LABEL="$(date '+%d')"
fi

sketchybar --set "$NAME" label="$LABEL"
