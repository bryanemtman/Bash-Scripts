#!/bin/bash

input="$1"
ip="${input%/*}"     # Everything before the slash → "10.0.2.104"
cidr="${input#*/}"   # Everything after the slash  → "26"
to_file="yes"        # Assign value of "yes" to output addresses to output file
output_file="hosts.txt" # The output file

if [[ "${to_file}" == "yes" ]]; then
    if [[ -f "${output_file}" ]]; then
        rm "${output_file}"
    fi
fi

# Split ip address into 4 octets
IFS='.' read -r A B C D <<< "$ip"

# Convert dotted IP → single 32-bit integer
# A*2^24 + B*2^16 + C*2^8 + D
ip_as_int=$(( (A<<24) + (B<<16) + (C<<8) + D ))

# Create the subnet mask and the wildcard mask
mask=$(( 0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF ))
wildcard=$(( ~mask & 0xFFFFFFFF ))

# Network address and broadcast address
network_addr=$(( ip_as_int & mask ))
broadcast_addr=$(( network_addr | wildcard ))

# ---------------------------------------------
# Convert a 32-bit integer back → dotted IP
# ---------------------------------------------
to_ip() {
    local num=$1

    # Extract each byte using shifting
    printf "%d.%d.%d.%d\n" \
        $(( (num >> 24) & 255 )) \
        $(( (num >> 16) & 255 )) \
        $(( (num >> 8)  & 255 )) \
        $((  num        & 255 ))
}

# Print basic subnet info
echo "Input:        $input"
echo "CIDR:         /$cidr"
echo "Network:      $(to_ip $network_addr)"
echo "Broadcast:    $(to_ip $broadcast_addr)"
echo

# Checks if to write to a file or stdout
if [[ "${to_file}" == "yes" ]]; then
    echo "Host addresses: ${output_file}"

    # List all IP addresses in the subnet to a file
    for (( addr=network_addr; addr<=broadcast_addr; addr++ )); do
        echo $(to_ip "$addr") >> ${output_file}
    done
else
    echo "Host addresses:"

    # List all IP addresses in the subnet to cli
    for (( addr=network_addr; addr<=broadcast_addr; addr++ )); do
        to_ip "$addr"
    done
fi
