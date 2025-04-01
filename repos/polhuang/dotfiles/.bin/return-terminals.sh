#!/usr/bin/env sh

# Temporary file with saved original workspaces
temp_file="/tmp/kitty_workspaces.txt"

# Read the file line by line
if [ -f "$temp_file" ]; then
  while IFS= read -r line; do
    pid=$(echo $line | awk '{print $1}')
    original_workspace=$(echo $line | awk '{print $2}')
    
    # Move the client back to its original workspace
    hyprctl dispatch movetoworkspace $original_workspace, pid:$pid
  done < "$temp_file"

else
  echo "No saved original workspaces to restore."
fi
