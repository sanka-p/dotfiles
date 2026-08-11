#!/usr/bin/env bash

# Audio device menu using wpctl and fuzzel
# Pick default output (sink) and input (source) devices

set -euo pipefail

APP_NAME="Audio"
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
    local -A id_of=()
    local -A kind_of=()

    local section="" line id name marker label is_default
    while IFS= read -r line; do
        # Track which sub-section of the Audio block we're in
        if [[ "$line" == *"Sinks:"* ]]; then
            section="sink"; continue
        elif [[ "$line" == *"Sources:"* ]]; then
            section="source"; continue
        elif [[ "$line" == *"Filters:"* || "$line" == *"Streams:"* || "$line" == "Video"* || "$line" == "Settings"* ]]; then
            section=""; continue
        fi
        [[ -z "$section" ]] && continue

        # Device lines look like: " │  *   62. Some Device Name [vol: 0.67]"
        [[ "$line" =~ ^[^0-9]*([0-9]+)\.\ (.*)$ ]] || continue
        id=${BASH_REMATCH[1]}
        name=${BASH_REMATCH[2]}
        name=${name%\[vol:*}
        name=$(echo "$name" | sed 's/[[:space:]]*$//')
        [[ -z "$name" ]] && continue

        is_default=""
        [[ "$line" == *"*"* ]] && is_default=1

        if [[ "$section" == "sink" ]]; then
            marker="󰕾"
        else
            marker="󰍬"
        fi
        if [[ -n "$is_default" ]]; then
            label="${marker} 󰄬 ${name}"
        else
            label="${marker}   ${name}"
        fi
        entries+=("$label")
        id_of["$label"]=$id
        kind_of["$label"]=$section
    done < <(wpctl status | sed -n '/^Audio/,/^Video/p')

    if (( ${#entries[@]} == 0 )); then
        notify "No audio devices found" "" "critical"
        exit 1
    fi

    local selected
    selected=$(printf '%s\n' "${entries[@]}" | fuzzel --dmenu --prompt "Audio: ") || exit 0
    [[ -z "$selected" ]] && exit 0

    local target=${id_of[$selected]:-}
    if [[ -z "$target" ]]; then
        notify "Invalid selection" "" "critical"
        exit 1
    fi

    local clean_name=${selected#* }
    clean_name=${clean_name#󰄬 }
    clean_name=$(echo "$clean_name" | sed 's/^[[:space:]]*//')

    if wpctl set-default "$target" >/dev/null 2>&1; then
        if [[ "${kind_of[$selected]}" == "sink" ]]; then
            notify "Output → $clean_name"
        else
            notify "Input → $clean_name"
        fi
    else
        notify "Failed to set default device" "" "critical"
        exit 1
    fi
}

main "$@"
