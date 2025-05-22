#!/usr/bin/env -S guix shell socat bash -- bash

handle() {
  IFS=',' read -r -a args <<< "${1#*>>}"
  case $1 in
    activewindowv2*)
      ACTIVE_WINDOW=${args[0]}
    ;;
    openwindow*)
      # Enable phasmo stuff
      if [[ ${args[2]} == "phasmophobia.exe" ]]; then
        PHASMO_ADDRESS=${args[0]}
        hyprctl keyword decoration:screen_shader '$XDG_CONFIG_HOME/hypr/shaders/bright.frag'
      fi
    ;;
    closewindow*)
      # Disable phasmo stuff
      if [[ ${args[0]} == $PHASMO_ADDRESS ]]; then
        hyprctl keyword decoration:screen_shader ''
      fi
    ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
