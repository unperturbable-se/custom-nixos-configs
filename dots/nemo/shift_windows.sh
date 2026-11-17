#!/usr/bin/env bash
# Moves any window opened on workspace 1 to workspace 2, except Nemo-desktop

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
grep --line-buffered '^openwindow>>' |
while read -r line; do
  IFS=',' read -r addr ws class title <<< "${line#openwindow>>}"
  if [[ "$ws" == "1" && "${class,,}" != "nemo-desktop" ]]; then
    hyprctl dispatch movetoworkspace "2,address:0x$addr"
  fi
done
