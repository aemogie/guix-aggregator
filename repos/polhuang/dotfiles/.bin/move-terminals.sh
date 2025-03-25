#!/usr/bin/env sh

# Temporary file to store original workspaces
temp_file="/tmp/kitty_workspaces.txt"

# Clear previous data
> "$temp_file"

pids=$(hyprctl clients | grep -A5 'class: .*kitty.*' | grep -B9 -v 'workspace: -83 (special:admin)' | grep 'pid' | awk '{print $2}')

# Move each "kitty" client to the "aquarium" workspace and save original workspace
for pid in $pids; do
  original_workspace=$(hyprctl clients | grep -B10 "pid: $pid" | grep "workspace:" | awk '{print $2}')
  echo "$pid $original_workspace" >> "$temp_file"
  hyprctl dispatch movetoworkspace special:aquarium, pid:$pid
done
#+end_src
