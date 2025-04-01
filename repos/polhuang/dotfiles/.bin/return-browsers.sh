#!/usr/bin/env sh

# File storing the original PIDs and workspaces
temp_file="/tmp/browser_workspaces.txt"

if [ ! -f "$temp_file" ]; then
  echo "No previous workspace data found. Aborting."
  exit 1
fi

# Read the stored data and move each instance back to its original workspace
while read -r address workspace; do
  hyprctl dispatch movetoworkspace "$workspace", address:"0x$address"
done < "$temp_file"

rm "$temp_file"
