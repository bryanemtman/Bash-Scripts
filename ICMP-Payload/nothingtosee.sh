#!/bin/bash

# Commands and Prerequisites:
#       xxd, execution privileges.
#
# Personal Comments:
#       This is not an all inclusive and fail proof script. Was made for my increased learning of bash scripting and network analysis.
#       My goal with this is to display to non-IT or aspiring IT individuals the layers to network architecture and the complexity of Cybersecurity.
#
# Future Improvements:
#       1. Instead of the command ping, substitution of the hping3 or nping allows complete payload control.
#          In addition, can send packets over TCP or UDP ports (UDP/53) which is commonly unblocked.
#          However, certain options and usages force super user privileges.
#       2. Another option is transfering into a Python script to serve the same function, with greater control and versatility.
#       3. Increased number of options for added flexibility (total packet size, higher control of interval, text input).
#       4. Fault tolerance and re-sending failed transmissions.

help_text=$(cat <<EOF

Description:
        icmp.sh is a project and proof of concept for my own learning of bash scripting.
        It demonstrates how ICMP Echo packets can be used to transport data.
        Use tools such as Wireshark or tcpdump to inspect the ICMP payload.

Usage:
        ./icmp.sh -f <file> [-t <seconds>] [-s <integer>] <destination>

Options:
        --file, -f              REQUIRED        Input file containing data to send
        --time-delay, -t        OPTIONAL        Time delay between packets (default 0.5s)
        --payload-size, -s      OPTIONAL        Payload size of the ASCII characters sent through
                                                each ICMP packet (default 16)

                NOTE:   --payload-size will not function well after 16 bytes (characters) due
                to how the command ping works and the OS in use. Some bytes will be truncated
                or additional padding will be filled into the packet. For full control of the
                IMCP payload swap the command ping for nping or hping3.

Examples:
        ./icmp.sh -f text.txt 192.168.1.1
        ./icmp.sh -f text.txt -t 30 10.0.2.5

EOF
)

# Colors
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

chunk_size=16 # default bytes
wait=0.5 # default delay
file=""
destination=""

# --------------------------------------------------------------------------
# PROGRESS BAR
# --------------------------------------------------------------------------
progress_bar() {
        local current=$1
        local total=$2
        local width=30

        local percent=$(( 100 * current / total ))
        local filled=$(( width * current / total ))

        bar=$(printf "%${filled}s" | tr ' ' '#')
        space=$(printf "%$(( width - filled ))s")

        printf "\r${RED}[${bar}${space}] %d%%${RESET}\n" "$percent"
}

# --------------------------------------------------------------------------
# MAIN
# --------------------------------------------------------------------------
main() {
        local text
        text=$(<"$file")
        local buffer=""
        local count=0
        local progress=0
        local total_len=${#text}
        echo
        echo "Sending file: $file"
        echo "Total characters: $total_len"
        echo "Sending in intervals of ${wait} seconds..."
        echo
        for (( i=0; i<total_len; i++ )); do
                local char="${text:i:1}"
                buffer+="$char"
                ((count++))
                # checks if the current count of characters is equal to $chunck_size
                # if so display the original text and the hex conversion and send ICMP payload
                if (( count == chunk_size )); then
                        local hex
                        hex=$(printf "%s" "$buffer" | xxd -p | tr -d '\n')
                        echo -e "Chunk: ${GREEN}'$buffer'${RESET} → Hex: ${GREEN}$hex${RESET}"
                        ping -c 1 -p "$hex" "$destination" > /dev/null # sends output to the void, will display errors
                        count=0 # reset count and buffer to get new payload
                        buffer=""
                        sleep "$wait"
                fi
                # Checks to display progress bar
                # Displays every progress every 10 percent
                progress=$(( (i+1) * 100 / total_len ))
                if (( progress % 10 == 0 && progress != last_printed )); then
                        echo
                        progress_bar $((i+1)) "$total_len"
                        last_printed=$progress
                        echo
                fi
        done
        # leftover bytes
        if (( count > 0 )); then
                local padding=$(( chunk_size - count ))
                for (( p=0; p<padding; p++ )); do buffer+="~"; done
                local hex
                hex=$(printf "%s" "$buffer" | xxd -p | tr -d '\n')
                echo -e "Final padded chunk: ${GREEN}'$buffer'${RESET} → Hex: ${GREEN}$hex${RESET}"
                ping -c 1 -p "$hex" "$destination" > /dev/null
                # final progress update (100%)
                echo
                progress_bar $((i+1)) "$total_len"
                echo
                echo "Done"
                echo
        fi
}

# --------------------------------------------------------------------------
# ARGUMENT PARSING (simple and correct)
# --------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
        case "$1" in
                -h|--help)
                        # verifies the help option
                        echo "$help_text"
                        exit 0
                        ;;
                -f|--file)
                        # verifies the file option
                        file="$2"
                        if [[ ! -f "$file" ]]; then
                                echo "Error: File does not exist: $file"
                                exit 1
                        fi
                        shift 2
                        ;;
                -t|--time-delay)
                        # verifies the time option
                        if [[ "$2" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
                                wait="$2"
                        else
                                echo "Error: invalid time delay"
                                exit 1
                        fi
                        shift 2
                        ;;
                -s|--payload-size)
                        # verifies the size option
                        if [[ "$2" =~ ^[0-9]+$ ]]; then
                                chunk_size="$2"
                        else
                                echo "Error: invalid payload size"
                                exit 1
                        fi
                        shift 2
                        ;;
                *)
                        # Last non-flag argument is destination IP
                        if [[ "$1" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
                                destination="$1"
                        else
                                echo "Error: Invalid input or IP address: $1"
                                exit 1
                        fi
                        shift
                        ;;
        esac
done

# --------------------------------------------------------------------------
# FINAL VALIDATION
# --------------------------------------------------------------------------
# checks if $file is empty or if $destination is empty
if [[ -z "$file" || -z "$destination" ]]; then
        echo "Error: A file AND destination IP are required."
        echo "$help_text"
        exit 1
fi

main
