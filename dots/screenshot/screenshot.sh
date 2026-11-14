#!/usr/bin/env bash
# Usage: screenshot.sh menu | region-copy | region-save | full-copy | full-save
# "menu" opens a rofi list so you pick what to capture.
# Needs: grim, slurp, wl-clipboard, rofi (libnotify is optional, for the popup)

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

notify() {
  command -v notify-send >/dev/null && notify-send "$1" "$2"
}

# Pick the action from a menu when called with "menu"
if [[ "$1" == "menu" ]]; then
  choice=$(printf '%s\n' \
    "Region → Clipboard" \
    "Region → Save" \
    "Full screen → Clipboard" \
    "Full screen → Save" \
    | rofi -dmenu -i -p "Screenshot") || exit 0

  case "$choice" in
    "Region → Clipboard")      set -- region-copy ;;
    "Region → Save")           set -- region-save ;;
    "Full screen → Clipboard") set -- full-copy ;;
    "Full screen → Save")      set -- full-save ;;
    *) exit 0 ;;
  esac

  sleep 0.3   # let the menu disappear before capturing
fi

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
  *)
    echo "Usage: $0 menu | region-copy | region-save | full-copy | full-save" >&2
    exit 1
    ;;
esac
