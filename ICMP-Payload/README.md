# ICMP Payload Script
file: ```nothingtosee.sh```

A Bash proof-of-concept demonstrating how ICMP Echo Requests can be used to transport arbitrary data within packet payloads.
This script was created as a learning tool for Bash scripting, network analysis, and understanding how data can move through various layers of network architecture.

## Overview
This script reads a file, splits it into chunks, converts each chunk into hexadecimal, and sends it inside the payload of an ICMP Echo Request using the standard ```ping``` command.
Packet payloads can be inspected using tools like Wireshark, tcpdump, or other network analyzers.

Because this uses standard ```ping```, payload size limitations and OS-level behavior may modify, pad, or truncate bytes. See future improvements for better payload control.

## Features
  - Sends file contents through ICMP Echo Requests as hexadecimal payloads
  - Adjustable payload size (```-s```)
  - Adjustable time delay between packets (```-t```)
  - Progress bar showing 10% completion increments
  - Automatic chunking and final-chunk padding
  - Clear terminal output showing ASCII → Hex conversions

## Requirements
  - Bash
  - ```xxd```
  - Execution privileges
  - A controlled lab environment if you are testing packet manipulation or experimenting with network behavior

## Usage
```./nothingtosee.sh -f <file> [-t <seconds>] [-s <integer>] <destination>```

## Arguments
Option  Required  Description

```--file```, ```-f```  Yes	Input file containing data to send

```--time-delay```, ```-t```	No	Delay between packets (default: 0.5s)

```--payload-size```, ```-s```	No	Number of ASCII bytes per ICMP packet (default: 16)

<i>destination</i>	Yes	IPv4 address to send packets to

## Notes for ```--payload-size```

Payload sizes over ~16 bytes often behave inconsistently due to limitations in the ping utility and OS-dependent padding/truncation.

For full control over payloads, consider replacing ping with:
  - ```hping3```
  - ```nping``` (part of Nmap)

These allow:
  - Raw payloads
  - TCP/UDP modes
  - Arbitrary packet construction (…but often require root privileges).

## Examples
Send a file with default timing and chunk size:

```./nothingtosee.sh -f text.txt 192.168.1.1```

Send with a 30-second interval:

```./nothingtosee.sh -f text.txt -t 30 10.0.2.5```

Send using a custom payload size:

```./nothingtosee.sh -f secret.txt -s 8 127.0.0.1```

## Personal Notes
This script was built to help demonstrate the structure of network packets to non-technical audiences and aspiring IT/Cybersecurity learners. It shows how layered architecture works and why network security is a complex topic.

## Future Improvements
  - Migrate to hping3 or nping for full payload control
  - Optional TCP/UDP modes (e.g., UDP/53 for commonly unfiltered channels)
  - Port to Python for better packet crafting and parsing
  - Add more options (packet size, custom text, binary mode)
  - Add reliability features (resend failed chunks, acknowledgments)
