#!/bin/bash

# Get CPU usage per core (more reasonable percentage)
CPU_INFO=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
CPU_CORES=$(sysctl -n hw.ncpu)

# Calculate average CPU usage across all cores
if [ -n "$CPU_CORES" ] && [ "$CPU_CORES" -gt 0 ]; then
  CPU_PERCENT=$(echo "scale=0; $CPU_INFO / $CPU_CORES" | bc)
else
  CPU_PERCENT=$(printf "%.0f" "$CPU_INFO")
fi

# Cap at 100%
if [ "$CPU_PERCENT" -gt 100 ]; then
  CPU_PERCENT=100
fi

sketchybar --set "$NAME" label="$CPU_PERCENT%"
