#!/usr/bin/env bash

# WiFi menu using nmcli and fuzzel
# Toggle wifi radio, rescan, pick a network to connect (password prompt for new secured networks)

set -euo pipefail

APP_NAME="Wi-Fi"
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
    local -a entries=()
    local -A ssid_of=()
    local -A security_of=()

    if [[ "$(nmcli radio wifi)" != "enabled" ]]; then
        local choice
        choice=$(printf '%s\n' "󰖩  Enable Wi-Fi" | fuzzel --dmenu --prompt "Wi-Fi: ") || exit 0
        if [[ "$choice" == "󰖩  Enable Wi-Fi" ]]; then
            nmcli radio wifi on
            notify "Wi-Fi enabled"
        fi
        exit 0
    fi

    entries+=("󰖪  Disable Wi-Fi")
    entries+=("󰑓  Rescan")

    # IN-USE:SSID:SIGNAL:SECURITY — SSID may contain escaped colons (\:)
    local line in_use ssid signal security marker label
    local -A best_signal=()
    local -A best_line=()
    while IFS= read -r line; do
        in_use=${line%%:*}
        rest=${line#*:}
        security=${rest##*:}
        rest=${rest%:*}
        signal=${rest##*:}
        ssid=${rest%:*}
        ssid=${ssid//\\:/:}
        [[ -z "$ssid" ]] && continue

        if [[ "$in_use" == "*" ]] || (( ${best_signal[$ssid]:-(-1)} < signal )); then
            best_signal[$ssid]=$signal
            marker="  "
            [[ "$in_use" == "*" ]] && marker="󰄬 "
            if [[ "$security" == "--" || -z "$security" ]]; then
                label="${marker} ${ssid}  (${signal}%, open)"
            else
                label="${marker} ${ssid}  (${signal}%, ${security})"
            fi
            best_line[$ssid]=$label
            [[ "$in_use" == "*" ]] && best_signal[$ssid]=101
            security_of[$ssid]=$security
        fi
    done < <(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan no 2>/dev/null)

    for ssid in "${!best_line[@]}"; do
        entries+=("${best_line[$ssid]}")
        ssid_of["${best_line[$ssid]}"]=$ssid
    done

    local selected
    selected=$(printf '%s\n' "${entries[@]}" | fuzzel --dmenu --prompt "Wi-Fi: ") || exit 0
    [[ -z "$selected" ]] && exit 0

    case "$selected" in
        "󰖪  Disable Wi-Fi")
            nmcli radio wifi off
            notify "Wi-Fi disabled"
            exit 0
            ;;
        "󰑓  Rescan")
            notify "Scanning for networks..."
            nmcli dev wifi list --rescan yes >/dev/null 2>&1 || true
            exec "$0"
            ;;
    esac

    local target=${ssid_of[$selected]:-}
    if [[ -z "$target" ]]; then
        notify "Invalid selection" "" "critical"
        exit 1
    fi

    notify "Connecting to $target..."

    # Known profile → bring it up; otherwise fresh connect (with password if secured)
    if nmcli -t -f NAME con show | grep -qxF "$target"; then
        if nmcli con up id "$target" >/dev/null 2>&1; then
            notify "Connected to $target"
        else
            notify "Failed to connect to $target" "" "critical"
            exit 1
        fi
    elif [[ "${security_of[$target]}" == "--" || -z "${security_of[$target]}" ]]; then
        if nmcli dev wifi connect "$target" >/dev/null 2>&1; then
            notify "Connected to $target"
        else
            notify "Failed to connect to $target" "" "critical"
            exit 1
        fi
    else
        local password
        password=$(fuzzel --dmenu --password --prompt "Password for $target: " --lines 0 </dev/null) || exit 0
        [[ -z "$password" ]] && exit 0
        if nmcli dev wifi connect "$target" password "$password" >/dev/null 2>&1; then
            notify "Connected to $target"
        else
            notify "Failed to connect to $target" "" "critical"
            exit 1
        fi
    fi
}

main "$@"
