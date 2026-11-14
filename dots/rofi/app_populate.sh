#!/usr/bin/env bash
# Fills apps.list from the .desktop files in one or more folders.
# Usage: ./populate-apps.sh [folder ...]
# Default folder: /run/current-system/sw/share/applications
#
# Anything you wrote by hand ABOVE the marker line is kept.
# Everything BELOW the marker is regenerated on every run.

LIST="$HOME/.config/rofi/apps.list"
MARK="# --- generated below (do not edit) ---"
DIRS=("${@:-/run/current-system/sw/share/applications}")

mkdir -p "$(dirname "$LIST")"
tmp=$(mktemp)

# Keep the hand-written part (everything above the marker)
if [[ -f "$LIST" ]]; then
  awk -v m="$MARK" '$0 == m { exit } { print }' "$LIST" > "$tmp"
fi

echo "$MARK" >> "$tmp"

for d in "${DIRS[@]}"; do
  for f in "$d"/*.desktop; do
    [[ -e "$f" ]] || continue
    awk '
      /^\[/ { insec = ($0 == "[Desktop Entry]"); next }
      !insec { next }
      /^Name=/     && name == "" { name = substr($0, 6) }
      /^Exec=/     && exec == "" { exec = substr($0, 6) }
      /^Icon=/     && icon == "" { icon = substr($0, 6) }
      /^Terminal=/ { term = substr($0, 10) }
      /^NoDisplay=/ { nd = substr($0, 11) }
      /^Hidden=/   { hid = substr($0, 8) }
      END {
        if (name == "" || exec == "" || nd == "true" || hid == "true") exit
        gsub(/ %[fFuUdDnNickvm]/, "", exec)
        gsub(/%[fFuUdDnNickvm]/, "", exec)
        gsub(/\|/, "/", name)
        print name "|" exec "|" (term == "true" ? "yes" : "no") "|" icon
      }
    ' "$f"
  done
done | sort -t'|' -k1,1 -f -u >> "$tmp"

mv "$tmp" "$LIST"
echo "Wrote $(grep -c '|' "$LIST") entries to $LIST"
