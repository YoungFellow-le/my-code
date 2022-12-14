#!/bin/python3

# PORT SCANNER
# Heath thinks this is crappy...
# Probably because it doesn't utilize processor threads...

import sys
import os
import socket
from datetime import datetime as dt


if len(sys.argv) == 4:
    
    # Sanitize IP address
    
    target = sys.argv[1]
    ip_array = target.split(".")
    
    # Translate hostname to IPv4 if it is not in the normal format
    
    contains_letters = False
    for letter in target:
        if letter.isalpha():
            contains_letters = True
    
    if contains_letters:
        try:
            target = socket.gethostbyname(sys.argv[1])
        except socket.gaierror:
            print("Error: Cannot resolve hostname")
            sys.exit()
    else:
        if len(ip_array) != 4:
            print("Error: Provided IP address is not valid")
            sys.exit()
        
        # Make sure that the IP address is correctly formatted    
        
        for section in ip_array:        
            if (int(section) > 254 or int(section) < 0):
                print("Error: The provided IP address is not valid")
                sys.exit()
    
    # Check if the host is up
    
    status = os.system(f"ping -c 1 {target} &> /dev/null")
    if status != 0:
        print("Error: The provided IP address is down")
        sys.exit()
        
    # Sanitize ports
    
    start_port = int(sys.argv[2])
    end_port = int(sys.argv[3])
    
    if end_port > 65535 or end_port < 1:
        print("Error: No such port exists!")
        sys.exit()
    
    if start_port > end_port or start_port < 1:
        print("Error: The start port is larger than end port!")
        sys.exit()

else:
    print("Invalid amount of arguments!")
    print("Correct syntax: python3 scanner.py <IP> <START_PORT> <END_PORT>")
    sys.exit()

# Add a pretty banner

print("-" * 50)
print(f"Scanning target: {target}")
print(f"Time started: {str(dt.now())}")
print("-" * 50)

try:
    for port in range(start_port, (end_port + 1)): # Port range
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.setdefaulttimeout(1) # Only wait for a second
        result = s.connect_ex((target, port)) # Connect, if port is open returns 1
        if result == 0:
            print(f"Port {port} is open!")
        s.close()

except KeyboardInterrupt: # If we hit Ctrl+C
    print("\nExiting program.")
    sys.exit()