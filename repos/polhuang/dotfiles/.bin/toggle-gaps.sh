#!/usr/bin/env sh

# File to store current state
STATE_FILE="/tmp/hyprland_gaps_state"

# Get current workspace name
WS=$(hyprctl activeworkspace -j | jq -r '.name')

# Default values
DEFAULT="20 800"
ALT="20 20"

# Read current state (default to DEFAULT if unknown)
CURRENT=$(grep "^$WS:" "$STATE_FILE" 2>/dev/null | cut -d':' -f2)
[ -z "$CURRENT" ] && CURRENT="$DEFAULT"

# Toggle value
if [[ "$CURRENT" == "$DEFAULT" ]]; then
  NEW="$ALT"
else
  NEW="$DEFAULT"
fi

# Apply new gapsout
hyprctl dispatch exec "hyprctl keyword workspace \"$WS\", gapsout:$NEW"

# Save new state
grep -v "^$WS:" "$STATE_FILE" > "$STATE_FILE.tmp"
echo "$WS:$NEW" >> "$STATE_FILE.tmp"
mv "$STATE_FILE.tmp" "$STATE_FILE"
