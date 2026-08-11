#!/usr/bin/env bash

# Bluetooth menu using bluetoothctl and fuzzel
# Toggle power, connect/disconnect paired devices; pairing new devices via blueman-manager

set -euo pipefail

APP_NAME="Bluetooth"
NOTIFY_URGENCY="normal"
TIMEOUT=3000

notify() {
    local summary="$1"
    local body="${2:-}"
    local urgency="${3:-$NOTIFY_URGENCY}"

    if command -v notify-send &>/dev/null; then
        notify-send -a "$APP_NAME" -u "$urgency" -t "$TIMEOUT" "$summary" "$body"
    fi
}

main() {
    if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
        local choice
        choice=$(printf '%s\n' "󰂯  Turn on bluetooth" | fuzzel --dmenu --prompt "Bluetooth: ") || exit 0
        if [[ "$choice" == "󰂯  Turn on bluetooth" ]]; then
            bluetoothctl power on >/dev/null
            notify "Bluetooth turned on"
        fi
        exit 0
    fi

    local -a entries=("󰂲  Turn off bluetooth" "󰂳  Open blueman-manager (pair new device)")
    local -A mac_of=()
    local -A is_connected=()

    local mac
    while read -r _ mac _; do
        [[ -n "$mac" ]] && is_connected[$mac]=1
    done < <(bluetoothctl devices Connected 2>/dev/null)

    local name label
    while read -r _ mac name; do
        [[ -z "$mac" ]] && continue
        if [[ -n "${is_connected[$mac]:-}" ]]; then
            label="󰂱  ${name}  (connected)"
        else
            label="󰂯  ${name}"
        fi
        entries+=("$label")
        mac_of["$label"]=$mac
    done < <(bluetoothctl devices 2>/dev/null)

    local selected
    selected=$(printf '%s\n' "${entries[@]}" | fuzzel --dmenu --prompt "Bluetooth: ") || exit 0
    [[ -z "$selected" ]] && exit 0

    case "$selected" in
        "󰂲  Turn off bluetooth")
            bluetoothctl power off >/dev/null
            notify "Bluetooth turned off"
            exit 0
            ;;
        "󰂳  Open blueman-manager (pair new device)")
            exec blueman-manager
            ;;
    esac

    local target=${mac_of[$selected]:-}
    if [[ -z "$target" ]]; then
        notify "Invalid selection" "" "critical"
        exit 1
    fi

    if [[ -n "${is_connected[$target]:-}" ]]; then
        if bluetoothctl disconnect "$target" >/dev/null 2>&1; then
            notify "Disconnected"
        else
            notify "Failed to disconnect" "" "critical"
            exit 1
        fi
    else
        notify "Connecting..."
        if bluetoothctl connect "$target" >/dev/null 2>&1; then
            notify "Connected"
        else
            notify "Failed to connect" "" "critical"
            exit 1
        fi
    fi
}

main "$@"
