#!/usr/bin/env bash
# Usage: power-menu.sh [menu | lock | logout | suspend | reboot | shutdown]
# "menu" (or no argument) opens a rofi list so you pick what to do.
# Needs: rofi, systemd (loginctl, systemctl)

lock="  Lock"
logout="  Logout"
suspend="  Suspend"
reboot="  Reboot"
shutdown="  Shutdown"

# Pick the action from a menu when called with "menu" or no arguments
if [[ -z "$1" || "$1" == "menu" ]]; then
  items=(
    "$lock"
    "$logout"
    "$suspend"
    "$reboot"
    "$shutdown"
  )

  choice=$(printf '%s\n' "${items[@]}" | rofi -dmenu -i -p "Power") || exit 0

  case "$choice" in
    "$lock")     set -- lock ;;
    "$logout")   set -- logout ;;
    "$suspend")  set -- suspend ;;
    "$reboot")   set -- reboot ;;
    "$shutdown") set -- shutdown ;;
    *) exit 0 ;;
  esac

  sleep 0.2   # let the menu close cleanly before running the action
fi

case "$1" in
  lock)
    loginctl lock-session
    ;;
  logout)
    loginctl terminate-user "$USER"
    ;;
  suspend)
    systemctl suspend
    ;;
  reboot)
    systemctl reboot
    ;;
  shutdown)
    systemctl poweroff
    ;;
  *)
    echo "Usage: $0 [menu | lock | logout | suspend | reboot | shutdown]" >&2
    exit 1
    ;;
esac
