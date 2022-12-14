#!/bin/python3

# PORT SCANNER
# Heath thinks this is crappy...
# Probably because it doesn't utilize processor threads...

import sys
import os
import socket
from datetime import datetime as dt

# Define our target

if len(sys.argv) == 2:
    
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
            print("Provided IP address is not valid")
        
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
    
    
    
        
else:
    print("Invalid amount of arguments!")
    print("Correct syntax: python3 scanner.py <IP>")

# Add a pretty banner

print("-" * 50)
print(f"Scanning target: {target}")
print(f"Time started: {str(dt.now())}")
print("-" * 50)

try:
    for port in range(50, 85): # Port range
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.setdefaulttimeout(1) # Only wait for a second
        result = s.connect_ex((target, port)) # Connect, if port is open returns 1
        if result == 0:
            print(f"Port {port} is open!")
        s.close()

except KeyboardInterrupt: # If we hit Ctrl+C
    print("\nExiting program.")
    sys.exit()
    
except socket.error:
    print("Could not connect to server.")