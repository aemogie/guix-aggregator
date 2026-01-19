#!/bin/bash

# This script is triggered by aerospace workspace changes
# and updates all space indicators

# Get current workspace from aerospace
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

# Update all 9 space indicators
for i in {1..9}; do
  if [ "$i" = "$CURRENT_WORKSPACE" ]; then
    # Selected space - full brightness
    sketchybar --set space.$i icon.color=0xffcdd6f4
  else
    # Unselected space - dimmed (50% opacity)
    sketchybar --set space.$i icon.color=0x80cdd6f4
  fi
done
