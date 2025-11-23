#!/bin/bash

hosts_file="${1}"

# Checks if the input file exists
# Does not check if valid input for ping
if [[ ! -f "${hosts_file}" ]]; then
    echo "${hosts_file} does not exist."
    exit 1
else
    # Send 1 ICMP echo request to host and wait 1 second
    echo
    echo "Beginning Multi-Host Ping."
    echo
    while read -r host; do
        # Sends output to stdout and stderr to /dev/null
        # This makes no output show on the screen
        if ping -c 1 -w 1 -W 1 "${host}" >/dev/null 2>&1; then
            echo "${host} is up."
        fi
    done < "${hosts_file}"
    echo
    echo "Multi-Post Ping Complete."
    echo
fi
