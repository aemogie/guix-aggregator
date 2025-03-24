#!/usr/bin/env -S fish

function escape
  printf "%s" "$1" | string replace '\\' '\\\\'
end

notify-send --urgency=normal --expire-time=0 --category=Mail "[$BUFFER] $SENDER" "$(escape "$MESSAGE")"

mpv ~/.guix-home/profile/share/sounds/freedesktop/stereo/message.oga

