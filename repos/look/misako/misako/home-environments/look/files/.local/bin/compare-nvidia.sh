#!/usr/bin/env bash

compare() {
  curl -s "https://us.download.nvidia.com/XFree86/Linux-x86_64/$1/README/installedcomponents.html" | sed -E 's/\.[0-9.]+//g'
}

DIFF="$(diff <(compare $1) <(compare $2))"

printf "\n%s\n\n" "**Full diff**"
printf "%s\n" "$DIFF"
printf "\n%s\n\n" "**Changed files**"
printf "%s\n" "$DIFF" | grep -i filename
