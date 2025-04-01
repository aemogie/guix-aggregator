#!/usr/bin/env sh

# Temporary file to store original workspaces
temp_file="/tmp/browser_workspaces.txt"

# Clear previous data
> "$temp_file"

addresses=$(hyprctl clients | grep -B9 'class: .*Firefox.*' | grep -B9 -v 'workspace: -83 (special:admin)' | grep 'Window' | awk '{print $2}')

# Move each Firefox client to the browser special workspace and save original workspace
for address in $addresses; do
  original_workspace=$(hyprctl clients | grep -A5 "Window $address" | grep "workspace:" | awk '{print $2}')
  echo "$address $original_workspace" >> "$temp_file"
  hyprctl dispatch movetoworkspace special:browsers, address:"0x$address"
done
