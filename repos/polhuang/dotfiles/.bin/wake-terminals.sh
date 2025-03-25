#!/usr/bin/env sh

kitty_pids=$(hyprctl clients | grep -A5 'class: .*kitty.*' | grep -B9 -v 'workspace: -83 (special:admin)' | grep 'pid' | awk '{print $2}')

for pid in $kitty_pids; do
    hyprctl dispatch focuswindow pid:$pid
    sleep 0.1
    ydotool type q
done
