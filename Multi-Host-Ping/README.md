# Multi-Host Ping Sweep Script

Script: ```ping_sweep.sh```

A simple Bash script that performs an ICMP ping sweep against a list of hosts to identify which systems are reachable.

This script is designed as a learning tool to understand host discovery and basic network reconnaissance using ICMP echo requests.

## Overview

The script:

1. Reads hostnames or IP addresses from a file

2. Sends a single ICMP echo request to each host

3. Reports which hosts respond

4. Suppresses unnecessary output for clean results

5. Only hosts that respond to ICMP are displayed.

## Learning Objectives

- Understand ICMP-based host discovery

- Learn how ping sweeps are used during reconnaissance

- Practice Bash scripting with files and loops

- Learn basic input validation

- Understand the limitations of ICMP reachability checks

## Legal & Ethical Disclaimer

- Only perform ping sweeps on networks you own or have explicit authorization to test.

- Unauthorized network reconnaissance may violate policies or laws.

- This script is intended for:

    - Home labs

    - CTF environments

    - Authorized penetration testing practice

    - Defensive network analysis

## Requirements

- Bash

- ping

- Network connectivity to target hosts

## Input File Format
```hosts.txt```

A plain text file containing one hostname or IP address per line:
```
192.168.1.1
192.168.1.10
example.com
10.0.0.5
```

The script does not validate whether entries are valid IP addresses or hostnames—it only checks for ICMP responses.

## Usage
```./ping_sweep.sh hosts.txt```

Arguments
```
  Argument   ->  	Description
  hosts.txt	 ->   File containing hosts to ping
```
## How It Works

1. Verifies the input file exists

2. Reads each host line-by-line

3. Sends one ICMP echo request per host

4. Waits up to 1 second for a response

5. Prints only responsive hosts

6. All standard output and error messages from ping are suppressed to keep results clean.

## Example Output
```
Beginning Multi-Host Ping.

192.168.1.1 is up.
192.168.1.10 is up.

Multi-Host Ping Complete.
```
## Important Limitations

- Hosts may block ICMP and still be online

- Firewalls may suppress echo replies

- No parallelization (hosts are checked sequentially)

- No output for unreachable hosts

- ICMP reachability ≠ host availability.

## Future Improvements

- Parallel pinging for faster sweeps

- Timeout customization

- Output to file (CSV / JSON)

- IPv6 support

- CIDR range expansion

- Optional verbose mode

- Down-host reporting

## License / Usage

This script is provided for educational and authorized use only.
Use responsibly and ethically.
