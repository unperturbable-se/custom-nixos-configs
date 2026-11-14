#!/usr/bin/env bash
# Shows every shortcut from README.md in a rofi list (read-only, just for looking up).
# Edit the README and this list updates automatically.

README="$HOME/.config/shortcuts/shortcuts.md"

if [[ ! -f "$README" ]]; then
  notify-send "Shortcuts" "README not found: $README" 2>/dev/null
  exit 1
fi

awk -F'|' '
  /^\|/ && !/---/ && !/Shortcut/ {
    gsub(/^ +| +$/, "", $2)
    gsub(/^ +| +$/, "", $3)
    printf "%-30s %s\n", $2, $3
  }
' "$README" | rofi -dmenu -i -no-custom -p "Shortcuts" > /dev/null
