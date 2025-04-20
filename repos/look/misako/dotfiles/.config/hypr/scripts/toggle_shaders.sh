#!/bin/sh

TOGGLE=/tmp/.toggle

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
    hyprctl keyword decoration:screen_shader '$XDG_CONFIG_HOME/hypr/shaders/bright.frag'
else
    rm $TOGGLE
    hyprctl keyword decoration:screen_shader ''
fi
