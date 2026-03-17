#!/usr/bin/env sh

# Toggle terminal overview: move all kitty windows to special:terminals, or return them

STATE_FILE="/tmp/terminal_view_state.txt"
SPECIAL="special:terminals"

if [ -f "$STATE_FILE" ]; then
  # Restore windows to original workspaces
  while IFS= read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    workspace=$(echo "$line" | awk '{print $2}')
    hyprctl dispatch movetoworkspacesilent "$workspace", pid:"$pid"
  done < "$STATE_FILE"
  rm "$STATE_FILE"
  hyprctl dispatch togglespecialworkspace terminals
else
  # Save locations and move all kitty windows (except btop in admin) to special workspace
  > "$STATE_FILE"
  pids=$(hyprctl clients | grep -A5 'class: .*kitty.*' | grep -B9 -v 'workspace: -83 (special:admin)' | grep 'pid' | awk '{print $2}')
  for pid in $pids; do
    original_workspace=$(hyprctl clients | grep -B10 "pid: $pid" | grep "workspace:" | awk '{print $2}')
    echo "$pid $original_workspace" >> "$STATE_FILE"
    hyprctl dispatch movetoworkspacesilent "$SPECIAL", pid:"$pid"
  done
  hyprctl dispatch togglespecialworkspace terminals
fi
