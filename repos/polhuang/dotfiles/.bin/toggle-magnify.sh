#!/usr/bin/env sh

# Get active window info
win=$(hyprctl activewindow -j)

# Check floating state
floating=$(echo "$win" | jq -r '.floating')

if [ "$floating" = "true" ]; then
    # Restore
    hyprctl dispatch togglefloating
else
    # Magnify
  hyprctl dispatch togglefloating
  hyprctl dispatch resizeactive exact 75% 75%
  hyprctl dispatch centerwindow
fi
