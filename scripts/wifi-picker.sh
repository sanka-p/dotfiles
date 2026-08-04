#!/usr/bin/env bash

# WiFi network picker using nmcli and fuzzel
# Lists available WiFi networks and allows selection via fuzzel dropdown
# Connects to the selected network using nmcli

set -euo pipefail

# Color scheme matching your fuzzel config (Catppuccin Mocha)
NOTIFY_URGENCY="normal"
TIMEOUT=3000

# Get list of available WiFi networks
get_networks() {
    nmcli dev wifi list --rescan no 2>/dev/null | tail -n +2 | awk '{$1=""; print $0}' | sed 's/^ *//' | sort -u
}

# Show notification
notify() {
    local summary="$1"
    local body="${2:-}"
    local urgency="${3:-$NOTIFY_URGENCY}"
    
    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" -t "$TIMEOUT" "$summary" "$body"
    fi
}

# Main function
main() {
    # Get available networks
    networks=$(get_networks)
    
    if [[ -z "$networks" ]]; then
        notify "WiFi Picker" "No networks found" "critical"
        exit 1
    fi
    
    # Show fuzzel picker
    selected=$(echo "$networks" | fuzzel --dmenu)
    
    if [[ -z "$selected" ]]; then
        # User cancelled
        exit 0
    fi
    
    # Extract SSID (first field, handling spaces)
    ssid=$(echo "$selected" | awk '{print $1}')
    
    if [[ -z "$ssid" ]]; then
        notify "WiFi Picker" "Invalid selection" "critical"
        exit 1
    fi
    
    # Attempt connection
    notify "WiFi Picker" "Connecting to $ssid..."
    
    if nmcli dev wifi connect "$ssid" 2>/dev/null; then
        notify "WiFi Picker" "Connected to $ssid" "normal"
    else
        notify "WiFi Picker" "Failed to connect to $ssid" "critical"
        exit 1
    fi
}

main "$@"
