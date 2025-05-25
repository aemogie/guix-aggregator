#!/bin/sh

pw-link --input | grep VC_input > /dev/null 2>&1 || guix shell pulseaudio -- pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=VC_input channel_map=front-left,front-right

pw-link --output | grep VC_output > /dev/null 2>&1 || guix shell pulseaudio -- pactl load-module module-null-sink media.class=Audio/Sink sink_name=VC_output channel_map=front-left,front-right

pw-link VC_output:monitor_FL VC_input:input_FL > /dev/null 2>&1
pw-link VC_output:monitor_FR VC_input:input_FR > /dev/null 2>&1

xdg-open "http://127.0.0.1:18888/"

pidof MMVCServerSIO > /dev/null 2>&1 || guix shell -L /home/look/projects/guile/misako -CFN zlib portaudio python-wrapper nvda nvidia-driver cuda-toolkit --share=/run --share=/tmp --share=/dev -- /home/look/downloads/voice-changer/MMVCServerSIO/MMVCServerSIO
