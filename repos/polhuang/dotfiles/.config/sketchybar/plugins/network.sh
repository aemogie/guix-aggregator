#!/bin/bash

# Check if we have a default route (connected to internet)
if ! ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
  ICON="󰖪"
  LABEL="Offline"
else
  # Try to get WiFi SSID using multiple methods
  SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')

  if [ -z "$SSID" ] || [ "$SSID" = "You are not associated with an AirPort network." ]; then
    # Try alternative method
    SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I 2>/dev/null | awk -F: '/ SSID/{print $2}' | xargs)
  fi

  if [ -n "$SSID" ] && [ "$SSID" != "You are not associated with an AirPort network." ]; then
    ICON="󰖩"
    LABEL="$SSID"
  else
    # Connected but not via WiFi - probably ethernet
    ICON="󰈀"
    LABEL="Wired"
  fi
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
