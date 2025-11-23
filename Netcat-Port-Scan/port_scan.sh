#!/bin/bash

# Usage: ./scan_ports.sh ports.txt 192.168.100.10

ports_file="${1}"
ADDR="${2}"

# ----------------------------------------
# Input Validation
# ----------------------------------------
if [[ -z "$ports_file" || -z "$ADDR" ]]; then
    echo "Usage: ${0} <ports_file> <ip_address>"
    exit 1
fi
if [[ ! -f "$ports_file" ]]; then
    echo "Error: '$ports_file' does not exist."
    exit 1
fi

# ----------------------------------------
# Start scan
# ----------------------------------------
echo
echo "Beginning Port Scan on ${ADDR}"
echo

while read -r port; do
    [[ -z "$port" ]] && continue      # skip empty lines
    [[ "$port" =~ ^[0-9]+$ ]] || continue  # skip non-numeric

    # Check if port is open
    if nc -w 1 "${ADDR}" "$port" </dev/null >/dev/null 2>&1; then
        echo "${ADDR}:$port is open"

        # Attempts Banner Grabbing
        # Not Perfect
        banner=$(echo -e "\n" | nc -w 2 "${ADDR}" "$port" 2>/dev/null)

        if [[ -n "$banner" ]]; then
            echo "       Banner:"
            echo "       ---------------------"
            echo "$banner" | sed 's/^/       /'
            echo "       ---------------------"
        else
            echo "       (No banner received)"
        fi

        echo
    fi

done < "$ports_file"

echo "Port Scan Complete."
echo
