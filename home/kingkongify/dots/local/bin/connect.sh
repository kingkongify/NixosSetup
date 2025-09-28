#!/usr/bin/env bash


OVPN_DIR=~/vpn/
AUTH_FILE=~/vpn/protonvpn-auth.txt

# Check auth file
if [[ ! -f "$AUTH_FILE" ]]; then
    echo "Auth file not found at $AUTH_FILE"
    exit 1
fi

# Functions
connect_vpn() {
    # Detect countries dynamically from filenames
    mapfile -t ALL_FILES < <(ls "$OVPN_DIR"/*.ovpn 2>/dev/null)
    if [[ ${#ALL_FILES[@]} -eq 0 ]]; then
        echo "No .ovpn files found in $OVPN_DIR"
        exit 1
    fi

    # Extract country codes from filenames (everything before first '-')
    declare -A FILES_BY_COUNTRY
    for f in "${ALL_FILES[@]}"; do
        name=$(basename "$f")
        country=$(echo "$name" | cut -d'-' -f1)
        FILES_BY_COUNTRY[$country]+="$f"$'\n'
    done

    # List countries
    echo "Available countries:"
    COUNTRIES=("${!FILES_BY_COUNTRY[@]}")
    for i in "${!COUNTRIES[@]}"; do
        echo "$((i+1))) ${COUNTRIES[$i]}"
    done

    read -rp "Choose a country number: " cnum
    COUNTRY="${COUNTRIES[$((cnum-1))]}"

    # List servers
    echo "Available servers in $COUNTRY:"
    mapfile -t SERVER_LIST <<< "$(echo "${FILES_BY_COUNTRY[$COUNTRY]}" | sed '/^$/d')"
    for i in "${!SERVER_LIST[@]}"; do
        echo "$((i+1))) $(basename "${SERVER_LIST[$i]}")"
    done

    read -rp "Choose a server number: " snum
    SERVER="${SERVER_LIST[$((snum-1))]}"

    echo "Connecting to $SERVER..."
    sudo openvpn --config "$SERVER" --auth-user-pass "$AUTH_FILE" \
    --script-security 2 --up /etc/openvpn/update-resolv-conf \
    --down /etc/openvpn/update-resolv-conf
}

disconnect_vpn() {
    PID=$(pgrep openvpn)
    if [[ -z "$PID" ]]; then
        echo "No active OpenVPN connection found."
    else
        echo "Disconnecting OpenVPN (PID $PID)..."
        sudo kill "$PID"
    fi
}

status_vpn() {
    if pgrep openvpn >/dev/null; then
        echo "VPN is connected."
    else
        echo "VPN is not connected."
    fi
}

# Main menu
echo "1) Connect to VPN"
echo "2) Disconnect VPN"
echo "3) VPN Status"
read -rp "Choose an option: " opt

case $opt in
    1) connect_vpn ;;
    2) disconnect_vpn ;;
    3) status_vpn ;;
    *) echo "Invalid option." ;;
esac
