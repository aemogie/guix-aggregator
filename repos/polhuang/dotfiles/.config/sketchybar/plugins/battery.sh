#!/bin/bash

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

ICON="󰁹"
COLOR=0xffa6e3a1  # Green

case "${PERCENTAGE}" in
  9[0-9]|100)
    ICON="󰁹"
    COLOR=0xffa6e3a1  # Green
  ;;
  [6-8][0-9])
    ICON="󰂀"
    COLOR=0xfff9e2af  # Yellow
  ;;
  [3-5][0-9])
    ICON="󰁽"
    COLOR=0xfffab387  # Orange
  ;;
  [1-2][0-9])
    ICON="󰁻"
    COLOR=0xfff38ba8  # Red
  ;;
  *)
    ICON="󰂎"
    COLOR=0xfff38ba8  # Red
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󰂄"
  COLOR=0xfff9e2af  # Yellow
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR" \
  label="${PERCENTAGE}%"
