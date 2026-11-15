#!/usr/bin/env bash

# Power options with Nerd Font icons
lock="  Lock"
logout="  Logout"
suspend="  Suspend"
reboot="  Reboot"
shutdown="  Shutdown"

# Show Rofi menu
chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$lock" "$logout" "$suspend" "$reboot" "$shutdown" | rofi -dmenu -i -p "Power")

case "$chosen" in
    "$lock") loginctl lock-session ;;
    "$logout") loginctl terminate-user "$USER" ;;
    "$suspend") systemctl suspend ;;
    "$reboot") systemctl reboot ;;
    "$shutdown") systemctl poweroff ;;
esac
