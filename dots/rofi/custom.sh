#!/usr/bin/env bash
# Rofi script mode: lists the apps in apps.list and launches the one you pick.
# apps.list format (one per line):  Name|Command|Terminal(yes/no, optional)

LIST="$HOME/.config/rofi/apps.list"
TERMINAL="kitty"

entries() { grep -v -E '^[[:space:]]*(#|$)' "$LIST" 2>/dev/null; }
trim()    { sed -E 's/^[[:space:]]+|[[:space:]]+$//g'; }

# No argument: rofi wants the list of names
if [[ -z "$1" ]]; then
  entries | cut -d'|' -f1 | trim
  exit 0
fi

# Argument given: launch the chosen entry
line=$(entries | awk -F'|' -v n="$1" '{ gsub(/^[ \t]+|[ \t]+$/, "", $1); if ($1 == n) { print; exit } }')
[[ -z "$line" ]] && exit 0

cmd=$(printf '%s' "$line" | cut -d'|' -f2 | trim)
term=$(printf '%s' "$line" | cut -d'|' -f3 | trim)

if [[ "$term" == "yes" || "$term" == "true" ]]; then
  coproc ( "$TERMINAL" -e sh -c "$cmd" > /dev/null 2>&1 )
else
  coproc ( sh -c "$cmd" > /dev/null 2>&1 )
fi

exec 1>&-
exit 0
