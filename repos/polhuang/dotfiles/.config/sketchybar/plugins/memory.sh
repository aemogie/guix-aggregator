#!/bin/bash

MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | sed 's/%//')

if [ -z "$MEMORY" ]; then
  MEMORY=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
  MEMORY=$((MEMORY * 4096 / 1024 / 1024 / 1024))
  MEMORY=$(printf "%.0f" "$MEMORY")
fi

sketchybar --set "$NAME" label="${MEMORY}%"
