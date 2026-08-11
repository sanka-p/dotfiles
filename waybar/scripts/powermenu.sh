#!/usr/bin/env bash

# Power menu using fuzzel
# Lock, logout, suspend, reboot, shutdown — destructive actions ask for confirmation

set -euo pipefail

confirm() {
    local action="$1"
    local choice
    choice=$(printf '%s\n' "No" "Yes" | fuzzel --dmenu --prompt "${action}? ") || return 1
    [[ "$choice" == "Yes" ]]
}

main() {
    local -a entries=(
        "  Lock"
        "󰤄  Suspend"
        "󰍃  Logout"
        "󰜉  Reboot"
        "⏻  Shutdown"
    )

    local selected
    selected=$(printf '%s\n' "${entries[@]}" | fuzzel --dmenu --prompt "Power: ") || exit 0

    case "$selected" in
        "  Lock")
            exec hyprlock
            ;;
        "󰤄  Suspend")
            exec systemctl suspend
            ;;
        "󰍃  Logout")
            confirm "Logout" || exit 0
            exec hyprctl dispatch exit
            ;;
        "󰜉  Reboot")
            confirm "Reboot" || exit 0
            exec systemctl reboot
            ;;
        "⏻  Shutdown")
            confirm "Shutdown" || exit 0
            exec systemctl poweroff
            ;;
    esac
}

main "$@"
