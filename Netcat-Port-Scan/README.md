# Port Scanner (Bash & Netcat)

Script: ```port_scan.sh```

A lightweight Bash-based TCP port scanner that checks a list of ports against a target host and attempts basic banner grabbing using netcat.

This script is intended as a learning tool to understand how port scanning works at a low level and how services may expose identifying information through banners.

## Overview

The script:

1. Reads a list of ports from a file

2. Attempts to connect to each port using nc

3. Identifies open TCP ports

4. Performs a basic banner grab when a port is open

5. It avoids complex scanning logic in favor of clarity and simplicity, making it ideal for learning and lab environments.

## Learning Objectives

- Understand TCP port scanning mechanics

- Learn how banner grabbing works

- Practice Bash input validation

- Work with files and loops in shell scripts

- Understand why exposed banners are a security risk

## Legal & Ethical Disclaimer

### Only scan systems you own or have explicit authorization to test.

Unauthorized port scanning may be illegal or violate acceptable use policies.
This script is intended for:

- Personal labs

- CTF environments

- Authorized security testing

- Defensive research and education

## Requirements

- Bash

- netcat (nc)

- Network connectivity to the target host

## Input Format
```ports.txt```

A plain text file containing one port per line:
```
22
80
443
8080
```

Empty lines are ignored

Non-numeric entries are skipped automatically

## Usage
```./port_scan.sh ports.txt 192.168.100.10```

Arguments
```
  Argument    ->  Description
  ports.txt	  ->  File containing ports to scan
  ip_address	->  Target IPv4 address
```

## How It Works

1. Validates input arguments

2. Reads ports line-by-line

3. Uses nc to test TCP connectivity

4. Reports open ports

5. Attempts a simple banner grab on open ports

6. Prints results in a readable format

- Each port connection uses a 1-second timeout to keep scans responsive.

## Example Output
```
Beginning Port Scan on 192.168.100.10

192.168.100.10:22 is open
       Banner:
       ---------------------
       SSH-2.0-OpenSSH_8.2p1
       ---------------------

192.168.100.10:80 is open
       (No banner received)

Port Scan Complete.
```

## Defensive Takeaways

This script demonstrates why systems should:

- Minimize exposed services

- Disable unnecessary ports

- Remove verbose service banners

- Use firewalls and network segmentation

- Monitor connection attempts

- Banner information can significantly aid attackers during reconnaissance.

## Future Improvements

- UDP scanning support

- Parallel scanning for speed

- Service fingerprinting

- Output to file (JSON / CSV)

- Configurable timeout values

- IPv6 support

- Optional verbose / quiet modes

## License / Usage

This script is provided for educational and authorized testing only.
Use responsibly and ethically.
