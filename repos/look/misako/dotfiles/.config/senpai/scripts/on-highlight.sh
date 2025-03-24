#!/bin/sh

escape() {
  printf "%s" "$1" | sed 's#\#\\#g'
}

notify-send --urgency=normal --expire-time=0 --category=irc "[$BUFFER] $SENDER" "$(escape "$MESSAGE")"
