# SSH Dictionary Attack Script
Script: ```taylor_swift.sh```

### Named as such for those beautiful nights when feeling 22 <i>(Port 22)</i>

## Overview

This Bash script is a proof-of-concept SSH dictionary attack tool created for learning and lab-based experimentation.
It demonstrates how automated credential testing works against SSH services by iterating through combinations of:

- Hosts

- Usernames

- Passwords

The script attempts SSH authentication using sshpass and reports successful credentials both locally and via a Discord webhook notification.

NOTE: This script is for educational and authorized testing only.

## Learning Objectives

This project was built to better understand:

- SSH authentication mechanisms

- Brute-force and dictionary attack methodology

- Bash scripting with arrays and functions

- Nested iteration logic

- External tool integration (sshpass, curl, jq)

- Script timing and execution measurement

- Real-time alerting via webhooks

## Legal & Ethical Disclaimer

### DO NOT run this script against systems you do not own or have explicit permission to test.

Unauthorized brute-force attempts against SSH services are illegal and unethical.

This script is intended for:

- Personal labs

- Capture-the-Flag (CTF) environments

- Authorized penetration testing practice

- Defensive understanding of attack techniques

- You are responsible for how you use this code.

## Requirements

- Bash

- sshpass

- curl

- jq

- Network access to target SSH services

- Valid Discord webhook URL (optional, for notifications)

## Input Files

The script relies on three external wordlists:
```
  hosts.txt      ->  List of target IP addresses
  usernames.txt  ->  List of usernames
  passwords.txt	 ->  List of passwords
```
Each entry should be on its own line.

## Configuration

At the top of the script:
```
WEBHOOK_URL="<YOUR-OWN-DISCORD-WEBHOOK-URL>"
TIMEOUT="5"
PORT="22"
```

WEBHOOK_URL: Discord webhook for alerts (optional)

TIMEOUT: SSH connection timeout in seconds

PORT: SSH port (default: 22)

# How It Works

1. Reads hosts, usernames, and passwords into arrays

2. Iterates through:

    - Each username

    - Each password

    - Each host

3. Attempts SSH login using sshpass

4. On success:

    - Prints credentials to terminal

    - Sends notification to Discord

    - Terminates execution

5. Measures total execution time

A short delay (0.2s) is enforced between attempts to reduce hammering.

## Discord Notifications

When valid credentials are discovered, the script sends a message containing:

- Host IP

- Username

- Password

- UTC timestamp

This enables near real-time alerting during longer attack runs.

## Example Output (Simplified)
```
[*] Attempting Username: 'admin' Password: 'password123'
[*] Attempting Host: '192.168.1.10'

[+] Successful login!
[+] Host: 192.168.1.10
[+] Username: 'admin'
[+] Password: 'password123'

Notification sent to Discord.
```

## Defensive Takeaways

From a defensive perspective, this script highlights why SSH services should:

- Disable password authentication where possible

- Enforce strong passwords

- Implement account lockout policies

- Use key-based authentication

- Monitor failed login attempts

- Restrict access via firewalls or VPNs

## Future Improvements

- Quiet and verbose modes

- Improved timing management and throttling

- Continue execution after finding credentials

- Remove compromised hosts from target list

- Command-line options and default settings

- Built-in default wordlists

- Input file validation and fault tolerance

- Progress bar and attempt counters
