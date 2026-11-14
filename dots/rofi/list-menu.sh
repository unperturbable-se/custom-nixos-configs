#!/usr/bin/env bash
# One file that does everything:
#   run it           -> opens rofi with your my-apps.list entries first, then all normal apps
#   rofi calls it    -> acts as the script mode that lists/launches my-apps.list entries
#
# Put it next to my-apps.list (e.g. ~/.config/rofi) and make it executable:
#   chmod +x ~/.config/rofi/list-menu.sh
# Hyprland:  $menu = sh ~/.config/rofi/list-menu.sh
#
# my-apps.list format (one per line):  Name|Command|Terminal(yes/no)|Icon
# Terminal and Icon are optional. Lines starting with # are ignored.

# Re-run with bash if started with plain sh
[ -n "$BASH_VERSION" ] || exec bash "$0" "$@"

SELF="$(readlink -f "$0")"
LIST="$(dirname "$SELF")/my-apps.list"
TERMINAL="kitty"

entries() { grep -v -E '^[[:space:]]*(#|$)' "$LIST" 2>/dev/null; }

trimv() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# ---- Script mode: rofi sets ROFI_RETV when it calls this file ----
if [[ -n "$ROFI_RETV" ]]; then

  # No argument: print the names (with icons when given)
  if [[ -z "$1" ]]; then
    entries | while IFS='|' read -r name _ _ icon; do
      name=$(trimv "$name")
      icon=$(trimv "$icon")
      if [[ -n "$icon" ]]; then
        printf '%s\0icon\x1f%s\n' "$name" "$icon"
      else
        printf '%s\n' "$name"
      fi
    done
    exit 0
  fi

  # Argument given: launch the chosen entry
  line=$(entries | awk -F'|' -v n="$1" '{ gsub(/^[ \t]+|[ \t]+$/, "", $1); if ($1 == n) { print; exit } }')
  [[ -z "$line" ]] && exit 0

  IFS='|' read -r _ cmd term _ <<< "$line"
  cmd=$(trimv "$cmd")
  term=$(trimv "$term")

  if [[ "$term" == "yes" || "$term" == "true" ]]; then
    coproc ( "$TERMINAL" -e sh -c "$cmd" > /dev/null 2>&1 )
  else
    coproc ( sh -c "$cmd" > /dev/null 2>&1 )
  fi

  exec 1>&-
  exit 0
fi

# ---- Launcher mode: open rofi ----
exec rofi -show combi \
  -modi "combi,custom:$SELF" \
  -combi-modes "custom,drun" \
  -combi-display-format "{text}"
