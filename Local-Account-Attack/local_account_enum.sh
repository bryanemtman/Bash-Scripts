#!/bin/bash

# Displays the account information from /etc/shadow
print_shadow() {
    echo
    echo "Reading /etc/shadow..."
    # Loops through the file line by line reading it to variables by a deliminator of ":"
    while IFS=':' read -r account hash last_change rest; do

        # Convert days-since-epoch (if present)
        if [[ -n "${last_change}" ]]; then
            changed_date=$(date -d "1970-01-01 + ${last_change} days" 2>/dev/null)
        else
            changed_date="(no date)"
        fi
        # Display selected variables
        echo
        echo -e "\tAccount:      ${account}"
        echo -e "\tHash:         ${hash}"
        echo -e "\tLast Changed: ${changed_date}"

    done < /etc/shadow
}


# Displays the account information from /etc/passwd
print_passwd() {
    echo
    echo "Reading /etc/passwd..."
    # Loops through the file line by line reading it to variables by a deliminator of ":"
    while IFS=':' read -r account _ _ _ _ home shell; do
        # Uses regex to find if the accounts home directory is in /home/*
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

# Checks if account is root
# Cannot access /etc/shadow unless root
if [[ $EUID -eq 0 ]]; then
    print_shadow
else
    echo "Not root → skipping /etc/shadow"
fi

print_passwd

echo
echo "Done."
