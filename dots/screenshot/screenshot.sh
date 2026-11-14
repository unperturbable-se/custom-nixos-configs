#!/usr/bin/env bash
# Usage: screenshot.sh menu | region-copy | region-save | full-copy | full-save
#                      | record-region | record-full | record-stop
# "menu" opens a rofi list so you pick what to do.
# Needs: grim, slurp, wl-clipboard, wf-recorder, rofi (libnotify optional, for popups)

shots="$HOME/Pictures/Screenshots"
vids="$HOME/Videos/Recordings"
mkdir -p "$shots" "$vids"
stamp=$(date +%Y-%m-%d_%H-%M-%S)
file="$shots/$stamp.png"
vfile="$vids/$stamp.mp4"
last="${XDG_RUNTIME_DIR:-/tmp}/last-recording"

notify() {
  command -v notify-send >/dev/null && notify-send "$1" "$2"
}

recording() { pgrep -x wf-recorder >/dev/null; }

# Pick the action from a menu when called with "menu"
if [[ "$1" == "menu" ]]; then
  items=()
  recording && items+=("Stop recording")
  items+=(
    "Region → Clipboard"
    "Region → Save"
    "Full screen → Clipboard"
    "Full screen → Save"
    "Record region"
    "Record full screen"
  )

  choice=$(printf '%s\n' "${items[@]}" | rofi -dmenu -i -p "Capture") || exit 0

  case "$choice" in
    "Stop recording")          set -- record-stop ;;
    "Region → Clipboard")      set -- region-copy ;;
    "Region → Save")           set -- region-save ;;
    "Full screen → Clipboard") set -- full-copy ;;
    "Full screen → Save")      set -- full-save ;;
    "Record region")           set -- record-region ;;
    "Record full screen")      set -- record-full ;;
    *) exit 0 ;;
  esac

  sleep 0.3   # let the menu disappear before capturing
fi

start_recording() {
  if recording; then
    notify "Already recording" "Stop the current recording first"
    exit 0
  fi
  echo "$vfile" > "$last"
  # add --audio after wf-recorder to also capture sound
  setsid wf-recorder "$@" -f "$vfile" >/dev/null 2>&1 &
  notify "Recording started" "Open this menu again to stop"
}

case "$1" in
  region-copy)
    area=$(slurp) || exit 0          # exits quietly if you press Esc
    grim -g "$area" - | wl-copy
    notify "Screenshot" "Region copied to clipboard"
    ;;
  region-save)
    area=$(slurp) || exit 0
    grim -g "$area" "$file" && wl-copy < "$file"
    notify "Screenshot saved" "$file"
    ;;
  full-copy)
    grim - | wl-copy
    notify "Screenshot" "Full screen copied to clipboard"
    ;;
  full-save)
    grim "$file" && wl-copy < "$file"
    notify "Screenshot saved" "$file"
    ;;
  record-region)
    area=$(slurp) || exit 0
    start_recording -g "$area"
    ;;
  record-full)
    start_recording
    ;;
  record-stop)
    if recording; then
      pkill -INT -x wf-recorder
      sleep 0.5
      notify "Recording saved" "$(cat "$last" 2>/dev/null)"
    else
      notify "Not recording" "Nothing to stop"
    fi
    ;;
  *)
    echo "Usage: $0 menu | region-copy | region-save | full-copy | full-save | record-region | record-full | record-stop" >&2
    exit 1
    ;;
esac
