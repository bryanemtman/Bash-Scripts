# Local Account Enumeration & Dictionary Attack (Linux)

A pair of Bash scripts designed as educational proof-of-concepts to demonstrate how local Linux user accounts can be enumerated and targeted with a dictionary-based password attack under specific conditions.

NOTE: These scripts are for learning, lab environments, and authorized testing only.

## Repository Overview

This repository contains two related scripts:

1. Local Account Enumeration Script

    - Gathers user account information from /etc/passwd

    - Optionally reads /etc/shadow when run with root privileges

    - Identifies user accounts suitable for targeting

2. Local Account Dictionary Attack Script

    - Attempts to authenticate as a specific local user using a password list

    - Uses su to test credentials

    - Demonstrates the risk of weak local passwords

Together, these scripts simulate a post-compromise local privilege escalation or lateral movement scenario.

## Learning Objectives

- Understand Linux account storage mechanisms

- Learn the structure of /etc/passwd and /etc/shadow

- Identify valid local user accounts

- Understand how weak passwords enable privilege escalation

- Practice Bash scripting, parsing, and input validation

- See how enumeration feeds directly into exploitation

## Legal & Ethical Disclaimer

### DO NOT use these scripts on systems you do not own or have explicit permission to test.

Unauthorized credential attacks are illegal and unethical.

These scripts are intended for:

- Home labs

- Cybersecurity training

- CTF environments

- Defensive awareness and detection research

## Requirements

- Bash

- Linux system with local user accounts

- Root privileges (for /etc/shadow access)

- timeout, grep, su

## Local Account Enumeration Script

<b>Purpose</b>

Enumerates local Linux user accounts to identify:

- Valid usernames

- Login shells

- Home directories

- Password hash status

- Last password change (if run as root)

This script is intended to identify viable targets for further attacks.

<b>What It Does</b>

Reads /etc/passwd to list:

- Username

- Home directory

- Login shell

Distinguishes between:

- Human users (/home/*)

- System or service accounts

If run as root:

- Reads /etc/shadow

- Displays password hash entries

- Converts password-change timestamps to readable dates

### Usage
```sudo ./enumerate_accounts.sh```


or without root:

```./enumerate_accounts.sh```


Without root privileges, /etc/shadow will be skipped automatically.

### Example Output (Simplified)
```
Account:        user1
Home Directory: /home/user1
Shell:          /bin/bash

Account:      user1
Hash:         $6$abc123...
Last Changed: Mon Jan 15 2024
```

## Local Account Dictionary Attack Script

<b>Purpose</b>

Attempts to authenticate as a specific local user using a password dictionary file.

This script demonstrates how weak local passwords can be exploited once a valid username is known.

<b>How It Works</b>

1. Accepts:

    - A target username

    - A password list file

2. Attempts to switch users using su

3. Executes whoami to verify success

4. Stops immediately when valid credentials are found

### Usage

```./local_dictionary_attack.sh <username> <password_file>```

### Example:

```./local_dictionary_attack.sh user1 passwords.txt```

### Example Output
```
Beginning password attack on: user1

Success! Credentials for user1 is password123

Use su - user1 then provide the password to switch.
```

## Script Workflow
```
[Enumeration]
   ↓
Identify valid user accounts
   ↓
Select a target username
   ↓
[Dictionary Attack]
   ↓
Attempt password authentication
```

Attempting to mirror real-world attacker methodology in post-exploitation scenarios.

## Defensive Takeaways

These scripts highlight why Linux systems should:

- Enforce strong password policies

- Disable unnecessary local accounts

- Use key-based authentication where possible

- Restrict su access

- Monitor authentication logs (/var/log/auth.log)

- Implement account lockout or PAM controls

## Future Improvements

- Shadow hash parsing and algorithm identification

- Password hash cracking (offline) using extracted hashes

- Account lockout detection

- Logging and reporting

- Parallel password attempts

- Privilege escalation detection hooks

- Integration with auditing tools

## License / Usage

This repository is provided for educational and authorized security testing only.
Use responsibly and ethically.
