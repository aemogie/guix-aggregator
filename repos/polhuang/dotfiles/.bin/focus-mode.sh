#!/usr/bin/env sh
mkdir -p ~/.cache/hypr

STATE_FILE="$HOME/.cache/hypr/focus_window"

# get current active window info
active=$(hyprctl activewindow -j)
addr=$(echo "$active" | jq -r '.address')
ws_name=$(echo "$active" | jq -r '.workspace.name')

# sanity check - no active window
[[ "$addr" == "null" || -z "$addr" ]] && exit 0

# check if we're currently IN special:focus
if [[ "$ws_name" == "special:focus" ]]; then
  # if focus mode then restore
  if [[ -f "$STATE_FILE" ]]; then
    read saved_addr saved_ws < "$STATE_FILE"
    hyprctl dispatch movetoworkspace "$saved_ws",address:"$saved_addr"
    hyprctl dispatch workspace "$saved_ws"
    rm -f "$STATE_FILE"
  fi
else
  # if not in focus mode then enter it
  echo "$addr $ws_name" > "$STATE_FILE"
  hyprctl dispatch movetoworkspace special:focus,address:"$addr"
  hyprctl dispatch workspace special:focus
fi
