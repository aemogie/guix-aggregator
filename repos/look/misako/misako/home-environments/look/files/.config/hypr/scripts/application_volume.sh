#!/usr/bin/env bash

declare -A defaults

# hyprland class =  name
defaults["steam_app_739630"]="Phasmophobia.exe"
defaults["zen"]="Zen"
defaults["spotify"]="PipeWire ALSA [spotify]"

current_window="$(hyprctl activewindow -j)"
current_window_title=$(echo $current_window | jq .title)
current_window_pid=$(echo $current_window | jq .pid)
current_window_initial_class=$(echo $current_window | jq -r .initialClass)

# application.process.id
pw_dump=$(pw-dump | jq '.[] | select(.type == "PipeWire:Interface:Node" and .info.props["application.name"] != null) | {id, name: .info.props["application.name"], binary: .info.props["application.process.binary"], pid: .info.props["application.process.id"], media_class: .info.props["media.class"]}')

# See application here
# echo $pw_dump > /tmp/test
# echo $current_window_initial_class >> /tmp/test

sub=${defaults["$current_window_initial_class"]}

if [ -n "$sub" ]; then
    id=$(echo "$pw_dump" | jq "select(.binary == \"$sub\" and .media_class != \"Stream/Input/Audio\")" | jq '.id')
fi
if [ -n "$sub" ]; then
    id=$(echo "$pw_dump" | jq "select(.name == \"$sub\" and .media_class != \"Stream/Input/Audio\")" | jq '.id')
fi
if [ ! -n "$id" ]; then
    # try binary
    id=$(echo "$pw_dump" | jq "select(.binary == \"$current_window_initial_class\" and .media_class != \"Stream/Input/Audio\")" | jq '.id')
fi
    # no binary
if [ ! -n "$id" ]; then
    # try name
    id=$(echo "$pw_dump" | jq "select(.name == \"$current_window_initial_class\" and .media_class != \"Stream/Input/Audio\")" | jq '.id')
fi


if [ -n "$id" ]; then
    for i in $id; do
        if [ -n "$3" ]; then
            wpctl $1 "$i" $2 -l $3
        else
            wpctl $1 "$i" $2
        fi
    done
fi
