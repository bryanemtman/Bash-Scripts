#!/bin/bash

print_shadow() {
    echo "Reading /etc/shadow..."

    while IFS=':' read -r account hash last_change rest; do

        # Convert days-since-epoch (if present)
        if [[ -n "${last_change}" ]]; then
            changed_date=$(date -d "1970-01-01 + ${last_change} days" 2>/dev/null)
        else
            changed_date="(no date)"
        fi

        echo
        echo -e "\tAccount:      ${account}"
        echo -e "\tHash:         ${hash}"
        echo -e "\tLast Changed: ${changed_date}"

    done < /etc/shadow
}

print_passwd() {
    echo
    echo "Reading /etc/passwd..."

    while IFS=':' read -r account _ _ _ _ home shell; do

        if [[ "${home}" =~ ^/home/ ]]; then
            echo
            echo -e "\tAccount:        ${account}"
            echo -e "\tHome Directory: ${home}"
            echo -e "\tShell:          ${shell}"
        else
            echo
            echo -e "\tNon-/home Account"
            echo -e "\tAccount:        ${account}"
            echo -e "\tHome Directory: ${home}"
            echo -e "\tShell:          ${shell}"
        fi

    done < /etc/passwd
}

echo
echo "Checking privileges..."

if [[ $EUID -eq 0 ]]; then
    print_shadow
else
    echo "Not root → skipping /etc/shadow"
fi

print_passwd

echo
echo "Done."
