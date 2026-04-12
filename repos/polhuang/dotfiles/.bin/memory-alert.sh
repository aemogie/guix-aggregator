#!/bin/bash

THRESHOLD=75
STATE_FILE="/tmp/memory-alert-triggered"

usage=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

if (( usage > THRESHOLD )); then
    if [[ ! -f "$STATE_FILE" ]]; then
        notify-send -u critical "High Memory Usage" "Memory is at ${usage}% (threshold: ${THRESHOLD}%)"
        touch "$STATE_FILE"
    fi
else
    rm -f "$STATE_FILE"
fi
