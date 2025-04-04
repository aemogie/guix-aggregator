#!/usr/bin/env -S fish

function escape
  printf "%s" "$1" | string replace '\\' '\\\\'
end

FOCUS=$(river-bedload -print title | jq '.[0].title' | grep senpai | wc -l)
if [ "$HERE" -eq 0 ] || [ $FOCUS -eq 0 ]
  notify-send --urgency=normal --category=Mail "[$BUFFER] $SENDER" "$(escape "$MESSAGE")"
end

mpv ~/.guix-home/profile/share/sounds/freedesktop/stereo/message.oga
